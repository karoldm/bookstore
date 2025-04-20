import 'package:flutter/widgets.dart';
import 'package:mybookstore/data/models/book_model.dart';
import 'package:mybookstore/data/models/request_book_model.dart';
import 'package:mybookstore/interfaces/repositories/books_repository_interface.dart';
import 'package:mybookstore/interfaces/services/books_service_interface.dart';

class BooksService implements BooksServiceInterface {
  final BooksRepositoryInterface _booksRepository;

  BooksService(this._booksRepository);

  @override
  Future<List<BookModel>> fetchBooks(int storeId, {int? limit, int? offset}) {
    try {
      return _booksRepository.fetchBooks(storeId, limit: limit, offset: offset);
    } catch (e) {
      debugPrint('Failed to fetch books on books service: $e');
      rethrow;
    }
  }

  @override
  Future<BookModel> createBook(int storeId, RequestBookModel book) {
    try {
      return _booksRepository.createBook(storeId, book);
    } catch (e) {
      debugPrint('Failed to create book on service: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteBook(int storeId, int bookId) {
    try {
      return _booksRepository.deleteBook(storeId, bookId);
    } catch (e) {
      debugPrint('Failed to delete book on service: $e');
      rethrow;
    }
  }

  @override
  Future<BookModel> updateBook(
    int storeId,
    int bookId,
    RequestBookModel book,
  ) async {
    try {
      await _booksRepository.updateBook(storeId, bookId, book);
      Map<String, dynamic> updatedbook = book.toMap();
      updatedbook['id'] = bookId;
      return BookModel.fromMap(updatedbook);
    } catch (e) {
      debugPrint('Failed to update book on service: $e');
      rethrow;
    }
  }
}
