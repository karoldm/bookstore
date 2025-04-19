import 'package:mybookstore/data/models/store_model.dart';
import 'package:mybookstore/data/models/tokens_model.dart';

abstract class AuthRepositoryInterface {
  Future<(StoreModel, TokensModel)> login(Map<String, dynamic> data);
  Future<(StoreModel, TokensModel)> register(Map<String, dynamic> storeModel);
}
