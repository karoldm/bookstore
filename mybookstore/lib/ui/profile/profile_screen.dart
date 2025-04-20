import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/data/models/request_store_model.dart';
import 'package:mybookstore/enums/role_enum.dart';
import 'package:mybookstore/ui/_core/theme/app_colors.dart';
import 'package:mybookstore/ui/_core/widgets/circular_avatar_widget.dart';
import 'package:mybookstore/ui/_core/widgets/list_saved_books_widget.dart';
import 'package:mybookstore/ui/auth/bloc/auth_bloc.dart';
import 'package:mybookstore/ui/auth/bloc/auth_events.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_states.dart';
import 'package:mybookstore/ui/profile/edit_store_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StoreBloc, StoreStates>(
      builder:
          (context, state) =>
              state is StoreLoadedState
                  ? SingleChildScrollView(
                    child: Column(
                      spacing: 24,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CircleAvatarWidget(
                          image: state.store.user.photo,
                          name: state.store.user.name,
                        ),
                        Column(
                          spacing: 8,
                          children: [
                            Text(state.store.user.name),
                            Text(state.store.name),
                            Text(state.store.slogan),
                          ],
                        ),
                        if (state.store.user.role == Role.admin)
                          TextButton.icon(
                            style: TextButton.styleFrom(
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
                                        initialStoreModel: RequestStoreModel(
                                          id: state.store.id,
                                          name: state.store.name,
                                          slogan: state.store.slogan,
                                          banner: state.store.banner,
                                        ),
                                        user: state.store.user,
                                      ),
                                ),
                              );
                            },
                            label: Text("Editar loja"),
                            icon: Icon(Icons.edit_outlined),
                          ),
                        TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(LogoutEvent());
                          },
                          child: Text("Sair"),
                        ),
                        if (state.store.user.role == Role.employee)
                          Column(
                            children: [
                              Text("Livros salvos"),
                              ListSavedBooksWidget(),
                            ],
                          ),
                      ],
                    ),
                  )
                  : Center(child: CircularProgressIndicator()),
    );
  }
}
