import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mybookstore/main.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_events.dart';
import 'package:mybookstore/ui/auth/bloc/auth_bloc.dart';
import 'package:mybookstore/ui/auth/bloc/auth_states.dart';
import 'package:mybookstore/ui/books/bloc/books_bloc.dart';
import 'package:mybookstore/ui/books/bloc/books_events.dart';

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
