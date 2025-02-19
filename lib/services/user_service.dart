import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constants.dart';

class UserService {

  Future<Map<String, dynamic>> loanBook(int userId, int bookId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$userId/loan/$bookId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      return _processResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred while loaning the book',
      };
    }
  }

  // Devolver un libro prestado
  Future<Map<String, dynamic>> returnBook(String userId, int bookId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/$userId/return/$bookId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      return _processResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred while returning the book',
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
