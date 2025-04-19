import 'package:mybookstore/data/models/request_store_model.dart';
import 'package:mybookstore/data/models/store_model.dart';

abstract class StoreEvents {}

class LoadStoreEvent extends StoreEvents {
  final StoreModel store;

  LoadStoreEvent({required this.store});
}

class UpdateStoreEvent extends StoreEvents {
  final RequestStoreModel storeModel;

  UpdateStoreEvent({required this.storeModel});
}
