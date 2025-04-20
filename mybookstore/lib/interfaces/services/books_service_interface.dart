import 'package:mybookstore/data/models/book_model.dart';
import 'package:mybookstore/data/models/request_book_model.dart';

abstract class BooksServiceInterface {
  Future<List<BookModel>> fetchBooks(
    int storeId, {
    int? offset,
    int? limit,
    String? filters,
  });
  Future<BookModel> createBook(int storeId, RequestBookModel book);
  Future<BookModel> updateBook(int storeId, int bookId, RequestBookModel book);
  Future<void> deleteBook(int storeId, int bookId);
}
