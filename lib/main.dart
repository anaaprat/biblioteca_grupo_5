import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Bloquear orientación en vertical
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quita el banner de debug
      title: 'Flutter Auth',
      home: LoginScreen(), // Iniciar con la pantalla de Login
    );
  }
}
