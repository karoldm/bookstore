import 'package:bookstore/data/models/request_store_model.dart';
import 'package:bookstore/data/models/store_model.dart';

abstract class StoreRepositoryInterface {
  Future<StoreModel> updateStore(RequestStoreModel storeModel);
}
