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
import 'package:mybookstore/ui/_core/widgets/rating_bar_widget.dart';
import 'package:mybookstore/ui/books/bloc/books_bloc.dart';
import 'package:mybookstore/ui/books/bloc/books_events.dart';
import 'package:mybookstore/ui/books/bloc/books_states.dart';
import 'package:mybookstore/ui/books/book_form_screen.dart';

class BookDetailScreen extends StatelessWidget {
  final BookModel book;

  const BookDetailScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreStates>(
      builder: (context, storeState) {
        return BlocConsumer<BooksBloc, BooksStates>(
          listener: (context, booksState) {
            if (booksState is BookUpdateErrorState) {
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
                      book.cover != null
                          ? Image.memory(base64Decode(book.cover!), height: 240)
                          : Image.asset("assets/book_default.png", height: 240),
                      Column(
                        spacing: 24,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            book.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(book.author, textAlign: TextAlign.center),
                          Text("Sinópse"),
                          Text(book.synopsis, textAlign: TextAlign.justify),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Publicado em"),
                              Text(book.year.toString()),
                            ],
                          ),
                          if (storeState is StoreLoadedState)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Avaliação"),
                                RatingBarWidget(
                                  rating: book.rating,
                                  disabled:
                                      storeState.store.user.role == Role.admin,
                                ),
                              ],
                            ),
                          if (storeState is StoreLoadedState)
                            Row(
                              spacing: 16,
                              children: [
                                Switch(
                                  value: book.available,
                                  onChanged: (value) {
                                    if (storeState.store.user.role !=
                                        Role.admin) {
                                      RequestBookModel requestBook =
                                          RequestBookModel(
                                            author: book.author,
                                            year: book.year,
                                            synopsis: book.synopsis,
                                            rating: book.rating,
                                            available: value,
                                            cover: book.cover,

                                            title: book.title,
                                          );
                                      BlocProvider.of<BooksBloc>(context).add(
                                        UpdateBookEvent(
                                          storeId: storeState.store.id,
                                          bookId: book.id,
                                          book: requestBook,
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  !book.available ? "Sem Estoque" : "Estoque",
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (storeState is StoreLoadedState) ...[
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BookFormScreen(
                                      storeId: storeState.store.id,
                                      initialBook: book,
                                    ),
                              ),
                            );
                          },
                          child: const Text("Editar"),
                        ),
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  (context) => ConfirmModalWidget(
                                    label:
                                        "Deseja realmente excluir o livro ${book.title}?",
                                    onConfirm: () {
                                      BlocProvider.of<BooksBloc>(context).add(
                                        DeleteBookEvent(
                                          storeId: storeState.store.id,
                                          bookId: book.id,
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
