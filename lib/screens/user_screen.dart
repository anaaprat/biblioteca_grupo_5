import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5DC), // Beige background
      appBar: AppBar(
        title: Text("User Dashboard"),
        backgroundColor: Color(0xFF6D4C41), // Dark brown
      ),
      body: Center(
        child: Text(
          "Welcome, User!",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
