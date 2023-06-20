import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:appfood/widgets/Promocion.dart';
import 'package:pagination_flutter/pagination.dart';

class Bebida {
  late String id;
  late String nombre;
  late String precio;
  late String urlImage;

  Bebida({
    required this.nombre,
    required this.urlImage,
    required this.id,
    required this.precio,
  });
}

class Bebidaspag extends StatefulWidget {
  const Bebidaspag({Key? key});

  @override
  State<Bebidaspag> createState() => _BebidaspagState();
}

class _BebidaspagState extends State<Bebidaspag> {
  int selectedPage = 1;
  List<Bebida> bebidas = [];

  @override
  void initState() {
    super.initState();
    _fetchDataFromAPI(selectedPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bebidas"),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "¡Bienvenido al Catálogo de Bebidas de APPFOOD!",
              style: GoogleFonts.poppins(
                fontSize: 30,
                fontWeight: FontWeight.normal,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10.0),
            Pagination(
              numOfPages: 10,
              selectedPage: selectedPage,
              pagesVisible: 5,
              spacing: 10,
              onPageChanged: (page) {
                setState(() {
                  selectedPage = page;
                });

                _fetchDataFromAPI(selectedPage);
              },
              nextIcon: const Icon(
                Icons.chevron_right_rounded,
                color: Colors.blue,
                size: 20,
              ),
              previousIcon: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.blue,
                size: 20,
              ),
              activeTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              activeBtnStyle: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                shape: MaterialStateProperty.all(
                  const CircleBorder(
                    side: BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                  ),
                ),
              ),
              inactiveBtnStyle: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  const CircleBorder(
                    side: BorderSide(
                      color: Colors.blue,
                      width: 1,
                    ),
                  ),
                ),
              ),
              inactiveTextStyle: const TextStyle(
                fontSize: 14,
                color: Colors.blue,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: bebidas.length,
                itemBuilder: (ctx, index) {
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
                                bebidas[index].urlImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    bebidas[index].nombre,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                              subtitle: Row(
                                children: [
                                  const Icon(Icons.monetization_on_outlined),
                                  Text(
                                    '${bebidas[index].precio}  MXN',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Text(
              "¡Aprovecha nuestras ofertas y disfruta de refrescantes y deliciosas opciones a precios especiales!",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.normal,
                color: Colors.blue,
              ),
            ),
            Promocion(),
          ],
        ),
      ),
    );
  }

  void _fetchDataFromAPI(int page) async {
    final url =
        'https://pnrxncugq7.execute-api.us-east-1.amazonaws.com/prueba/bebidas?page=$page&page_size=2';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        setState(() {
          bebidas = jsonData.map<Bebida>((item) {
            return Bebida(
              id: item['id'],
              nombre: item['nombre'],
              precio: item['precio'],
              urlImage: item['urlImage'],
            );
          }).toList();
        });
      } else {
        // Manejar errores de la API
        // ...
      }
    } catch (error) {
      // Manejar errores de conexión u otros errores
      // ...
    }
  }
}
