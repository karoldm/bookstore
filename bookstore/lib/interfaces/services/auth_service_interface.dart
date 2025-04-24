import 'package:bookstore/data/models/store_model.dart';
import 'package:bookstore/data/models/tokens_model.dart';

abstract class AuthServiceInterface {
  Future<(StoreModel, TokensModel)> login(Map<String, dynamic> data);
  Future<(StoreModel, TokensModel)> register(Map<String, dynamic> storeModel);
}
