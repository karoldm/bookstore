import 'package:flutter/material.dart';
import 'package:bookstore/data/models/request_store_model.dart';
import 'package:bookstore/data/models/store_model.dart';
import 'package:bookstore/interfaces/services/store_service_interface.dart';
import 'package:bookstore/interfaces/repositories/store_repository_interface.dart';

class StoreRepository implements StoreRepositoryInterface {
  final StoreServiceInterface storeService;
  StoreRepository(this.storeService);

  @override
  Future<StoreModel> updateStore(RequestStoreModel storeModel) async {
    try {
      await storeService.updateStore(storeModel.id, storeModel.toMap());
      StoreModel store = await storeService.getStore(storeModel.id);
      return store;
    } catch (e) {
      debugPrint('Failed to update store info in repository: $e');
      rethrow;
    }
  }
}
