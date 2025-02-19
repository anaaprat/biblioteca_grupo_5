import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constants.dart';

class AuthService {
  // Login de usuario
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      return _processResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred during the login request'
      };
    }
  }

  // Registro de usuario
  Future<Map<String, dynamic>> registerUser(String name, String lastname,
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'lastname': lastname,
          'email': email,
          'password': password,
        }),
      );
      return _processResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred during the register request'
      };
    }
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    try {
      final decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return decodedResponse;
      } else {
        return {
          'success': false,
          'data': decodedResponse['data'] ?? 'Error',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error while processing the response',
        'statusCode': response.statusCode,
      };
    }
  }
}
