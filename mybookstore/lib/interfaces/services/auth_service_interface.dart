import 'package:mybookstore/data/models/request_auth_model.dart';
import 'package:mybookstore/data/models/request_register_model.dart';
import 'package:mybookstore/data/models/store_model.dart';

abstract class AuthServiceInterface {
  Future<StoreModel?> initSession();

  Future<StoreModel> login(RequestAuthModel requestAuthModel);

  Future<void> logout();

  Future<StoreModel> register(RequestRegisterModel registerModel);
}
