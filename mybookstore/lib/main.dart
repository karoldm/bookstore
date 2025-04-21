import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mybookstore/ui/_core/theme/app_theme.dart';
import 'package:mybookstore/ui/_core/widgets/layout_widget.dart';
import 'package:mybookstore/ui/auth/auth_screen.dart';
import 'package:mybookstore/ui/auth/bloc/auth_bloc.dart';
import 'package:mybookstore/ui/auth/register_screen.dart';
import 'package:mybookstore/ui/auth/widgets/auth_wrapper_widget.dart';
import 'package:mybookstore/ui/_core/blocs/store/store_bloc.dart';
import 'package:mybookstore/ui/books/bloc/books_bloc.dart';
import 'package:mybookstore/ui/employees/bloc/employees_bloc.dart';
import 'package:mybookstore/ui/splash/splash_screen.dart';
import 'package:mybookstore/utils/setup_dependecies.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GetIt getIt = GetIt.instance;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies(getIt);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => StoreBloc()),
        BlocProvider(create: (_) => BooksBloc()),
        BlocProvider(create: (_) => EmployeesBloc()),
      ],
      child: AuthWrapperWidget(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          builder: (context, child) => SafeArea(child: child!),
          routes: {
            "/login": (context) => AuthScreen(),
            "/home": (context) => const LayoutWidget(),
            "/register": (context) => RegisterScreen(),
          },
          title: 'My Bookstore',
          theme: AppTheme.theme,
          home: SplashScreen(),
        ),
      ),
    );
  }
}
