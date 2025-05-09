import 'package:bookstore/data/models/store_model.dart';

abstract class StoreServiceInterface {
  Future<StoreModel> getStore(int storeId);
  Future<void> updateStore(int id, Map<String, dynamic> storeModel);
}
