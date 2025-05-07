import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:bookstore/data/models/store_model.dart';
import 'package:bookstore/data/models/tokens_model.dart';
import 'package:bookstore/data/api/api.dart';
import 'package:bookstore/data/models/user_model.dart';
import 'package:bookstore/interfaces/services/auth_service_interface.dart';

class AuthService implements AuthServiceInterface {
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
      debugPrint("Error in AuthService: $e");
      rethrow;
    }
  }

  @override
  Future<(StoreModel, TokensModel)> register(
    Map<String, dynamic> storeModel,
  ) async {
    try {
      final response = await apiClient.api.post(
        '/v1/store',
        data: jsonEncode(storeModel),
      );
      final store = StoreModel.fromMap(response.data['store']);
      store.user = UserModel.fromMap(response.data['user']);

      return (
        store,
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
