import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl = "http://localhost:8081/api/auth"; // Reemplázalo si usas una IP externa
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  /// Registro de usuario
  Future<Map<String, dynamic>?> register(String name, String lastname, String email, String password) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "lastname": lastname,
        "email": email,
        "password": password
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  /// Inicio de sesión
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _storage.write(key: "token", value: data["token"]); // Guardar token
      return data;
    } else {
      return null;
    }
  }

  /// Obtener token almacenado
  Future<String?> getToken() async {
    return await _storage.read(key: "token");
  }

  /// Cerrar sesión
  Future<void> logout() async {
    await _storage.delete(key: "token");
  }
}
