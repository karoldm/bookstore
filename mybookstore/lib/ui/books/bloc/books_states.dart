import 'package:mybookstore/data/models/book_model.dart';

abstract class BooksStates {
  final List<BookModel> books;
  BooksStates({required this.books});
}

class BooksInitialState extends BooksStates {
  BooksInitialState() : super(books: []);
}

class BooksLoadingMoreState extends BooksStates {
  BooksLoadingMoreState({required super.books});
}

class BooksLoadingState extends BooksStates {
  BooksLoadingState({required super.books});
}

class BooksLoadedState extends BooksStates {
  BooksLoadedState({required super.books});
}

class BookCreateErrorState extends BooksStates {
  final String message;

  BookCreateErrorState({required super.books, required this.message});
}

class BookCreateSuccessState extends BooksStates {
  BookCreateSuccessState({required super.books});
}

class BooksLoadingErrorState extends BooksStates {
  final String message;

  BooksLoadingErrorState({required super.books, required this.message});
}

class BookUpdateErrorState extends BooksStates {
  final String message;

  BookUpdateErrorState({required super.books, required this.message});
}

class BookUpdateSuccessState extends BooksStates {
  BookUpdateSuccessState({required super.books});
}

class BookDeleteErrorState extends BooksStates {
  final String message;

  BookDeleteErrorState({required super.books, required this.message});
}

class BookDeleteSuccessState extends BooksStates {
  BookDeleteSuccessState({required super.books});
}
