import 'package:flutter/material.dart';
import '../services/book_service.dart';
import '../services/user_service.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  List<dynamic> books = [];
  final BookService _bookService = BookService();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    fetchAvailableBooks();
  }

  Future<void> fetchAvailableBooks() async {
    final response = await _bookService.getAvailableBooks();
    if (response['success']) {
      setState(() {
        books = response['data'];
      });
    }
  }

  Future<void> loanBook(int userId, int bookId) async {
    final response = await _userService.loanBook(userId, bookId);
    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book loaned successfully!')),
      );
      fetchAvailableBooks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Books'),
        backgroundColor: Colors.brown.shade700,
      ),
      body: books.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                final user = books[index];

                return Card(
                  color: Colors.brown.shade100,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(10)),
                        child: Image.network(
                          book['image'],
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book['title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            SizedBox(height: 5),
                            Text('Author: ${book['author']}',
                                style: TextStyle(fontSize: 14)),
                            Text('Genre: ${book['genre']}',
                                style: TextStyle(fontSize: 14)),
                            Text('Year Published: ${book['yearPublished']}',
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: ElevatedButton(
                            onPressed: () => loanBook(user['id'], book['id']),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.brown.shade400),
                            child: Text('Loan',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
