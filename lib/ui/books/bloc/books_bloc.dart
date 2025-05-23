import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:bookstore/data/models/book_model.dart';
import 'package:bookstore/interfaces/repositories/books_repository_interface.dart';
import 'package:bookstore/ui/books/bloc/books_events.dart';
import 'package:bookstore/ui/books/bloc/books_states.dart';

class BooksBloc extends Bloc<BooksEvents, BooksStates> {
  final List<BookModel> books = [];
  final List<BookModel> filteredBooks = [];
  int page = 0;
  bool hasMore = false;
  Map<String, dynamic> filters = {};
  final int size = 5;

  final BooksRepositoryInterface bookRepository =
      GetIt.I<BooksRepositoryInterface>();

  BooksBloc() : super(BooksInitialState()) {
    on<FetchBooksEvent>(_onFetchBooks);
    on<UpdateBookEvent>(_onUpdateBook);
    on<AddBookEvent>(_onAddBook);
    on<DeleteBookEvent>(_onDeleteBook);
    on<UpdateSavedBooksEvent>(_onUpdateSavedBooks);
    on<UpdateBookAvailableEvent>(_onUpdateBookAvailable);
  }

  Future<void> _onUpdateBookAvailable(
    UpdateBookAvailableEvent event,
    Emitter<BooksStates> emit,
  ) async {
    try {
      emit(BooksLoadingState(books: books));

      BookModel updatedBook = await bookRepository.updateBookavailable(
        event.storeId,
        event.bookId,
        event.available,
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

  Future<void> _onFetchBooks(
    FetchBooksEvent event,
    Emitter<BooksStates> emit,
  ) async {
    try {
      event.isLoadingMore == true
          ? emit(BooksLoadingMoreState(books: books))
          : emit(BooksLoadingState(books: books));

      page = event.page ?? page;
      filters = event.filters ?? filters;

      List<BookModel> fetchBooks = await bookRepository.fetchBooks(
        event.storeId,
        page: page,
        filters: filters,
        size: size,
      );

      if (page == 0) {
        filteredBooks.clear();
      }

      if (event.filters != null && event.filters!.isNotEmpty) {
        filteredBooks.addAll(fetchBooks);
      } else {
        if (page == 0) {
          books.clear();
        }
        books.addAll(fetchBooks);
      }

      page++;
      hasMore = fetchBooks.length == size;
    } catch (e) {
      emit(BooksLoadingErrorState(books: books, message: e.toString()));
    } finally {
      await _onLoadSavedBooks(emit);
      (event.filters != null && event.filters!.isNotEmpty)
          ? emit(FilteredBooksState(books: books, filteredBooks: filteredBooks))
          : emit(BooksLoadedState(books: books));
    }
  }

  Future<void> _onUpdateBook(
    UpdateBookEvent event,
    Emitter<BooksStates> emit,
  ) async {
    try {
      emit(BooksLoadingState(books: books));

      BookModel updatedBook = await bookRepository.updateBook(
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

      await bookRepository.createBook(event.storeId, event.book);
      final newBooks = await bookRepository.fetchBooks(event.storeId, page: 0);
      books.clear();
      books.addAll(newBooks);
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

      await bookRepository.deleteBook(event.storeId, event.bookId);

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
      List<int> savedBooksId = await bookRepository.fetchSavedBooksId();

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

      await bookRepository.saveBooks(
        books.where((b) => b.isSaved).map((b) => b.id).toList(),
      );
    } catch (e) {
      emit(SavedBooksLoadingErrorState(books: books, message: e.toString()));
    } finally {
      emit(SavedBooksLoadedState(books: books));
    }
  }
}
