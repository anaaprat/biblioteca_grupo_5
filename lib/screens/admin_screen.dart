import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3E5AB), // Light cream background
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: Color(0xFF5D4037), // Dark brown
      ),
      body: Center(
        child: Text(
          "Welcome, Admin!",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
