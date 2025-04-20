import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_states.dart';
import 'package:mybookstore/ui/_core/theme/app_fonts.dart';
import 'package:mybookstore/ui/_core/widgets/list_books_widget.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreStates>(
      builder: (context, state) {
        return state is StoreLoadedState
            ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Livros", style: AppFonts.titleFont),
                  ListBooksWidget(storeId: state.store.id, showFiltered: false),
                ],
              ),
            )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }
}
