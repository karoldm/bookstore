import 'package:bookstore/data/models/book_model.dart';
import 'package:bookstore/ui/books/book_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/ui/_core/theme/app_colors.dart';
import 'package:bookstore/ui/_core/theme/app_fonts.dart';
import 'package:bookstore/ui/_core/widgets/book_card_widget.dart';
import 'package:bookstore/ui/books/bloc/books_bloc.dart';
import 'package:bookstore/ui/books/bloc/books_states.dart';

class ListSavedBooksWidget extends StatelessWidget {
  final bool? rowLayout;
  final List<BookModel> books;

  const ListSavedBooksWidget({
    super.key,
    this.rowLayout = false,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BooksBloc, BooksStates>(
      builder: (context, state) {
        if (state is SavedBooksLoadingErrorState) {
          return Text(
            "Erro ao carregar livros salvos :c",
            style: AppFonts.bodySmallMediumFont.copyWith(
              color: AppColors.labelColor,
            ),
          );
        }

        if (state is BooksLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        final List<BookModel> savedBooks =
            List.from(books.where((book) => book.isSaved)).toList()
                as List<BookModel>;

        return savedBooks.isEmpty
            ? Text(
              "Sem livros por aqui...",
              style: AppFonts.bodySmallMediumFont.copyWith(
                color: AppColors.labelColor,
              ),
            )
            : (rowLayout == true
                ? SizedBox(
                  height: 307,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: savedBooks.length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder:
                        (context, index) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      return BookCardWidget(
                        book: savedBooks[index],
                        onTap: (book) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BookDetailScreen(
                                    booksList: savedBooks,
                                    initialIndex: savedBooks.indexOf(book),
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                )
                : GridView.count(
                  shrinkWrap: true,
                  semanticChildCount: savedBooks.length,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: 0.47,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 32,
                  children:
                      savedBooks
                          .map(
                            (book) => BookCardWidget(
                              book: book,
                              onTap: (book) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => BookDetailScreen(
                                          booksList: savedBooks,
                                          initialIndex: savedBooks.indexOf(
                                            book,
                                          ),
                                        ),
                                  ),
                                );
                              },
                            ),
                          )
                          .toList(),
                ));
      },
    );
  }
}
