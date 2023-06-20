import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:card_loading/card_loading.dart';
import 'package:appfood/widgets/LoadingCard.dart';
import 'package:appfood/models/Comida.dart';

class Comidas extends StatefulWidget {
  const Comidas({Key? key});

  @override
  State<Comidas> createState() => _ComidasState();
}

class _ComidasState extends State<Comidas> {
  late List<Comida> comidas;

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
        Comida comida = Comida(
          item['id'],
          item['descripcion'],
          item['nombre'],
          item['precio'],
          item['urlImage'],
        );
        listaComidas.add(comida);
      }
      return listaComidas;
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  }

  Future<void> eliminarComida(int index) async {
    if (index >= 0 && index < comidas.length) {
      Comida comida = comidas[index];
      var url = Uri.parse(
          'https://pnrxncugq7.execute-api.us-east-1.amazonaws.com/prueba/comida/?id=${comida.id}');
      var response = await http.delete(url);

      if (response.statusCode == 200) {
        setState(() {
          comidas.removeAt(index);
        });
       
      } else {
        
      }
    }
  }

  Future<void> editarComida(int index) async {
    List<Comida>? comidasList = await fetchData();
    if (index >= 0 && index < comidasList.length) {
      Comida comida = comidasList[index];

      // ignore: use_build_context_synchronously
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
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  comida.nombre = nombreController.text;
                  comida.descripcion = descripcionController.text;
                  comida.precio = precioController.text;
                  comida.urlImage = urlImageController.text;

                  var url = Uri.parse(
                      'https://pnrxncugq7.execute-api.us-east-1.amazonaws.com/prueba/comida');
                  var response = await http.patch(
                    url,
                    body: json.encode({
                      'id': comida.id,
                      'nombre': comida.nombre,
                      'descripcion': comida.descripcion,
                      'precio': comida.precio,
                      'urlImage': comida.urlImage,
                    }),
                  );
                  if (response.statusCode == 200) {
                    setState(() {
                      comidasList[index] = comida;
                    });
                    print('Comida actualizada');
                  } else {
                    print('Error al actualizar comida');
                  }

                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
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
              return  Column(
                children:[
                  cardloaging(),
                ] 
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Comida>? comidasList = snapshot.data;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: comidasList?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  Comida comida = comidasList![index];
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comida.nombre,
                                style: GoogleFonts.montserrat(),
                              ),
                             const SizedBox(height: 4),
                              Text(
                                comida.descripcion,
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
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Eliminar Comida'),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text(
                                              "Estas seguro de eliminar esta comida")
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            eliminarComida(index);
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Eliminar'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              label: const Text(''),
                              icon: const Icon(Icons.delete_outline),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                editarComida(index);
                              },
                              label:const Text(''),
                              icon: const Icon(Icons.edit),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
