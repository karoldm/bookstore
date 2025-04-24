import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bookstore/data/models/request_store_model.dart';
import 'package:bookstore/data/models/store_model.dart';
import 'package:bookstore/data/api/api.dart';
import 'package:bookstore/interfaces/services/store_service_interface.dart';

class StoreService implements StoreServiceInterface {
  final Api apiClient = Api();

  @override
  Future<StoreModel> getStore(int storeId) async {
    try {
      final response = await apiClient.api.get('/v1/store/$storeId');
      return StoreModel.fromMap(response.data);
    } catch (e) {
      debugPrint('Failed to load store info: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateStore(RequestStoreModel storeModel) async {
    try {
      await apiClient.api.put(
        '/v1/store/${storeModel.id}',
        data: jsonEncode(storeModel.toMap()),
      );
    } catch (e) {
      debugPrint('Failed to update store info on repository: $e');
      rethrow;
    }
  }
}
