import 'package:bookstore/data/models/book_model.dart';
import 'package:image_picker/image_picker.dart';

class RequestBookModel {
  XFile? cover;
  String title;
  String author;
  String releasedAt;
  String summary;
  bool available;
  int rating;

  RequestBookModel({
    required this.title,
    required this.author,
    required this.releasedAt,
    required this.summary,
    required this.available,
    required this.rating,
    this.cover,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'cover': cover,
      'releasedAt': releasedAt,
      'summary': summary,
      'available': available,
      'rating': rating,
    };
  }

  factory RequestBookModel.empty() {
    return RequestBookModel(
      title: '',
      author: '',
      releasedAt: '',
      summary: '',
      available: false,
      rating: 1,
      cover: null,
    );
  }

  factory RequestBookModel.fromBook(BookModel book) {
    return RequestBookModel(
      title: book.title,
      author: book.author,
      releasedAt: book.releasedAt,
      summary: book.summary,
      available: book.available,
      rating: book.rating,
    );
  }

  @override
  String toString() {
    return 'RegisterBookModel(title: $title, author: $author, cover: $cover, releasedAt: $releasedAt, summary: $summary, available: $available, rating: $rating)';
  }
}
