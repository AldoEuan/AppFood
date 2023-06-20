import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:appfood/models/ComidaBusq.dart';
import 'package:appfood/models/Comida.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:card_loading/card_loading.dart';
import 'package:appfood/pages/Bebidaspag.dart';
class MenuClientes extends StatefulWidget {
  const MenuClientes({Key? key});

  @override
  State<MenuClientes> createState() => _MenuClientesState();
}

class _MenuClientesState extends State<MenuClientes> {
  late List<Comida> comidas;
  TextEditingController textController = TextEditingController();
  List<ComidaBusq>? _comidas;
  bool _showBusqueda =
      false; // Variable para controlar la visibilidad del contenedor de búsquedas

  @override
  void initState() {
    super.initState();
    fetchData().then((listaComidas) {
      setState(() {
        comidas = listaComidas;
      });
    });
  }

  Future<List<Comida>> fetchData() async {
    var url = Uri.parse(
        'https://pnrxncugq7.execute-api.us-east-1.amazonaws.com/prueba/comida');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      String body = utf8.decode(response.bodyBytes);
      final jsonData = jsonDecode(body);
      List<Comida> listaComidas = [];
      for (var item in jsonData) {
        Comida comida = Comida(item['id'], item['descripcion'], item['nombre'],
            item['precio'], item['urlImage']);

        listaComidas.add(comida);
      }

      return listaComidas;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<List<ComidaBusq>> buscarComida(String searchText) async {
    var url = Uri.parse(
        'https://pnrxncugq7.execute-api.us-east-1.amazonaws.com/bComidas/buscadorcomida');

    // Crear un mapa con los datos que se enviarán en el cuerpo de la petición
    String nombre_comida = 'search_query';
    var requestBody = {
      nombre_comida: searchText,
    };

    // Convertir el mapa a formato JSON
    var jsonBody = jsonEncode(requestBody);

    // Realizar la solicitud POST
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    // Verificar el código de estado de la respuesta
    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      // Procesar la respuesta y crear una lista de objetos ComidaBusq
      List<ComidaBusq> comidas = [];
      for (var item in responseData) {
        ComidaBusq comida = ComidaBusq.fromJson(item);
        comidas.add(comida);
      }
      // Retornar la lista de comidas
      return comidas;
    } else {
      // La solicitud no fue exitosa, maneja el error según corresponda
      throw Exception('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Menu de AppFood'),
        ),
        body: Column(
          children: [ElevatedButton.icon(
              onPressed: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Bebidaspag()))
              }, // Llamar al método postComida al presionar el botón
              label: Text(
                "Bebidas",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(Icons.local_drink_sharp),
            ),
            AnimSearchBar(
              width: 400,
              textController: textController,
              onSuffixTap: () {},
              onSubmitted: (searchText) {
                buscarComida(searchText).then((comidas) {
                  setState(() {
                    _comidas = comidas;
                    _showBusqueda =
                        true; // Mostrar el contenedor de búsquedas al realizar la búsqueda
                  });
                }).catchError((error) {
                  // Manejar errores de solicitud aquí
                  print('Error: $error');
                });
              },
            ),
            if (_showBusqueda) // Mostrar el contenedor de búsquedas solo si la variable _showBusqueda es verdadera
              Expanded(
                child: _comidas != null && _comidas!.isNotEmpty
                    ? GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1.20,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: _comidas!.map((comida) {
                          return buildComidaBusqCard(comida);
                        }).toList(),
                      )
                    : Container(),
              ),
            FutureBuilder<List<Comida>>(
              future: fetchData(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Comida>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(children: [
                    cardloaging(),
                  ]);
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<Comida>? comidas = snapshot.data;
                  return Expanded(
                    child: SingleChildScrollView(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 1.20,
                        ),
                        itemCount: comidas?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          Comida comida = comidas![index];

                          return Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.network(
                                      comida.urlImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comida.nombre,
                                          style: GoogleFonts.montserrat(),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          comida.descripcion,
                                          style: DefaultTextStyle.of(context)
                                              .style,
                                        ),
                                      ],
                                    ),
                                    subtitle: Row(
                                      children: [
                                        const Icon(
                                            Icons.monetization_on_outlined),
                                        Text(
                                          '${comida.precio}  MXN',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Card buildComidaBusqCard(ComidaBusq comida) {
  return Card(
    child: SizedBox(
      width: 200, // Cambiar el ancho deseado
      height: 300, // Cambiar la altura deseada
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: double.infinity,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                comida.urlImage,
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    comida.nombre,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(comida.descripcion),
                ],
              ),
              subtitle: Row(
                children: [
                  const Icon(Icons.monetization_on_outlined),
                  Text(
                    '${comida.precio}  MXN',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              )),
        ],
      ),
    ),
  );
}

Widget cardloaging() {
  return Column(
    children: [
      CardLoading(
        height: 30,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        width: 100,
        margin: EdgeInsets.only(bottom: 10),
      ),
      CardLoading(
        height: 100,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        margin: EdgeInsets.only(bottom: 10),
      ),
      CardLoading(
        height: 30,
        width: 200,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        margin: EdgeInsets.only(bottom: 10),
      ),
       CardLoading(
        height: 30,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        width: 100,
        margin: EdgeInsets.only(bottom: 10),
      ),
      CardLoading(
        height: 100,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        margin: EdgeInsets.only(bottom: 10),
      ),
      CardLoading(
        height: 30,
        width: 200,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        margin: EdgeInsets.only(bottom: 10),
      ),
       CardLoading(
        height: 30,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        width: 100,
        margin: EdgeInsets.only(bottom: 10),
      ),
      CardLoading(
        height: 100,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        margin: EdgeInsets.only(bottom: 10),
      ),
      CardLoading(
        height: 30,
        width: 200,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        margin: EdgeInsets.only(bottom: 10),
      ),
       CardLoading(
        height: 30,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        width: 100,
        margin: EdgeInsets.only(bottom: 10),
      ),
      CardLoading(
        height: 100,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        margin: EdgeInsets.only(bottom: 10),
      ),
      CardLoading(
        height: 30,
        width: 200,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        margin: EdgeInsets.only(bottom: 10),
      ),
      
    ],
  );
}
