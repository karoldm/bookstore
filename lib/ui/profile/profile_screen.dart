import 'package:bookstore/ui/_core/widgets/circular_avatar_widget.dart';
import 'package:bookstore/ui/books/bloc/books_bloc.dart';
import 'package:bookstore/ui/books/bloc/books_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/enums/role_enum.dart';
import 'package:bookstore/ui/_core/theme/app_colors.dart';
import 'package:bookstore/ui/_core/theme/app_fonts.dart';
import 'package:bookstore/ui/_core/widgets/list_saved_books_widget.dart';
import 'package:bookstore/ui/auth/bloc/auth_bloc.dart';
import 'package:bookstore/ui/auth/bloc/auth_events.dart';
import 'package:bookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:bookstore/ui/_core/blocs/store/store_states.dart';
import 'package:bookstore/ui/profile/edit_store_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreStates>(
      builder:
          (context, state) => BlocBuilder<BooksBloc, BooksStates>(
            builder: (context, booksState) {
              return state is StoreLoadedState
                  ? SingleChildScrollView(
                    child: Column(
                      spacing: 24,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CircleAvatarWidget(name: state.store.user.name),
                        Column(
                          spacing: 8,
                          children: [
                            Text(
                              state.store.user.name,
                              style: AppFonts.subtitleFontBold,
                            ),
                            Text(state.store.name, style: AppFonts.bodyFont),
                            Text(
                              state.store.slogan,
                              style: AppFonts.bodySmallFont,
                            ),
                          ],
                        ),
                        if (state.store.user.role == Role.admin)
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 24,
                              ),
                              backgroundColor: AppColors.backgroundColor,
                              foregroundColor: AppColors.defaultColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: AppColors.lineColor),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder:
                                      (context) => EditStoreScreen(
                                        initialStoreModel: state.store,
                                      ),
                                ),
                              );
                            },
                            label: Text("Editar loja"),
                            icon: Icon(Icons.edit_outlined),
                          ),
                        OutlinedButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(LogoutEvent());
                          },
                          child: Text("Sair"),
                        ),
                        if (state.store.user.role == Role.employee)
                          Column(
                            children: [
                              Text(
                                "Livros salvos",
                                style: AppFonts.subtitleFont,
                              ),
                              ListSavedBooksWidget(books: booksState.books),
                            ],
                          ),
                      ],
                    ),
                  )
                  : Center(child: CircularProgressIndicator());
            },
          ),
    );
  }
}
