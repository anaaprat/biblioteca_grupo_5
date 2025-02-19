import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constants.dart';

class BookService {
  // Obtener los libros disponibles
  Future<Map<String, dynamic>> getAvailableBooks() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/books/available'),
        headers: {
          'Accept': 'application/json',
        },
      );
      return _processResponse(response);
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred while fetching available books',
      };
    }
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    try {
      final decodedResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': decodedResponse,
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to fetch available books',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error while processing the response',
      };
    }
  }
}
