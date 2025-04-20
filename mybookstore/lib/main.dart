import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mybookstore/data/repositories/auth_repository.dart';
import 'package:mybookstore/data/repositories/books_repository.dart';
import 'package:mybookstore/data/repositories/employees_repository.dart';
import 'package:mybookstore/data/repositories/local_repository.dart';
import 'package:mybookstore/data/repositories/store_repository.dart';
import 'package:mybookstore/data/services/auth_serivce.dart';
import 'package:mybookstore/data/services/books_service.dart';
import 'package:mybookstore/data/services/employees_service.dart';
import 'package:mybookstore/data/services/store_service.dart';
import 'package:mybookstore/interfaces/repositories/auth_repository_interface.dart';
import 'package:mybookstore/interfaces/repositories/books_repository_interface.dart';
import 'package:mybookstore/interfaces/repositories/employees_repository__interface.dart';
import 'package:mybookstore/interfaces/repositories/local_repository_interface.dart';
import 'package:mybookstore/interfaces/repositories/store_repository_interface.dart';
import 'package:mybookstore/interfaces/services/auth_service_interface.dart';
import 'package:mybookstore/interfaces/services/books_service_interface.dart';
import 'package:mybookstore/interfaces/services/employees_service_interface.dart';
import 'package:mybookstore/interfaces/services/store_service_interface.dart';
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

final getIt = GetIt.instance;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void setupDependencies() {
  getIt.registerSingleton<LocalRepositoryInterface>(LocalRepository());
  getIt.registerSingleton<StoreRepositoryInterface>(StoreRepository());
  getIt.registerSingleton<AuthRepositoryInterface>(AuthRepository());
  getIt.registerSingleton<BooksRepositoryInterface>(BooksRepository());
  getIt.registerSingleton<EmployeesRepositoryInterface>(EmployeesRepository());
  getIt.registerSingleton<EmployeesServiceInterface>(
    EmployeesService(getIt<EmployeesRepositoryInterface>()),
  );
  getIt.registerSingleton<BooksServiceInterface>(
    BooksService(
      getIt<BooksRepositoryInterface>(),
      getIt<LocalRepositoryInterface>(),
    ),
  );
  getIt.registerSingleton<StoreServiceInterface>(
    StoreService(getIt<StoreRepositoryInterface>()),
  );
  getIt.registerSingleton<AuthServiceInterface>(
    AuthSerivce(
      authRepository: getIt<AuthRepositoryInterface>(),
      storeRepository: getIt<StoreRepositoryInterface>(),
      localRepository: getIt<LocalRepositoryInterface>(),
    ),
  );

  getIt.registerSingleton<AuthBloc>(AuthBloc());
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupDependencies();

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
