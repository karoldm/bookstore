import 'package:bookstore/data/exceptions/custom_exception.dart';
import 'package:bookstore/data/models/request_store_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
      debugPrint('Failed to load store info in service: $e');
      throw CustomException(e.toString());
    }
  }

  @override
  Future<void> updateStore(int id, RequestStoreModel storeModel) async {
    try {
      final formData = FormData.fromMap({
        'name': storeModel.name,
        'slogan': storeModel.slogan,
      });

      if (storeModel.banner != null) {
        formData.files.add(
          MapEntry(
            "banner",
            await MultipartFile.fromFile(
              storeModel.banner!.path,
              filename: 'banner_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ),
          ),
        );
      }
      await apiClient.api.put(
        '/v1/store/$id',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
    } catch (e) {
      debugPrint('Failed to update store info in service: $e');
      throw CustomException(e.toString());
    }
  }
}
