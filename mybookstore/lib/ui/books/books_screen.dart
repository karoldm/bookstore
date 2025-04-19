import 'package:flutter/material.dart';
import 'package:mybookstore/ui/_core/widgets/list_books_widget.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [Text("Livros"), ListBooksWidget()],
      ),
    );
  }
}
