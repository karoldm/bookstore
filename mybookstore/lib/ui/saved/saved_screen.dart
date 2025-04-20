import 'package:flutter/material.dart';
import 'package:mybookstore/ui/_core/widgets/list_saved_books_widget.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 32,
      children: [
        Column(
          spacing: 24,
          children: [
            Image.asset('assets/logo_purple.png', width: 56, height: 42),
            Text("Livros salvos"),
            ListSavedBooksWidget(),
          ],
        ),
      ],
    );
  }
}
