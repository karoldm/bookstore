import 'package:bookstore/ui/_core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BookModel {
  final int id;
  String? cover;
  String title;
  String author;
  int year;
  String synopsis;
  bool available;
  int rating;
  bool isSaved = false;
  Color color;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.year,
    required this.synopsis,
    required this.available,
    required this.rating,
    this.color = AppColors.defaultColor,
    this.cover,
  });

  factory BookModel.fromMap(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      cover: json['cover'],
      year: json['year'],
      synopsis: json['synopsis'],
      available: json['available'],
      rating: json['rating'],
    );
  }

  @override
  String toString() {
    return 'BookModel(id: $id, title: $title, author: $author, cover: $cover, year: $year, synopsis: $synopsis, available: $available, rating: $rating)';
  }
}
