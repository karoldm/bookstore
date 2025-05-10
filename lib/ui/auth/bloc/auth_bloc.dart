import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:bookstore/interfaces/repositories/auth_repository_interface.dart';
import 'package:bookstore/ui/auth/bloc/auth_events.dart';
import 'package:bookstore/ui/auth/bloc/auth_states.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  final AuthRepositoryInterface authService =
      GetIt.I<AuthRepositoryInterface>();

  AuthBloc() : super(LoadingState()) {
    on<RegisterEvent>(_onRegisterEvent);
    on<InitSessionEvent>(_onInitSessionEvent);
    on<AuthenticateEvent>(_onAuthenticateEvent);
    on<LogoutEvent>(_onLogoutEvent);
  }

  Future<void> _onRegisterEvent(
    RegisterEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(LoadingState());
    try {
      final sessionData = await authService.register(event.requestStoreModel);
      emit(AuthenticatedState(sessionData: sessionData));
    } catch (e) {
      emit(RegisterErrorState(message: e.toString()));
    }
  }

  Future<void> _onInitSessionEvent(
    InitSessionEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(LoadingState());
    try {
      final sessionData = await authService.initSession();
      if (sessionData != null) {
        emit(AuthenticatedState(sessionData: sessionData));
      } else {
        emit(UnauthenticatedState());
      }
    } catch (e) {
      emit(AuthenticateErrorState(message: e.toString()));
    }
  }

  Future<void> _onAuthenticateEvent(
    AuthenticateEvent event,
    Emitter<AuthStates> emit,
  ) async {
    emit(LoadingState());
    try {
      final sessionData = await authService.login(event.authModel);
      emit(AuthenticatedState(sessionData: sessionData));
    } catch (e) {
      emit(AuthenticateErrorState(message: e.toString()));
    }
  }

  Future<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthStates> emit,
  ) async {
    await authService.logout();
    emit(UnauthenticatedState());
  }
}
