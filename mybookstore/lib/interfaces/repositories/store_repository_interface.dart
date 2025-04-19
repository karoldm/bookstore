import 'package:mybookstore/data/models/request_store_model.dart';
import 'package:mybookstore/data/models/store_model.dart';

abstract class StoreRepositoryInterface {
  Future<StoreModel> getStore(int storeId);
  Future<void> updateStore(RequestStoreModel storeModel);
}
