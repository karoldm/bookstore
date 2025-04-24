import 'package:bookstore/data/models/book_model.dart';
import 'package:bookstore/data/models/request_book_model.dart';

abstract class BooksServiceInterface {
  Future<List<BookModel>> fetchBooks(
    int storeId, {
    int? limit,
    int? offset,
    Map<String, dynamic>? filters,
  });
  Future<BookModel> createBook(int storeId, RequestBookModel book);
  Future<void> updateBook(int storeId, int bookId, RequestBookModel book);
  Future<void> deleteBook(int storeId, int bookId);
}
