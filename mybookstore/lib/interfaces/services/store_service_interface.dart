import 'package:mybookstore/data/models/request_store_model.dart';
import 'package:mybookstore/data/models/store_model.dart';

abstract class StoreServiceInterface {
  Future<StoreModel> updateStore(RequestStoreModel storeModel);
}
