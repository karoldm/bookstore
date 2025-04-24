import 'package:bookstore/data/models/request_auth_model.dart';
import 'package:bookstore/data/models/request_register_model.dart';
import 'package:bookstore/data/models/store_model.dart';

abstract class AuthRepositoryInterface {
  Future<StoreModel?> initSession();

  Future<StoreModel> login(RequestAuthModel requestAuthModel);

  Future<void> logout();

  Future<StoreModel> register(RequestRegisterModel registerModel);
}
