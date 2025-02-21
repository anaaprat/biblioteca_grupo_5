class Book {
  final int id;
  final String title;
  final String image;
  final String author;
  final String genre;
  final String yearPublished;
  final bool available;

  Book({
    required this.id,
    required this.title,
    required this.image,
    required this.author,
    required this.genre,
    required this.yearPublished,
    required this.available,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      author: json['author'],
      genre: json['genre'],
      yearPublished: json['yearPublished'],
      available: json['available'],
    );
  }
}