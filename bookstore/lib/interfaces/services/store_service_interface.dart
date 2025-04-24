import 'package:bookstore/data/models/request_store_model.dart';
import 'package:bookstore/data/models/store_model.dart';

abstract class StoreServiceInterface {
  Future<StoreModel> getStore(int storeId);
  Future<void> updateStore(RequestStoreModel storeModel);
}
