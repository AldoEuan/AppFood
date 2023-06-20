import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

Widget Promocion() {
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
