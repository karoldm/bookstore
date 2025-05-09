import 'package:bookstore/ui/books/bloc/books_states.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/enums/role_enum.dart';
import 'package:bookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:bookstore/ui/_core/blocs/store/store_states.dart';
import 'package:bookstore/ui/_core/theme/app_colors.dart';
import 'package:bookstore/ui/_core/theme/app_fonts.dart';
import 'package:bookstore/ui/_core/widgets/list_books_widget.dart';
import 'package:bookstore/ui/_core/widgets/list_saved_books_widget.dart';
import 'package:bookstore/ui/_core/widgets/text_field_widget.dart';
import 'package:bookstore/ui/books/bloc/books_bloc.dart';
import 'package:bookstore/ui/books/bloc/books_events.dart';
import 'package:bookstore/ui/home/widgets/filter_modal_widget.dart';
import 'package:bookstore/utils/debouncer.dart';

class HomeScreen extends StatelessWidget {
  final Debouncer debouncer = Debouncer(milliseconds: 500);

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreStates>(
      builder: (context, state) {
        return BlocBuilder<BooksBloc, BooksStates>(
          builder: (context, booksState) {
            return state is StoreLoadedState
                ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 24,
                    children: [
                      if (state.store.banner != null)
                        SizedBox(
                          height: 124,
                          width: double.infinity,
                          child: CachedNetworkImage(
                            imageUrl: state.store.banner!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Text(
                        'Olá, ${state.store.user.name} 👋',
                        style: AppFonts.titleFont,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldWidget(
                              hint: "Buscar",
                              suffixIcon: Icons.search,
                              onChanged: (value) {
                                debouncer.run(() {
                                  BlocProvider.of<BooksBloc>(context).add(
                                    FetchBooksEvent(
                                      storeId: state.store.id,
                                      offset: 0,
                                      filters:
                                          value.isEmpty ? {} : {"title": value},
                                    ),
                                  );
                                });
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.8,
                                ),
                                context: context,
                                builder: (context) {
                                  return FilterModalWidget(
                                    onFilter: (filters) {
                                      BlocProvider.of<BooksBloc>(context).add(
                                        FetchBooksEvent(
                                          storeId: state.store.id,
                                          offset: 0,
                                          filters: filters,
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.filter_alt_outlined,
                              color: AppColors.headerColor,
                            ),
                          ),
                        ],
                      ),
                      if (state.store.user.role == Role.employee) ...[
                        Text("Livros salvos", style: AppFonts.subtitleFont),
                        ListSavedBooksWidget(
                          rowLayout: true,
                          books:
                              booksState is FilteredBooksState
                                  ? booksState.filteredBooks
                                  : booksState.books,
                        ),
                      ],
                      Text("Todos livros", style: AppFonts.subtitleFont),
                      ListBooksWidget(
                        storeId: state.store.id,
                        books:
                            booksState is FilteredBooksState
                                ? booksState.filteredBooks
                                : booksState.books,
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
