import 'package:flutter/widgets.dart';
import 'package:mybookstore/data/models/book_model.dart';
import 'package:mybookstore/data/models/request_book_model.dart';
import 'package:mybookstore/interfaces/repositories/books_repository_interface.dart';
import 'package:mybookstore/interfaces/services/books_service_interface.dart';

class BooksService implements BooksServiceInterface {
  final BooksRepositoryInterface booksRepository;

  BooksService(this.booksRepository);

  @override
  Future<List<BookModel>> fetchBooks(int storeId, {int? limit, int? offset}) {
    try {
      return booksRepository.fetchBooks(storeId, limit: limit, offset: offset);
    } catch (e) {
      debugPrint('Failed to fetch books on books service: $e');
      rethrow;
    }
  }

  @override
  Future<BookModel> createBook(int storeId, RequestBookModel book) {
    try {
      return booksRepository.createBook(storeId, book);
    } catch (e) {
      debugPrint('Failed to create book on service: $e');
      rethrow;
    }
  }
}
