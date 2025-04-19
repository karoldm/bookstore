import 'package:flutter/material.dart';
import 'package:mybookstore/data/models/request_store_model.dart';
import 'package:mybookstore/data/models/store_model.dart';
import 'package:mybookstore/interfaces/repositories/store_repository_interface.dart';
import 'package:mybookstore/interfaces/services/store_service_interface.dart';

class StoreService implements StoreServiceInterface {
  final StoreRepositoryInterface _storeRepository;
  StoreService(this._storeRepository);

  @override
  Future<StoreModel> updateStore(RequestStoreModel storeModel) async {
    try {
      await _storeRepository.updateStore(storeModel);
      StoreModel store = await _storeRepository.getStore(storeModel.id);
      return store;
    } catch (e) {
      debugPrint('Failed to update store info on service: $e');
      rethrow;
    }
  }
}
