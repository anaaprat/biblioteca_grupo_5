import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String responseText = "Presiona el botón para obtener datos";

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://tu_api_url.com/endpoint'));

    if (response.statusCode == 200) {
      setState(() {
        responseText = jsonDecode(response.body).toString();
      });
    } else {
      setState(() {
        responseText = "Error al obtener datos";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter API Test')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(responseText),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchData,
                child: Text('Llamar API'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
