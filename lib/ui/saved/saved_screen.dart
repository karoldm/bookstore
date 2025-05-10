import 'package:bookstore/ui/books/bloc/books_bloc.dart';
import 'package:bookstore/ui/books/bloc/books_states.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/ui/_core/theme/app_fonts.dart';
import 'package:bookstore/ui/_core/widgets/list_saved_books_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksBloc, BooksStates>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            spacing: 32,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 24,
                children: [
                  Image.asset('assets/logo.png', width: 56, height: 42),
                  Text("Livros salvos", style: AppFonts.titleFont),
                  ListSavedBooksWidget(books: state.books),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
