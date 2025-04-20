import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';
import 'package:mybookstore/ui/_core/widgets/book_card_widget.dart';
import 'package:mybookstore/ui/books/bloc/books_bloc.dart';
import 'package:mybookstore/ui/books/bloc/books_states.dart';

class ListSavedBooksWidget extends StatelessWidget {
  const ListSavedBooksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksBloc, BooksStates>(
      builder: (context, state) {
        if (state is SavedBooksLoadingErrorState) {
          return Text(
            "Erro ao carregar livros salvos :c",
            style: TextStyle(color: AppColors.labelColor),
          );
        }

        if (state is SavedBooksLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        final savedBooks = state.books.where((book) => book.isSaved);

        return savedBooks.isEmpty
            ? Center(
              child: Text(
                "Sem livros por aqui...",
                style: TextStyle(color: AppColors.labelColor),
              ),
            )
            : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GridView.count(
                  shrinkWrap: true,
                  semanticChildCount: savedBooks.length,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 0.47,
                  mainAxisSpacing: 32,
                  crossAxisSpacing: 32,
                  children:
                      savedBooks
                          .map((book) => BookCardWidget(book: book))
                          .toList(),
                ),
              ],
            );
      },
    );
  }
}
