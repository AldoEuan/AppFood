import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:appfood/models/Comida.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:card_loading/card_loading.dart';
class Comidas extends StatefulWidget {
  const Comidas({Key? key});

  @override
  State<Comidas> createState() => _ComidasState();
}

class _ComidasState extends State<Comidas> {
  late List<Comida> comidas; // Declarar la lista como variable de instancia

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

  Future<void> eliminarComida(int index) async {
    if (comidas != null && index >= 0 && index < comidas.length) {
      Comida comida = comidas[index];
      var url = Uri.parse(
          'https://pnrxncugq7.execute-api.us-east-1.amazonaws.com/prueba/comida/?id=${comida.id}');
      var response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          comidas.removeAt(index);
        });
        print("eliminado");
      } else {
        print("Error al eliminar comida");
      }
    }
  }

  Future<void> editarComida(int index) async {
    List<Comida>? comidas = await fetchData();
    if (comidas != null && index >= 0 && index < comidas.length) {
      Comida comida = comidas[index];

      // Abre un cuadro de diálogo para editar la comida
      showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController nombreController =
              TextEditingController(text: comida.nombre);
          TextEditingController descripcionController =
              TextEditingController(text: comida.descripcion);
          TextEditingController precioController =
              TextEditingController(text: comida.precio);
          TextEditingController urlImageController =
              TextEditingController(text: comida.urlImage);

          return AlertDialog(
            title: const Text('Editar Comida'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: precioController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                ),
                TextField(
                  controller: urlImageController,
                  decoration:
                      const InputDecoration(labelText: 'URL de la imagen'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Cierra el cuadro de diálogo sin guardar cambios
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  // Realiza la actualización de la comida
                  comida.nombre = nombreController.text;
                  comida.descripcion = descripcionController.text;
                  comida.precio = precioController.text;
                  comida.urlImage = urlImageController.text;

                  // Envía los cambios al servidor (puedes adaptar esta lógica según tus necesidades)
                  var url = Uri.parse(
                      'https://pnrxncugq7.execute-api.us-east-1.amazonaws.com/prueba/comida');
                  var response = await http.patch(url,
                      body: json.encode({
                        'id': comida.id,
                        'nombre': comida.nombre,
                        'descripcion': comida.descripcion,
                        'precio': comida.precio,
                        'urlImage': comida.urlImage,
                      }));
                  if (response.statusCode == 200) {
                    setState(() {
                      // Actualiza la comida en la lista local
                      comidas[index] = comida;
                    });
                    // ignore: avoid_print
                    print('Comida actualizada');
                  } else {
                    print('Error al actualizar comida');
                  }

                  Navigator.of(context)
                      .pop(); // Cierra el cuadro de diálogo después de guardar los cambios
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Menu de AppFood'),
        ),
        body: FutureBuilder<List<Comida>>(
          future: fetchData(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Comida>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CardLoading(
  height: 600,
  borderRadius: BorderRadius.all(Radius.circular(10)),
  margin: EdgeInsets.only(bottom: 10),
),);
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Comida>? comidas = snapshot.data;
              return SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        comida.nombre,
        style: GoogleFonts.montserrat(),
      ),
      SizedBox(height: 4), // Espacio entre el título y el subtítulo
      Text(
        '${comida.descripcion}',
        style: DefaultTextStyle.of(context).style,
      ),
    ],
  ),
  subtitle: Text(
    '${comida.precio} MXN',
    style: GoogleFonts.roboto(),
  ),

),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  eliminarComida(index);
                                },
                                label: Text(''),
                                icon: Icon(Icons.delete_outline),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  editarComida(index);
                                },
                                label: Text(''),
                                icon: Icon(Icons.edit),
                              ),
                            ],
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
      ),
    );
  }
}
