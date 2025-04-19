import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';
import 'package:mybookstore/ui/_core/widgets/book_card_widget.dart';
import 'package:mybookstore/ui/books/bloc/books_bloc.dart';
import 'package:mybookstore/ui/books/bloc/books_states.dart';

class ListBooksWidget extends StatelessWidget {
  const ListBooksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksBloc, BooksStates>(
      builder: (context, state) {
        if (state is BooksLoadingErrorState) {
          return Center(
            child: Text(
              "Erro ao carregar livros :c",
              style: TextStyle(color: AppColors.labelColor),
            ),
          );
        }

        if (state is BooksLoadedState) {
          return state.books.isEmpty
              ? Center(
                child: Text(
                  "Sem livros por aqui...",
                  style: TextStyle(color: AppColors.labelColor),
                ),
              )
              : GridView.count(
                shrinkWrap: true,
                semanticChildCount: state.books.length,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 0.47,
                mainAxisSpacing: 32,
                crossAxisSpacing: 32,
                children:
                    state.books
                        .map((book) => BookCardWidget(book: book))
                        .toList(),
              );
        }
        return const Center(
          child: CircularProgressIndicator(color: AppColors.defaultColor),
        );
      },
    );
  }
}
