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
  final int limit = 5;

  final BooksServiceInterface booksService = GetIt.I<BooksServiceInterface>();

  BooksBloc() : super(BooksInitialState()) {
    on<FetchBooksEvent>(_onFetchBooks);
    on<UpdateBookEvent>(_onUpdateBook);
    on<AddBookEvent>(_onAddBook);
    on<DeleteBookEvent>(_onDeleteBook);
    on<UpdateSavedBooksEvent>(_onUpdateSavedBooks);
  }

  Future<void> _onFetchBooks(
    FetchBooksEvent event,
    Emitter<BooksStates> emit,
  ) async {
    try {
      if (event.isLoadingMore == true) {
        emit(BooksLoadingMoreState(books: this.books));
      } else {
        emit(BooksLoadingState(books: this.books));
      }

      offset = event.offset ?? offset;

      List<BookModel> books = await booksService.fetchBooks(
        event.storeId,
        offset: offset,
        filters: event.filters,
        limit: limit,
      );

      if (event.isLoadingMore == null || event.isLoadingMore == false) {
        this.books.clear();
      }
      this.books.addAll(books);

      offset += limit;
      hasMore = books.length == limit;
    } catch (e) {
      emit(BooksLoadingErrorState(books: books, message: e.toString()));
    } finally {
      emit(BooksLoadedState(books: books));
      _onLoadSavedBooks(emit);
      emit(SavedBooksLoadedState(books: books));
    }
  }

  Future<void> _onUpdateBook(
    UpdateBookEvent event,
    Emitter<BooksStates> emit,
  ) async {
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
  }

  Future<void> _onAddBook(AddBookEvent event, Emitter<BooksStates> emit) async {
    try {
      emit(BooksLoadingState(books: books));

      BookModel book = await booksService.createBook(event.storeId, event.book);

      books.add(book);
      emit(BookCreateSuccessState(books: books));
    } catch (e) {
      emit(BookCreateErrorState(books: books, message: e.toString()));
    } finally {
      emit(BooksLoadedState(books: books));
    }
  }

  Future<void> _onDeleteBook(
    DeleteBookEvent event,
    Emitter<BooksStates> emit,
  ) async {
    try {
      emit(BooksLoadingState(books: books));

      await booksService.deleteBook(event.storeId, event.bookId);

      books.removeWhere((book) => book.id == event.bookId);

      emit(BookDeleteSuccessState(books: books));
    } catch (e) {
      emit(BookDeleteErrorState(books: books, message: e.toString()));
    } finally {
      emit(BooksLoadedState(books: books));
    }
  }

  Future<void> _onLoadSavedBooks(Emitter<BooksStates> emit) async {
    try {
      emit(SavedBooksLoadingState(books: books));

      List<int> savedBooksId = await booksService.fetchSavedBooksId();

      for (var book in books) {
        if (savedBooksId.contains(book.id)) {
          book.isSaved = true;
        }
      }
    } catch (e) {
      emit(SavedBooksLoadingErrorState(books: books, message: e.toString()));
    }
  }

  Future<void> _onUpdateSavedBooks(
    UpdateSavedBooksEvent event,
    Emitter<BooksStates> emit,
  ) async {
    try {
      emit(SavedBooksLoadingState(books: books));

      BookModel book = books.firstWhere((b) => b.id == event.bookId);
      book.isSaved = !book.isSaved;

      await booksService.saveBooks(
        books.where((b) => b.isSaved).map((b) => b.id).toList(),
      );
    } catch (e) {
      emit(SavedBooksLoadingErrorState(books: books, message: e.toString()));
    } finally {
      emit(SavedBooksLoadedState(books: books));
    }
  }
}
