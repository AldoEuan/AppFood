import 'dart:convert';
 
import 'package:appfood/pages/Comidas.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Bebidas extends StatefulWidget {
  const Bebidas({Key? key}) : super(key: key);

  @override
  State<Bebidas> createState() => _BebidasState();
}

class _BebidasState extends State<Bebidas> {
  final idController = TextEditingController();
  final nombreController = TextEditingController();
  final descripcionController = TextEditingController();
  final precioController = TextEditingController();
  final imageController = TextEditingController();
  String valoresIngresados = '';

  @override
  void dispose() {
    // Limpia el controlador cuando el Widget se descarte
    idController.dispose();
    nombreController.dispose();
    descripcionController.dispose();
    precioController.dispose();
    imageController.dispose();
    super.dispose();
  }

  Future<void> postComida() async {
    print("btn presionado");
    // Obtener los valores de los controladores de texto
    String id = idController.text;
    String nombre = nombreController.text;
    String descripcion = descripcionController.text;
    String precio = precioController.text;
    String imagen = imageController.text;

    // Crear el cuerpo de la solicitud
    var body = {
      'nombre': nombre,
      'urlImage': imagen,
      'descripcion': descripcion,
      'id': id,
      'precio': precio,
    };

    try {
      // Realizar la solicitud POST a la API
      var response = await http.post(
        Uri.parse(
            'https://pnrxncugq7.execute-api.us-east-1.amazonaws.com/prueba/comida'),
        body: json.encode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // La solicitud fue exitosa
        setState(() {
          valoresIngresados = 'Comida añadida exitosamente!';
        });
        Navigator.push(context as BuildContext,
          MaterialPageRoute(builder: (context) => const Comidas()));
      } else {
        // La solicitud falló
        setState(() {
          valoresIngresados =
              'Error al añadir comida. Código de respuesta: ${response.statusCode}';
        });
      }
    } catch (e) {
      // Ocurrió un error durante la solicitud
      setState(() {
        valoresIngresados = 'Error al añadir comida: $e';
      });
    } finally {
      print(valoresIngresados);
      print(body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Añadir Comida"),
        ),
        body: Center(
          child: SizedBox(
            width: 300,
            child: SingleChildScrollView(
              child: Column(
                children: [  const SizedBox(height: 10.0),
                  Image.network("https://cdn-icons-png.flaticon.com/512/2424/2424721.png",width: 100,),
                  const SizedBox(height: 10.0),
                   Text("Agregar Nueva Comida al Catálogo",
                      style: GoogleFonts.roboto( 
                        fontSize: 30,
                        color: Colors.blue,
                      fontWeight: FontWeight.bold,
                        )
                        ),
                  const SizedBox(height: 10.0),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: idController,
                    decoration: InputDecoration(
                      labelText: 'Id',
                      prefixIcon: Icon(Icons.add_moderator_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: nombreController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.abc_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: descripcionController,
                    decoration: InputDecoration(
                      labelText: 'Descripción',
                      prefixIcon: Icon(Icons.abc_sharp),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: precioController,
                    decoration: InputDecoration(
                      labelText: 'Precio',
                      prefixIcon: Icon(Icons.monetization_on_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextField(
                    controller: imageController,
                    decoration: InputDecoration(
                      labelText: 'Imagen',
                      prefixIcon: Icon(Icons.add_photo_alternate_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  ElevatedButton.icon(
                    onPressed:
                        postComida, // Llamar al método postComida al presionar el botón
                    icon: const Icon(Icons.add_task_outlined),
                    label:  Text("Añadir Comida",style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
