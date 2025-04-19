import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mybookstore/data/models/book_model.dart';
import 'package:mybookstore/ui/_core/widgets/app_bar_widget.dart';
import 'package:mybookstore/ui/_core/widgets/rating_bar_widget.dart';

class BookDetailScreen extends StatelessWidget {
  final List<BookModel> books;
  final int index;

  const BookDetailScreen({super.key, required this.index, required this.books});

  @override
  Widget build(BuildContext context) {
    BookModel book = books[index];

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
                  ? Image.memory(base64Decode(book.cover!))
                  : Image.asset("assets/book_default.png"),
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
                      Switch(value: book.available, onChanged: (value) {}),
                      Text("Estoque"),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle save action
                },
                child: const Text("Salvar"),
              ),
              TextButton(onPressed: () {}, child: Text("Excluir")),
            ],
          ),
        ),
      ),
    );
  }
}
