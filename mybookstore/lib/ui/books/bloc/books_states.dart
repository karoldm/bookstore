import 'package:mybookstore/data/models/book_model.dart';

abstract class BooksStates {}

class BooksLoadingState extends BooksStates {}

class BooksLoadedState extends BooksStates {
  final List<BookModel> books;

  BooksLoadedState({required this.books});
}

class BookCreateErrorState extends BooksStates {
  final String message;

  BookCreateErrorState({required this.message});
}

class BookCreateSuccessState extends BooksStates {
  BookCreateSuccessState();
}

class BooksLoadingErrorState extends BooksStates {
  final String message;

  BooksLoadingErrorState({required this.message});
}
