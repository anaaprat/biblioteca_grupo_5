import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_constants.dart';
import 'package:biblioteca_grupo_5/models/book_model.dart';

class UserService {
  Future<List<Book>> getAvailableBooks() async {
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/api/books/available'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((book) => Book.fromJson(book)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception('Error fetching books: $e');
    }
  }

  Future<List<Book>> getMyBooks(String userEmail, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/users/loans/$userEmail'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedData = jsonDecode(response.body);

        if (!decodedData.containsKey("loans") || decodedData["loans"] == null) {
          throw Exception("No loans data found in response");
        }

        List<dynamic> loansList = decodedData["loans"];

        return loansList.map((loan) {
          return Book.fromJson(
              loan["book"]); // Extraemos el libro dentro del loan
        }).toList();
      } else {
        throw Exception('Failed to load user books');
      }
    } catch (e) {
      throw Exception('Error fetching user books: $e');
    }
  }

  Future<bool> loanBook(int bookId, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/loan/$bookId'),
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

  Future<bool> returnBook(int bookId, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/users/return/$bookId'),
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
