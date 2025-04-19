import 'package:mybookstore/data/models/book_model.dart';
import 'package:mybookstore/data/models/request_book_model.dart';

abstract class BooksServiceInterface {
  Future<List<BookModel>> fetchBooks(int storeId);
  Future<BookModel> createBook(int storeId, RequestBookModel book);
}
