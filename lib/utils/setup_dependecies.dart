import 'package:bookstore/data/services/auth_service.dart';
import 'package:bookstore/data/services/books_service.dart';
import 'package:bookstore/data/services/employees_service.dart';
import 'package:bookstore/data/services/local_service.dart';
import 'package:bookstore/data/services/store_service.dart';
import 'package:get_it/get_it.dart';
import 'package:bookstore/data/repositories/auth_repository.dart';
import 'package:bookstore/data/repositories/books_repository.dart';
import 'package:bookstore/data/repositories/employees_repository.dart';
import 'package:bookstore/data/repositories/store_repository.dart';
import 'package:bookstore/interfaces/services/auth_service_interface.dart';
import 'package:bookstore/interfaces/services/books_service_interface.dart';
import 'package:bookstore/interfaces/services/employees_service_interface.dart';
import 'package:bookstore/interfaces/services/local_service_interface.dart';
import 'package:bookstore/interfaces/services/store_service_interface.dart';
import 'package:bookstore/interfaces/repositories/auth_repository_interface.dart';
import 'package:bookstore/interfaces/repositories/books_repository_interface.dart';
import 'package:bookstore/interfaces/repositories/employees_repository_interface.dart';
import 'package:bookstore/interfaces/repositories/store_repository_interface.dart';
import 'package:bookstore/ui/auth/bloc/auth_bloc.dart';

void setupDependencies(GetIt getIt) {
  getIt.registerSingleton<LocalServiceInterface>(LocalService());
  getIt.registerSingleton<StoreServiceInterface>(StoreService());
  getIt.registerSingleton<BooksServiceInterface>(BooksService());
  getIt.registerSingleton<EmployeesServiceInterface>(EmployeesService());
  getIt.registerSingleton<AuthServiceInterface>(AuthService());

  getIt.registerSingleton<StoreRepositoryInterface>(
    StoreRepository(getIt<StoreServiceInterface>()),
  );

  getIt.registerSingleton<EmployeesRepositoryInterface>(
    EmployeesRepository(getIt<EmployeesServiceInterface>()),
  );

  getIt.registerSingleton<BooksRepositoryInterface>(
    BooksRepository(
      getIt<BooksServiceInterface>(),
      getIt<LocalServiceInterface>(),
    ),
  );

  getIt.registerSingleton<AuthRepositoryInterface>(
    AuthRepository(
      authService: getIt<AuthServiceInterface>(),
      storeService: getIt<StoreServiceInterface>(),
      localService: getIt<LocalServiceInterface>(),
    ),
  );

  getIt.registerSingleton<AuthBloc>(AuthBloc());
}
