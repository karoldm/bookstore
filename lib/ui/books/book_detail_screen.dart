import 'package:bookstore/data/models/request_book_model.dart';
import 'package:bookstore/ui/_core/widgets/custom_cached_image_network.dart';
import 'package:bookstore/utils/show_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/data/models/book_model.dart';
import 'package:bookstore/enums/role_enum.dart';
import 'package:bookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:bookstore/ui/_core/blocs/store/store_states.dart';
import 'package:bookstore/ui/_core/theme/app_fonts.dart';
import 'package:bookstore/ui/_core/widgets/app_bar_widget.dart';
import 'package:bookstore/ui/_core/widgets/confirm_modal_widget.dart';
import 'package:bookstore/ui/_core/widgets/loading_button_widget.dart';
import 'package:bookstore/ui/_core/widgets/rating_bar_widget.dart';
import 'package:bookstore/ui/books/bloc/books_bloc.dart';
import 'package:bookstore/ui/books/bloc/books_events.dart';
import 'package:bookstore/ui/books/bloc/books_states.dart';
import 'package:bookstore/ui/books/book_form_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final List<BookModel> booksList;
  final int initialIndex;

  const BookDetailScreen({
    super.key,
    required this.booksList,
    required this.initialIndex,
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: 0.6,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreStates>(
      builder: (context, storeState) {
        return BlocConsumer<BooksBloc, BooksStates>(
          listener: (context, booksState) {
            if (booksState is BookUpdateSuccessState) {
              showCustomDialog(context, "Livro atualizado com sucesso!");
              Navigator.pop(context);
            } else if (booksState is BookDeleteSuccessState) {
              showCustomDialog(context, "Livro excluído com sucesso!");
              Navigator.pop(context);
            } else if (booksState is BookUpdateErrorState) {
              showCustomDialog(
                context,
                "Erro ao atualizar livro: ${booksState.message}",
              );
            } else if (booksState is BookDeleteErrorState) {
              showCustomDialog(
                context,
                "Erro ao excluir livro: ${booksState.message}",
              );
            }
          },
          builder: (context, booksState) {
            return Scaffold(
              appBar: appBarWidget(context: context),
              body: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.booksList.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final book = widget.booksList[index];
                        return AnimatedScale(
                          duration: const Duration(milliseconds: 300),
                          scale: index == _currentIndex ? 1.0 : 0.9,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child:
                                  book.cover != null && book.cover != ""
                                      ? CustomCachedNetworkImage(
                                        imageUrl: book.cover!,
                                      )
                                      : Image.asset(
                                        "assets/book_default.png",
                                        fit: BoxFit.cover,
                                      ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  Expanded(
                    child: _BookInfoContent(
                      book: widget.booksList[_currentIndex],
                      onEditStock: () {
                        if (storeState is StoreLoadedState) {
                          final book = widget.booksList[_currentIndex];
                          final RequestBookModel requestBookModel =
                              RequestBookModel.fromBook(book);
                          requestBookModel.available =
                              !requestBookModel.available;
                          BlocProvider.of<BooksBloc>(context).add(
                            UpdateBookEvent(
                              storeId: storeState.store.id,
                              bookId: book.id,
                              book: requestBookModel,
                            ),
                          );
                        }
                      },
                      onEdit: () {
                        if (storeState is StoreLoadedState) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => BookFormScreen(
                                    storeId: storeState.store.id,
                                    initialBook:
                                        widget.booksList[_currentIndex],
                                  ),
                            ),
                          );
                        }
                      },
                      onDelete: () {
                        if (storeState is StoreLoadedState) {
                          BookModel book = widget.booksList[_currentIndex];

                          showDialog(
                            context: context,
                            builder:
                                (context) => ConfirmModalWidget(
                                  label:
                                      "Deseja realmente excluir o livro ${book.title}?",
                                  onConfirm: () {
                                    BlocProvider.of<BooksBloc>(context).add(
                                      DeleteBookEvent(
                                        storeId: storeState.store.id,
                                        bookId: book.id,
                                      ),
                                    );
                                  },
                                ),
                          );
                        }
                      },
                      onSave: () {
                        BookModel book = widget.booksList[_currentIndex];
                        setState(() {
                          book.isSaved = !book.isSaved;
                        });
                        BlocProvider.of<BooksBloc>(
                          context,
                        ).add(UpdateSavedBooksEvent(bookId: book.id));
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _BookInfoContent extends StatelessWidget {
  final BookModel book;
  final VoidCallback onSave;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onEditStock;

  const _BookInfoContent({
    required this.book,
    required this.onSave,
    required this.onDelete,
    required this.onEdit,
    required this.onEditStock,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreStates>(
      builder: (context, storeState) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24.0, 0, 24.0, 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Column(
                      children: [
                        Text(
                          book.title,
                          textAlign: TextAlign.center,
                          style: AppFonts.subtitleFontBold.copyWith(
                            fontSize: 20,
                          ),
                        ),
                        Text(book.author, textAlign: TextAlign.center),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text("Sinópse", style: AppFonts.labelFont),
                    const SizedBox(height: 8),
                    Text(book.summary, textAlign: TextAlign.justify),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Publicado em", style: AppFonts.labelFont),
                        Text(book.releasedAt),
                      ],
                    ),
                    if (storeState is StoreLoadedState) ...[
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Avaliação", style: AppFonts.labelFont),
                          RatingBarWidget(
                            rating: book.rating,
                            disabled: true,
                            onRatingChanged: null,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Switch(
                            value: book.available,
                            onChanged:
                                (storeState.store.user.role != Role.admin)
                                    ? (value) {
                                      onEditStock();
                                    }
                                    : null,
                          ),
                          const SizedBox(width: 16),
                          Text(book.available ? "Estoque" : "Sem Estoque"),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ...[
                        storeState.store.user.role == Role.admin
                            ? ElevatedButton(
                              onPressed: onEdit,
                              child: const Text("Editar"),
                            )
                            : LoadingButtonWidget(
                              onPressed: onSave,
                              isLoading: false,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 8,
                                children: [
                                  Icon(
                                    book.isSaved
                                        ? Icons.bookmark
                                        : Icons.bookmark_border_outlined,
                                  ),
                                  Text("Salvar"),
                                ],
                              ),
                            ),
                        if (storeState.store.user.role == Role.admin)
                          TextButton(
                            onPressed: onDelete,
                            child: Text("Excluir"),
                          ),
                      ],
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
