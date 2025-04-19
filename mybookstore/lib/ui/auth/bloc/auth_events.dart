import 'package:mybookstore/data/models/request_auth_model.dart';
import 'package:mybookstore/data/models/request_register_model.dart';

abstract class AuthEvents {}

class InitSessionEvent extends AuthEvents {}

class AuthenticateEvent extends AuthEvents {
  final RequestAuthModel authModel;

  AuthenticateEvent({required this.authModel});
}

class RegisterEvent extends AuthEvents {
  final RequestRegisterModel requestStoreModel;

  RegisterEvent({required this.requestStoreModel});
}

class LogoutEvent extends AuthEvents {}
