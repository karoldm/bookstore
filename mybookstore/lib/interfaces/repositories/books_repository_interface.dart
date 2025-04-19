import 'package:mybookstore/data/models/book_model.dart';
import 'package:mybookstore/data/models/request_book_model.dart';

abstract class BooksRepositoryInterface {
  Future<List<BookModel>> fetchBooks(int storeId, {int? limit, int? offset});
  Future<BookModel> createBook(int storeId, RequestBookModel book);
}
