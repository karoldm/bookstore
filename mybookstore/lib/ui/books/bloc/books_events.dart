import 'package:mybookstore/data/models/request_book_model.dart';

abstract class BooksEvents {}

class FetchBooksEvent extends BooksEvents {
  final int storeId;
  int? page;
  int? offset;

  FetchBooksEvent({required this.storeId, this.page, this.offset});
}

class UpdateBookEvent extends BooksEvents {}

class AddBookEvent extends BooksEvents {
  final RequestBookModel book;
  final int storeId;

  AddBookEvent({required this.storeId, required this.book});
}
