import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';
import 'package:mybookstore/ui/_core/widgets/book_card_widget.dart';
import 'package:mybookstore/ui/books/bloc/books_bloc.dart';
import 'package:mybookstore/ui/books/bloc/books_events.dart';
import 'package:mybookstore/ui/books/bloc/books_states.dart';

class ListBooksWidget extends StatelessWidget {
  final int storeId;

  const ListBooksWidget({super.key, required this.storeId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksBloc, BooksStates>(
      buildWhen:
          (previous, current) =>
              current is BooksLoadingState ||
              current is BooksLoadingMoreState ||
              current is BooksLoadingErrorState ||
              current is BooksLoadedState,
      builder: (context, state) {
        if (state is BooksLoadingErrorState) {
          return Text(
            "Erro ao carregar livros :c",
            style: TextStyle(color: AppColors.labelColor),
          );
        }

        if (state is BooksLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }
        return state.books.isEmpty
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
                            ? const CircularProgressIndicator(
                              constraints: BoxConstraints(
                                maxHeight: 16,
                                maxWidth: 16,
                              ),
                            )
                            : const Text("Carregar mais"),
                  ),
              ],
            );
      },
    );
  }
}
