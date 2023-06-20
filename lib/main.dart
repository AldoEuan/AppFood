import 'package:appfood/pages/CreateComida.dart';
import 'package:appfood/pages/MenuClientes.dart';
import 'package:appfood/pages/Principal.dart';
import 'package:flutter/material.dart';
import 'package:appfood/pages/MenuClientes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "my app",
      home: Inicio(),
    );
  }
}

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor:Colors.white,
        //   title: Text(""),
        // ),
        body: Center(
      child: SizedBox(
        width: 300,
        child: Column(
          children: [
            const SizedBox(height: 150.0),
            Image.network(
                "https://play-lh.googleusercontent.com/4RmW_PPjZPWxnlChGyjeWOT16hAGHrwnOleNOTurSmeYS68_be_drpH3JYTyBasS9pU"),
            const SizedBox(height: 10.0),
            TextField(
              controller: userController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                prefixIcon: Icon(Icons.person_2_sharp),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: Icon(Icons.password_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10.0),
            ElevatedButton.icon(
              onPressed: () => Loggin(context, userController,
                  passwordController), // Llamar al método postComida al presionar el botón
              label: Text(
                "Iniciar Sesión",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              icon: const Icon(Icons.login_outlined),
            ),
              const SizedBox(height: 10.0),
            
          ],
        ),
      ),
    ));
  }
}

// ignore: non_constant_identifier_names
void Loggin(BuildContext context, TextEditingController userController,
    TextEditingController passwordController) {
  String user = userController.text;
  String password = passwordController.text;
  if (user == "admin" && password == "admin") {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Principal()));
  } else if (user == "user" && password == "user") {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const MenuClientes()));
  } else {
    Alert(
            context: context,
            title: "El Perfil Ingresado no es Valido",
            desc: "Usuario o Contraseña Incorrectos")
        .show();
  }
  userController.text = "";
  passwordController.text = "";
}
