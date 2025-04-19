import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:mybookstore/interfaces/services/auth_service_interface.dart';
import 'package:mybookstore/ui/auth/bloc/auth_events.dart';
import 'package:mybookstore/ui/auth/bloc/auth_states.dart';

class AuthBloc extends Bloc<AuthEvents, AuthStates> {
  AuthServiceInterface authService = GetIt.I<AuthServiceInterface>();

  AuthBloc() : super(LoadingState()) {
    on<RegisterEvent>((event, emit) async {
      emit(LoadingState());
      try {
        final sessionData = await authService.register(event.requestStoreModel);

        emit(AuthenticatedState(sessionData: sessionData));
      } catch (e) {
        emit(RegisterErrorState(message: e.toString()));
      }
    });

    on<InitSessionEvent>((event, emit) async {
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
    });

    on<AuthenticateEvent>((event, emit) async {
      emit(LoadingState());
      try {
        final sessionData = await authService.login(event.authModel);
        emit(AuthenticatedState(sessionData: sessionData));
      } catch (e) {
        emit(AuthenticateErrorState(message: e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      await authService.logout();
      emit(UnauthenticatedState());
    });
  }
}
