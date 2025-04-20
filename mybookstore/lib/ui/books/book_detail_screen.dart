import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/data/models/book_model.dart';
import 'package:mybookstore/data/models/request_book_model.dart';
import 'package:mybookstore/enums/role_enum.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_states.dart';
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

  const BookDetailScreen({super.key, required this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late bool available;
  late bool saved;

  @override
  void initState() {
    super.initState();
    available = widget.book.available;
    saved = widget.book.isSaved;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreStates>(
      builder: (context, storeState) {
        return BlocConsumer<BooksBloc, BooksStates>(
          listener: (context, booksState) {
            if (booksState is BookUpdateSuccessState) {
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
            // BookModel book = booksState.books.firstWhere(
            //   (element) => element.id == this.book.id,
            // );

            return Scaffold(
              appBar: appBarWidget(context: context),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    spacing: 32,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      widget.book.cover != null
                          ? Image.memory(
                            base64Decode(widget.book.cover!),
                            height: 240,
                          )
                          : Image.asset("assets/book_default.png", height: 240),
                      Column(
                        spacing: 24,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.book.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(widget.book.author, textAlign: TextAlign.center),
                          Text("Sinópse"),
                          Text(
                            widget.book.synopsis,
                            textAlign: TextAlign.justify,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Publicado em"),
                              Text(widget.book.year.toString()),
                            ],
                          ),
                          if (storeState is StoreLoadedState)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Avaliação"),
                                RatingBarWidget(
                                  rating: widget.book.rating,
                                  disabled: true,
                                ),
                              ],
                            ),
                          if (storeState is StoreLoadedState)
                            Row(
                              spacing: 16,
                              children: [
                                Switch(
                                  value: available,
                                  onChanged: (value) {
                                    if (storeState.store.user.role !=
                                        Role.admin) {
                                      setState(() {
                                        available = value;
                                      });
                                      RequestBookModel requestBook =
                                          RequestBookModel(
                                            author: widget.book.author,
                                            year: widget.book.year,
                                            synopsis: widget.book.synopsis,
                                            rating: widget.book.rating,
                                            available: value,
                                            cover: widget.book.cover,

                                            title: widget.book.title,
                                          );
                                      BlocProvider.of<BooksBloc>(context).add(
                                        UpdateBookEvent(
                                          storeId: storeState.store.id,
                                          bookId: widget.book.id,
                                          book: requestBook,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Text(!available ? "Sem Estoque" : "Estoque"),
                              ],
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
                                          initialBook: widget.book,
                                        ),
                                  ),
                                );
                              },
                              child: const Text("Editar"),
                            )
                            : LoadingButtonWidget(
                              onPressed: () {
                                setState(() {
                                  saved = !saved;
                                });
                                BlocProvider.of<BooksBloc>(context).add(
                                  UpdateSavedBooksEvent(bookId: widget.book.id),
                                );
                              },
                              isLoading: false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  Icon(
                                    saved
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
                                          "Deseja realmente excluir o livro ${widget.book.title}?",
                                      onConfirm: () {
                                        BlocProvider.of<BooksBloc>(context).add(
                                          DeleteBookEvent(
                                            storeId: storeState.store.id,
                                            bookId: widget.book.id,
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
              ),
            );
          },
        );
      },
    );
  }
}
