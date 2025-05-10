import 'package:bookstore/data/models/store_model.dart';

abstract class AuthStates {}

class AuthenticatedState extends AuthStates {
  final StoreModel sessionData;

  AuthenticatedState({required this.sessionData});
}

class UnauthenticatedState extends AuthStates {}

class LoadingState extends AuthStates {}

class AuthenticateErrorState extends AuthStates {
  final String message;

  AuthenticateErrorState({required this.message});
}

class RegisterErrorState extends AuthStates {
  final String message;

  RegisterErrorState({required this.message});
}
