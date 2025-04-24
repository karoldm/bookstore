import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/data/models/book_model.dart';
import 'package:bookstore/ui/_core/theme/app_colors.dart';
import 'package:bookstore/ui/_core/theme/app_fonts.dart';
import 'package:bookstore/ui/_core/widgets/book_card_widget.dart';
import 'package:bookstore/ui/books/bloc/books_bloc.dart';
import 'package:bookstore/ui/books/bloc/books_events.dart';
import 'package:bookstore/ui/books/bloc/books_states.dart';

class ListBooksWidget extends StatelessWidget {
  final int storeId;
  final List<BookModel> books;

  const ListBooksWidget({
    super.key,
    required this.storeId,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksBloc, BooksStates>(
      buildWhen:
          (previous, current) =>
              current is BooksLoadingState ||
              current is BooksLoadingMoreState ||
              current is BooksLoadingErrorState ||
              current is BooksLoadedState ||
              current is FilteredBooksState,
      builder: (context, state) {
        if (state is BooksLoadingErrorState) {
          return Text(
            "Erro ao carregar livros :c",
            style: AppFonts.bodySmallMediumFont.copyWith(
              color: AppColors.labelColor,
            ),
          );
        }

        if (state is BooksLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        return books.isEmpty
            ? Text(
              "Sem livros por aqui...",
              style: AppFonts.bodySmallMediumFont.copyWith(
                color: AppColors.labelColor,
              ),
            )
            : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GridView.count(
                  shrinkWrap: true,
                  semanticChildCount: books.length,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 0.47,
                  mainAxisSpacing: 32,
                  crossAxisSpacing: 32,
                  children:
                      books.map((book) => BookCardWidget(book: book)).toList(),
                ),
                if (context.read<BooksBloc>().hasMore)
                  TextButton(
                    onPressed: () {
                      context.read<BooksBloc>().add(
                        FetchBooksEvent(storeId: storeId, isLoadingMore: true),
                      );
                    },
                    child:
                        state is BooksLoadingMoreState
                            ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : Text(
                              "Carregar mais",
                              style: AppFonts.bodySmallMediumFont.copyWith(
                                color: AppColors.defaultColor,
                              ),
                            ),
                  ),
              ],
            );
      },
    );
  }
}
