import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:appfood/models/ComidaBusq.dart';
import 'package:appfood/models/Comida.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:anim_search_bar/anim_search_bar.dart';

class MenuClientes extends StatefulWidget {
  const MenuClientes({Key? key});

  @override
  State<MenuClientes> createState() => _MenuClientesState();
}

class _MenuClientesState extends State<MenuClientes> {
  late List<Comida> comidas; // Declarar la lista como variable de instancia
  TextEditingController textController = TextEditingController();
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
        'https://pnrxncugq7.execute-api.us-east-1.amazonaws.com/prueba/buscadorcomida');

    // Crear un mapa con los datos que se enviarán en el cuerpo de la petición
    var requestBody = {
      'search_query': searchText,
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
        print('Nombre: ${comida.nombre}');
  print('Descripción: ${comida.descripcion}');
  print('Precio: ${comida.precio}');
  print('URL de imagen: ${comida.urlImage}');
  print('-----------------------');
      }
      // Retornar la lista de comidas
      print('${comidas}lll');
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              AnimSearchBar(
                width: 400,
                textController: textController,
                onSuffixTap: () {
                 
                },
                onSubmitted: (searchText) {
                  buscarComida(searchText).then((comidas) {
                    // Hacer algo con la lista de comidas
                    // Por ejemplo, actualizar el estado de tu widget y mostrar los resultados en la interfaz
                  }).catchError((error) {
                    // Manejar errores de solicitud aquí
                    print('Error: $error');
                  });
                },
              ),
              FutureBuilder<List<Comida>>(
                future: fetchData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Comida>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Comida>? comidas = snapshot.data;
                    return SingleChildScrollView(
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: comidas?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          Comida comida = comidas![index];
                          return Card(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: double.infinity, // Ancho completo
                                  child: AspectRatio(
                                    aspectRatio:
                                        16 / 9, // Relación de aspecto deseada
                                    child: Image.network(
                                      comida.urlImage,
                                      fit: BoxFit
                                          .cover, // Hace que la imagen cubra el ancho de la tarjeta
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
                                      SizedBox(
                                          height:
                                              4), // Espacio entre el título y el subtítulo
                                      Text(
                                        '${comida.descripcion}',
                                        style:
                                            DefaultTextStyle.of(context).style,
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                    '${comida.precio} MXN',
                                    style: GoogleFonts.roboto(),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
