import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:appfood/pages/Comidas.dart';
import 'package:appfood/pages/CreateComida.dart';
import 'package:google_fonts/google_fonts.dart';
class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  @override
  Widget build(BuildContext context) {
     return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          children: <Widget>[
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 80.0),
                  Text(
                    "Appfood",
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    '"Explora nuestro extenso catálogo de platos exquisitos en AppFood y encuentra tu próxima comida favorita."',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            _swipper(),
            Image.network("https://mir-s3-cdn-cf.behance.net/project_modules/disp/0845c232253239.56766f2d063c9.gif"),
            Column(
            
              children: [
                Row(
                  
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children:
                  
                   [
                    ElevatedButton.icon(
                      icon: Icon(Icons.create),
                      label:  Text("Agregar Comidas",style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Bebidas()))
                      },
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.wallet_sharp),
                      label:  Text("Catalogo de Comidas",style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Comidas()))
                      },
                    ),
                   
                  ],
                )
              ],
            )
          ],
        )),
      ),
    );
  }
}



  Widget _swipper() {
    List<String> imageUrls = [
      "https://www.menuspararestaurantes.com/wp-content/uploads/2022/12/promociones-en-tu-restaurante-combos2.jpg",
      "https://cazaofertas.com.mx/wp-content/uploads/2020/03/Beer-Factory-lunes-090320-01.jpg",
      "https://img.freepik.com/vector-premium/plantilla-banner-restaurante-menu-comida-promociones-diseno-web-redes-sociales_553310-679.jpg?w=2000",
      "https://img.freepik.com/psd-gratis/plantilla-publicacion-banner-redes-sociales-alimentos_202595-358.jpg?w=2000",
    ];
    return Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            // Envuelve el Swiper en un Container
            height: 300, // Establece una altura limitada
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                return Image.network(
                  imageUrls[index],
                  fit: BoxFit.fill,
                );
              },
              itemCount: imageUrls.length,
              pagination: const SwiperPagination(),
              control: const SwiperControl(),
            ),
          ),
          // Resto del código...
        ],
      ),
    );
  }

// 