import 'package:mybookstore/data/models/request_book_model.dart';

abstract class BooksEvents {}

class FetchBooksEvent extends BooksEvents {
  final int storeId;
  int? page;
  int? offset;
  final bool? isLoadingMore;
  final Map<String, dynamic>? filters;

  FetchBooksEvent({
    required this.storeId,
    this.isLoadingMore,
    this.page,
    this.offset,
    this.filters,
  });
}

class UpdateBookEvent extends BooksEvents {
  final RequestBookModel book;
  final int storeId;
  final int bookId;

  UpdateBookEvent({
    required this.bookId,
    required this.storeId,
    required this.book,
  });
}

class AddBookEvent extends BooksEvents {
  final RequestBookModel book;
  final int storeId;

  AddBookEvent({required this.storeId, required this.book});
}

class DeleteBookEvent extends BooksEvents {
  final int storeId;
  final int bookId;

  DeleteBookEvent({required this.storeId, required this.bookId});
}
