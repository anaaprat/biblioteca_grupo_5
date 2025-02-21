import 'package:biblioteca_grupo_5/models/book_model.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onLoan;
  final bool isAvailableTab; // Diferenciar Loan/Return

  BookCard({
    required this.book,
    required this.onLoan,
    required this.isAvailableTab,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.brown.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                'assets/images/${book.image}',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/default.png',
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade900,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                SizedBox(height: 6),
                Text(
                  'Author: ${book.author}',
                  style: TextStyle(fontSize: 16, color: Colors.brown.shade700),
                ),
                Text(
                  'Genre: ${book.genre}',
                  style: TextStyle(fontSize: 16, color: Colors.brown.shade600),
                ),
                Text(
                  'Published: ${book.yearPublished}',
                  style: TextStyle(fontSize: 14, color: Colors.brown.shade500),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton(
              onPressed: onLoan,
              style: ElevatedButton.styleFrom(
                backgroundColor: isAvailableTab
                    ? const Color.fromARGB(255, 86, 160, 88)
                    : const Color.fromARGB(255, 203, 90, 81),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Center(
                child: Text(
                  isAvailableTab ? 'Loan' : 'Return',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
