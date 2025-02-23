import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../services/user_service.dart';
import 'package:biblioteca_grupo_5/models/book_model.dart';
import '../widgets/book_card.dart';
import '/screens/login_screen.dart';

class UserScreen extends StatefulWidget {
  final String token;
  UserScreen({required this.token});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserService userService = UserService();
  List<Book> availableBooks = [];
  List<Book> myBooks = [];
  late String userEmail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _decodeUserEmail();
  }

  void _decodeUserEmail() async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);

    if (decodedToken.containsKey('sub') && decodedToken['sub'] != null) {
      userEmail = decodedToken['sub'];
      await _fetchBooksData();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _logout() async {
    final confirmation = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmation == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  Future<void> _fetchBooksData() async {
    try {
      setState(() => isLoading = true);
      availableBooks = await userService.getAvailableBooks();
      myBooks = await userService.getMyBooks(userEmail, widget.token);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _loanBook(int bookId) async {
    final success = await userService.loanBook(bookId, widget.token);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book loaned successfully!')),
      );
      _fetchBooksData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to loan book')),
      );
    }
  }

  void _returnBook(int bookId) async {
    final success = await userService.returnBook(bookId, widget.token);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Book returned successfully!')),
      );
      _fetchBooksData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to return book')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.brown.shade300, Colors.brown.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                'User Panel',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.white),
                  onPressed: _logout,
                ),
              ],
              backgroundColor: Colors.brown.shade700,
              bottom: TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(text: 'Available Books'),
                  Tab(text: 'My Books'),
                ],
              ),
            ),
            body: isLoading
                ? Center(child: CircularProgressIndicator())
                : TabBarView(
                    children: [
                      _buildBooksList(availableBooks, true),
                      _buildBooksList(myBooks, false),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildBooksList(List<Book> books, bool isAvailableTab) {
    if (books.isEmpty) {
      return Center(
        child: Text(
          isAvailableTab ? "No books available" : "No books borrowed",
          style: TextStyle(fontSize: 18, color: Colors.brown.shade900),
        ),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return BookCard(
          book: book,
          onLoan: isAvailableTab
              ? () => _loanBook(book.id)
              : () => _returnBook(book.id),
          isAvailableTab: isAvailableTab,
        );
      },
    );
    }
}