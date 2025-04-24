import 'package:bookstore/ui/books/bloc/books_bloc.dart';
import 'package:bookstore/ui/books/bloc/books_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:bookstore/ui/_core/blocs/store/store_states.dart';
import 'package:bookstore/ui/_core/theme/app_fonts.dart';
import 'package:bookstore/ui/_core/widgets/list_books_widget.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreStates>(
      builder: (context, state) {
        return BlocBuilder<BooksBloc, BooksStates>(
          builder: (context, booksState) {
            return state is StoreLoadedState
                ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Livros", style: AppFonts.titleFont),
                      ListBooksWidget(
                        storeId: state.store.id,
                        books: booksState.books,
                      ),
                    ],
                  ),
                )
                : const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }
}
