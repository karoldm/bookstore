import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/data/models/book_model.dart';
import 'package:mybookstore/data/models/request_book_model.dart';
import 'package:mybookstore/enums/role_enum.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_states.dart';
import 'package:mybookstore/ui/_core/theme/app_fonts.dart';
import 'package:mybookstore/ui/_core/widgets/app_bar_widget.dart';
import 'package:mybookstore/ui/_core/widgets/confirm_modal_widget.dart';
import 'package:mybookstore/ui/_core/widgets/loading_button_widget.dart';
import 'package:mybookstore/ui/_core/widgets/rating_bar_widget.dart';
import 'package:mybookstore/ui/books/bloc/books_bloc.dart';
import 'package:mybookstore/ui/books/bloc/books_events.dart';
import 'package:mybookstore/ui/books/bloc/books_states.dart';
import 'package:mybookstore/ui/books/book_form_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final BookModel book;
  final bool? onlySavedBooks;

  const BookDetailScreen({
    super.key,
    required this.book,
    this.onlySavedBooks = false,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late BookModel currentBook;
  int? next;
  int? previous;

  @override
  void initState() {
    super.initState();
    currentBook = widget.book;
  }

  void onChangeBook(List<BookModel> books, bool isNext) {
    if (widget.onlySavedBooks == true) {
      books = books.where((book) => book.isSaved).toList();
    }
    if (isNext) {
      onNext(books);
    } else {
      onPrevious(books);
    }
  }

  void onNext(List<BookModel> books) {
    next = books.indexOf(currentBook) + 1;
    if (next != null && next! < books.length) {
      setState(() {
        currentBook = books[next!];
      });
    } else {
      next = null;
    }
  }

  void onPrevious(List<BookModel> books) {
    previous = books.indexOf(currentBook) - 1;
    if (previous != null && previous! >= 0) {
      setState(() {
        currentBook = books[previous!];
      });
    } else {
      previous = null;
    }
  }

  Widget getImageBook(BookModel? book) {
    return book?.cover != null
        ? Image.memory(base64Decode(book!.cover!), height: 240)
        : Image.asset("assets/book_default.png", height: 240);
  }

  void initStates(List<BookModel> books) {
    List<BookModel> initialBooks = [];

    if (widget.onlySavedBooks == true) {
      initialBooks = List.from(books.where((book) => book.isSaved).toList());
    } else {
      initialBooks = List.from(books);
    }

    next = initialBooks.indexOf(currentBook) + 1;
    if (next != null && next! >= initialBooks.length) {
      next = null;
    }

    previous = initialBooks.indexOf(currentBook) - 1;
    if (previous != null && previous! < 0) {
      previous = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreStates>(
      builder: (context, storeState) {
        return BlocConsumer<BooksBloc, BooksStates>(
          listener: (context, booksState) {
            if (booksState is BookUpdateSuccessState) {
              setState(() {
                currentBook = booksState.books.firstWhere(
                  (book) => book.id == currentBook.id,
                );
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Livro atualizado com sucesso!")),
              );
            } else if (booksState is BookDeleteSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Livro excluído com sucesso!")),
              );
              Navigator.pop(context);
            } else if (booksState is BookUpdateErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Erro ao atualizar livro")),
              );
            } else if (booksState is BookDeleteErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Erro ao excluir livro")),
              );
            }
          },

          builder: (context, booksState) {
            initStates(booksState.books);

            return Scaffold(
              appBar: appBarWidget(context: context),
              body: SingleChildScrollView(
                child: Column(
                  spacing: 32,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 240,
                      child: Stack(
                        clipBehavior: Clip.antiAlias,
                        alignment: Alignment.center,
                        children: [
                          if (previous != null)
                            Positioned(
                              left: -120,
                              child: InkWell(
                                onTap:
                                    () => onChangeBook(booksState.books, false),
                                child: getImageBook(
                                  booksState.books[previous!],
                                ),
                              ),
                            ),

                          currentBook.cover != null
                              ? Image.memory(
                                base64Decode(currentBook.cover!),
                                height: 240,
                              )
                              : Image.asset(
                                "assets/book_default.png",
                                height: 240,
                              ),

                          if (next != null)
                            Positioned(
                              right: -120,
                              child: InkWell(
                                onTap:
                                    () => onChangeBook(booksState.books, true),
                                child: getImageBook(booksState.books[next!]),
                              ),
                            ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        spacing: 24,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            currentBook.title,
                            textAlign: TextAlign.center,
                            style: AppFonts.subtitleFontBold,
                          ),
                          Text(currentBook.author, textAlign: TextAlign.center),
                          Text("Sinópse", style: AppFonts.labelFont),
                          Text(
                            currentBook.synopsis,
                            textAlign: TextAlign.justify,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Publicado em", style: AppFonts.labelFont),
                              Text(currentBook.year.toString()),
                            ],
                          ),
                          if (storeState is StoreLoadedState)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Avaliação", style: AppFonts.labelFont),
                                RatingBarWidget(
                                  rating: currentBook.rating,
                                  disabled: true,
                                ),
                              ],
                            ),
                          if (storeState is StoreLoadedState)
                            Row(
                              spacing: 16,
                              children: [
                                Switch(
                                  value: currentBook.available,
                                  onChanged: (value) {
                                    if (storeState.store.user.role !=
                                        Role.admin) {
                                      setState(() {
                                        currentBook.available = value;
                                      });
                                      RequestBookModel requestBook =
                                          RequestBookModel(
                                            author: currentBook.author,
                                            year: currentBook.year,
                                            synopsis: currentBook.synopsis,
                                            rating: currentBook.rating,
                                            available: value,
                                            cover: currentBook.cover,

                                            title: currentBook.title,
                                          );
                                      BlocProvider.of<BooksBloc>(context).add(
                                        UpdateBookEvent(
                                          storeId: storeState.store.id,
                                          bookId: currentBook.id,
                                          book: requestBook,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  !currentBook.available
                                      ? "Sem Estoque"
                                      : "Estoque",
                                ),
                              ],
                            ),
                          if (storeState is StoreLoadedState) ...[
                            storeState.store.user.role == Role.admin
                                ? ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => BookFormScreen(
                                              storeId: storeState.store.id,
                                              initialBook: currentBook,
                                            ),
                                      ),
                                    );
                                  },
                                  child: const Text("Editar"),
                                )
                                : LoadingButtonWidget(
                                  onPressed: () {
                                    setState(() {
                                      currentBook.isSaved =
                                          !currentBook.isSaved;
                                    });
                                    BlocProvider.of<BooksBloc>(context).add(
                                      UpdateSavedBooksEvent(
                                        bookId: currentBook.id,
                                      ),
                                    );
                                  },
                                  isLoading: false,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 8,
                                    children: [
                                      Icon(
                                        currentBook.isSaved
                                            ? Icons.bookmark
                                            : Icons.bookmark_border_outlined,
                                      ),
                                      Text("Salvar"),
                                    ],
                                  ),
                                ),
                            if (storeState.store.user.role == Role.admin)
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => ConfirmModalWidget(
                                          label:
                                              "Deseja realmente excluir o livro ${currentBook.title}?",
                                          onConfirm: () {
                                            BlocProvider.of<BooksBloc>(
                                              context,
                                            ).add(
                                              DeleteBookEvent(
                                                storeId: storeState.store.id,
                                                bookId: currentBook.id,
                                              ),
                                            );
                                          },
                                        ),
                                  );
                                },
                                child: Text("Excluir"),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
