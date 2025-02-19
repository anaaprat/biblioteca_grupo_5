import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constants.dart';

class AdminService {
  Future<List<dynamic>> getUsers(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/admin/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        List<dynamic> users = jsonDecode(response.body);
        return users.map((user) {
          return {
            'id': user['id'],
            'email': user['email'] ?? 'Unknown Email',
            'activated': user['activated'] ?? false,
            'role': user['role'] ?? 'USER',
          };
        }).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  Future<bool> activateUser(int id, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/admin/activate/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deactivateUser(int id, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/admin/deactivate/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
