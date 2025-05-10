import 'package:bookstore/data/models/book_model.dart';
import 'package:bookstore/data/models/request_book_model.dart';

abstract class BooksServiceInterface {
  Future<List<BookModel>> fetchBooks(
    int storeId, {
    int? size,
    int? page,
    Map<String, dynamic>? filters,
  });
  Future<BookModel> createBook(int storeId, RequestBookModel book);
  Future<BookModel> updateBook(int storeId, int bookId, RequestBookModel book);
  Future<void> deleteBook(int storeId, int bookId);
  Future<BookModel> updateBookavailable(
    int storeId,
    int bookId,
    bool available,
  );
}
