import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mybookstore/data/models/book_model.dart';
import 'package:mybookstore/interfaces/services/books_service_interface.dart';
import 'package:mybookstore/ui/books/bloc/books_events.dart';
import 'package:mybookstore/ui/books/bloc/books_states.dart';

class BooksBloc extends Bloc<BooksEvents, BooksStates> {
  final List<BookModel> books = [];

  final BooksServiceInterface booksService = GetIt.I<BooksServiceInterface>();

  BooksBloc() : super(BooksLoadingState()) {
    on<FetchBooksEvent>((event, emit) async {
      try {
        emit(BooksLoadingState());

        List<BookModel> books = await booksService.fetchBooks(event.storeId);

        this.books.clear();
        this.books.addAll(books);

        emit(BooksLoadedState(books: books));
      } catch (e) {
        emit(BooksLoadingErrorState(message: e.toString()));
      }
    });

    on<UpdateBookEvent>((event, emit) async {});

    on<AddBookEvent>((event, emit) async {
      try {
        emit(BooksLoadingState());

        BookModel book = await booksService.createBook(
          event.storeId,
          event.book,
        );

        books.add(book);
        emit(BookCreateSuccessState());
        emit(BooksLoadedState(books: books));
      } catch (e) {
        emit(BookCreateErrorState(message: e.toString()));
      }
    });
  }
}
