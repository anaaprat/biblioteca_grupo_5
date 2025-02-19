import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC), // Fondo beige
      appBar: AppBar(
        title: Text("Pantalla de Prueba"),
        backgroundColor: Color(0xFF6D4C41), // Marrón oscuro
      ),
      body: Center(
        child: Text(
          "¡Bienvenido a la pantalla de prueba!",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
