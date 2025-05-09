import 'package:bookstore/data/models/request_auth_model.dart';
import 'package:bookstore/data/models/request_register_model.dart';
import 'package:bookstore/data/models/store_model.dart';
import 'package:bookstore/data/models/tokens_model.dart';

abstract class AuthServiceInterface {
  Future<(StoreModel, TokensModel)> login(RequestAuthModel data);
  Future<(StoreModel, TokensModel)> register(RequestRegisterModel storeModel);
}
