import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/enums/role_enum.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_states.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';
import 'package:mybookstore/ui/_core/theme/app_fonts.dart';
import 'package:mybookstore/ui/_core/widgets/list_books_widget.dart';
import 'package:mybookstore/ui/_core/widgets/list_saved_books_widget.dart';
import 'package:mybookstore/ui/_core/widgets/text_field_widget.dart';
import 'package:mybookstore/ui/books/bloc/books_bloc.dart';
import 'package:mybookstore/ui/books/bloc/books_events.dart';
import 'package:mybookstore/ui/home/widgets/filter_modal_widget.dart';
import 'package:mybookstore/utils/debouncer.dart';

class HomeScreen extends StatelessWidget {
  final Debouncer debouncer = Debouncer(milliseconds: 500);

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreStates>(
      builder: (context, state) {
        return state is StoreLoadedState
            ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 40,
                children: [
                  Image.asset('assets/logo_purple.png', width: 56, height: 42),
                  Text(
                    'Olá, ${state.store.user.name} 👋',
                    style: AppFonts.titleFont,
                  ),

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
                                  filters: {"title": value},
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
                    ListSavedBooksWidget(),
                  ],
                  Text("Todos livros", style: AppFonts.subtitleFont),
                  ListBooksWidget(storeId: state.store.id),
                ],
              ),
            )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}
