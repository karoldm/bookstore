import 'package:bookstore/utils/format_date.dart';
import 'package:flutter/widgets.dart';
import 'package:bookstore/config/constants.dart';
import 'package:bookstore/data/models/book_model.dart';
import 'package:bookstore/data/models/request_book_model.dart';
import 'package:bookstore/interfaces/services/books_service_interface.dart';
import 'package:bookstore/interfaces/services/local_service_interface.dart';
import 'package:bookstore/interfaces/repositories/books_repository_interface.dart';

class BooksRepository implements BooksRepositoryInterface {
  final BooksServiceInterface booksService;
  final LocalServiceInterface localService;

  BooksRepository(this.booksService, this.localService);

  @override
  Future<List<BookModel>> fetchBooks(
    int storeId, {
    int? size,
    int? page,
    Map<String, dynamic>? filters,
  }) {
    try {
      return booksService.fetchBooks(
        storeId,
        size: size,
        page: page,
        filters: filters,
      );
    } catch (e) {
      debugPrint('Failed to fetch books on books repository: $e');
      rethrow;
    }
  }

  @override
  Future<BookModel> createBook(int storeId, RequestBookModel book) {
    try {
      book.releasedAt = formatDateToAPI(book.releasedAt);

      return booksService.createBook(storeId, book);
    } catch (e) {
      debugPrint('Failed to create book on repository: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteBook(int storeId, int bookId) {
    try {
      return booksService.deleteBook(storeId, bookId);
    } catch (e) {
      debugPrint('Failed to delete book on repository: $e');
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
      book.releasedAt = formatDateToAPI(book.releasedAt);

      final updatedBook = await booksService.updateBook(storeId, bookId, book);
      return updatedBook;
    } catch (e) {
      debugPrint('Failed to update book on repository: $e');
      rethrow;
    }
  }

  @override
  Future<List<int>> fetchSavedBooksId() async {
    try {
      String? ids = await localService.read(savedBooksKey);
      if (ids == null) {
        return [];
      }

      return ids.split(',').map((e) => int.parse(e)).toList();
    } catch (e) {
      debugPrint('Failed to fetch saved books on repository: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveBooks(List<int> bookIds) async {
    try {
      String ids = bookIds.join(',');
      await localService.write(key: savedBooksKey, value: ids);
    } catch (e) {
      debugPrint('Failed to save books on repository: $e');
      rethrow;
    }
  }
}
