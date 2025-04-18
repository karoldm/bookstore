import 'dart:io';

class BookModel {
  final File? cover;
  final String title;
  final String author;
  final int year;
  final String synopsis;
  final bool available;
  final int rating;

  BookModel({
    required this.title,
    required this.author,
    required this.year,
    required this.synopsis,
    required this.available,
    required this.rating,
    this.cover,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      title: json['title'],
      author: json['author'],
      cover: json['cover'] != null ? File(json['cover']) : null,
      year: json['year'],
      synopsis: json['synopsis'],
      available: json['available'],
      rating: json['rating'],
    );
  }

  @override
  String toString() {
    return 'BookModel(title: $title, author: $author, cover: $cover, year: $year, synopsis: $synopsis, available: $available, rating: $rating)';
  }
}
