import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/data/models/book_model.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_states.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';
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
        return BlocBuilder<BooksBloc, BooksStates>(
          builder: (context, booksState) {
            if (booksState is BooksLoadedState) {
              BookModel book = booksState.books.firstWhere(
                (element) => element.id == this.book.id,
              );

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
                            ? Image.memory(
                              base64Decode(book.cover!),
                              height: 240,
                            )
                            : Image.asset(
                              "assets/book_default.png",
                              height: 240,
                            ),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Avaliação"),
                                RatingBarWidget(rating: book.rating),
                              ],
                            ),
                            Row(
                              spacing: 16,
                              children: [
                                Switch(
                                  value: book.available,
                                  onChanged: (value) {},
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
                                        Navigator.pop(context);
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
            }
            return Scaffold(
              appBar: appBarWidget(context: context),
              body: const Center(
                child: CircularProgressIndicator(color: AppColors.defaultColor),
              ),
            );
          },
        );
      },
    );
  }
}
