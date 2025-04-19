import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mybookstore/data/models/store_model.dart';
import 'package:mybookstore/data/models/tokens_model.dart';
import 'package:mybookstore/data/api/api.dart';
import 'package:mybookstore/data/models/user_model.dart';
import 'package:mybookstore/interfaces/repositories/auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  final Api apiClient = Api();

  @override
  Future<(StoreModel, TokensModel)> login(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.api.post('/v1/auth', data: data);
      StoreModel store = StoreModel.fromMap(response.data['store']);
      store.user = UserModel.fromMap(response.data['user']);
      return (
        store,
        TokensModel(
          accessToken: response.data['token'],
          refreshToken: response.data['refreshToken'],
        ),
      );
    } catch (e) {
      debugPrint("Error in AuthRepository: $e");
      rethrow;
    }
  }

  @override
  Future<(StoreModel, TokensModel)> register(
    Map<String, dynamic> storeModel,
  ) async {
    try {
      // storeModel['banner'] =
      //     "iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAJ0lEQVQoU2NkYGD4z0AEYBxVSFUBCkS0FRCACFoAhRQDQAG5GADAFHfB8s5VChEAAAAASUVORK5CYII=";
      final response = await apiClient.api.post(
        '/v1/store',
        data: jsonEncode(storeModel),
      );
      return (
        StoreModel.fromMap(response.data['store']),
        TokensModel(
          accessToken: response.data['token'],
          refreshToken: response.data['refreshToken'],
        ),
      );
    } catch (e) {
      debugPrint('Failed to create store: $e');
      rethrow;
    }
  }
}
