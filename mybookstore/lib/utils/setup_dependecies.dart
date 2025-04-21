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
import 'package:mybookstore/ui/auth/bloc/auth_bloc.dart';

void setupDependencies(GetIt getIt) {
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
