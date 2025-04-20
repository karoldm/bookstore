import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mybookstore/data/models/book_model.dart';
import 'package:mybookstore/interfaces/services/books_service_interface.dart';
import 'package:mybookstore/ui/books/bloc/books_events.dart';
import 'package:mybookstore/ui/books/bloc/books_states.dart';

class BooksBloc extends Bloc<BooksEvents, BooksStates> {
  final List<BookModel> books = [];
  int offset = 0;
  bool hasMore = false;

  final BooksServiceInterface booksService = GetIt.I<BooksServiceInterface>();

  BooksBloc() : super(BooksInitialState()) {
    on<FetchBooksEvent>((event, emit) async {
      try {
        if (event.isLoadingMore == true) {
          emit(BooksLoadingMoreState(books: this.books));
        } else {
          emit(BooksLoadingState(books: this.books));
        }

        List<BookModel> books = await booksService.fetchBooks(
          event.storeId,
          offset: offset,
        );

        this.books.addAll(books);
        offset += books.length;
        hasMore = books.isNotEmpty;
      } catch (e) {
        emit(BooksLoadingErrorState(books: books, message: e.toString()));
      } finally {
        emit(BooksLoadedState(books: books));
      }
    });

    on<UpdateBookEvent>((event, emit) async {
      try {
        emit(BooksLoadingState(books: books));

        BookModel updatedBook = await booksService.updateBook(
          event.storeId,
          event.bookId,
          event.book,
        );

        int index = books.indexWhere((book) => book.id == event.bookId);

        if (index != -1) {
          books[index] = updatedBook;
        } else {
          emit(BookUpdateErrorState(books: books, message: 'Book not found'));
          return;
        }

        emit(BookUpdateSuccessState(books: books));
      } catch (e) {
        emit(BookUpdateErrorState(books: books, message: e.toString()));
      } finally {
        emit(BooksLoadedState(books: books));
      }
    });

    on<AddBookEvent>((event, emit) async {
      try {
        emit(BooksLoadingState(books: books));

        BookModel book = await booksService.createBook(
          event.storeId,
          event.book,
        );

        books.add(book);
        emit(BookCreateSuccessState(books: books));
      } catch (e) {
        emit(BookCreateErrorState(books: books, message: e.toString()));
      } finally {
        emit(BooksLoadedState(books: books));
      }
    });

    on<DeleteBookEvent>((event, emit) async {
      try {
        emit(BooksLoadingState(books: books));

        await booksService.deleteBook(event.storeId, event.bookId);

        books.removeWhere((book) => book.id == event.bookId);
      } catch (e) {
        emit(BooksLoadingErrorState(books: books, message: e.toString()));
      } finally {
        emit(BooksLoadedState(books: books));
      }
    });
  }
}
