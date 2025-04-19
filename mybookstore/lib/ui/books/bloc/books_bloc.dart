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
      } catch (e) {
        emit(BooksLoadingErrorState(message: e.toString()));
      } finally {
        emit(BooksLoadedState(books: books));
      }
    });

    on<UpdateBookEvent>((event, emit) async {
      try {
        emit(BooksLoadingState());

        BookModel updatedBook = await booksService.updateBook(
          event.storeId,
          event.bookId,
          event.book,
        );

        int index = books.indexWhere((book) => book.id == event.bookId);

        if (index != -1) {
          books[index] = updatedBook;
        } else {
          emit(BookUpdateErrorState(message: 'Book not found'));
          return;
        }

        emit(BookUpdateSuccessState());
      } catch (e) {
        emit(BookUpdateErrorState(message: e.toString()));
      } finally {
        emit(BooksLoadedState(books: books));
      }
    });

    on<AddBookEvent>((event, emit) async {
      try {
        emit(BooksLoadingState());

        BookModel book = await booksService.createBook(
          event.storeId,
          event.book,
        );

        books.add(book);
        emit(BookCreateSuccessState());
      } catch (e) {
        emit(BookCreateErrorState(message: e.toString()));
      } finally {
        emit(BooksLoadedState(books: books));
      }
    });

    on<DeleteBookEvent>((event, emit) async {
      try {
        emit(BooksLoadingState());

        await booksService.deleteBook(event.storeId, event.bookId);

        books.removeWhere((book) => book.id == event.bookId);
      } catch (e) {
        emit(BooksLoadingErrorState(message: e.toString()));
      } finally {
        emit(BooksLoadedState(books: books));
      }
    });
  }
}
