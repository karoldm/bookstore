import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/data/models/book_model.dart';
import 'package:mybookstore/enums/role_enum.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_states.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';
import 'package:mybookstore/ui/_core/widgets/list_books_widget.dart';
import 'package:mybookstore/ui/_core/widgets/text_field_widget.dart';
import 'package:mybookstore/ui/_core/widgets/book_card_widget.dart';
import 'package:mybookstore/ui/home/widgets/filter_modal_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void onFilter() {
    // Implement filter logic here
    // Provider.of<BooksBloc>(context, listen: false).filterBooks();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreStates>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 40,
            children: [
              Image.asset('assets/logo_purple.png', width: 56, height: 42),
              state is StoreLoadedState
                  ? Text('Olá, ${state.store.user.name} 👋')
                  : const CircularProgressIndicator(
                    constraints: BoxConstraints(maxHeight: 16, maxWidth: 16),
                  ),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      hint: "Buscar",
                      suffixIcon: Icons.search,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                        ),
                        context: context,
                        builder: (context) {
                          return FilterModalWidget();
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
              if (state is StoreLoadedState &&
                  state.store.user.role == Role.employee) ...[
                Text("Livros salvos"),
                SizedBox(
                  height: 319,
                  child: ListView.separated(
                    shrinkWrap: true,
                    separatorBuilder: (_, __) => const SizedBox(width: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: [].length,
                    itemBuilder: (context, index) {
                      BookModel book = [][index];
                      return BookCardWidget(book: book);
                    },
                  ),
                ),
              ],
              Text("Todos livros"),
              if (state is StoreLoadedState)
                ListBooksWidget(storeId: state.store.id),
            ],
          ),
        );
      },
    );
  }
}
