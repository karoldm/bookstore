import 'package:bookstore/enums/role_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bookstore/main.dart';
import 'package:bookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:bookstore/ui/_core/blocs/store/store_events.dart';
import 'package:bookstore/ui/auth/bloc/auth_bloc.dart';
import 'package:bookstore/ui/auth/bloc/auth_states.dart';
import 'package:bookstore/ui/books/bloc/books_bloc.dart';
import 'package:bookstore/ui/books/bloc/books_events.dart';
import 'package:bookstore/ui/employees/bloc/employees_bloc.dart';
import 'package:bookstore/ui/employees/bloc/employees_events.dart';

class AuthWrapperWidget extends StatelessWidget {
  final Widget child;

  const AuthWrapperWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthStates>(
      listener: (context, state) {
        if (state is UnauthenticatedState) {
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        } else if (state is AuthenticatedState) {
          final store = state.sessionData;

          StoreBloc storeBloc = BlocProvider.of<StoreBloc>(context);
          BooksBloc booksBloc = BlocProvider.of<BooksBloc>(context);

          storeBloc.add(LoadStoreEvent(store: store));
          booksBloc.add(FetchBooksEvent(storeId: store.id));

          if (store.user.role == Role.admin) {
            EmployeesBloc employeesBloc = BlocProvider.of<EmployeesBloc>(
              context,
            );
            employeesBloc.add(FetchEmployeesEvent(storeId: store.id));
          }

          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            '/home',
            (route) => false,
          );
        }
      },
      child: child,
    );
  }
}
