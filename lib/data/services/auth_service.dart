import 'package:bookstore/data/exceptions/custom_exception.dart';
import 'package:bookstore/data/models/request_auth_model.dart';
import 'package:bookstore/data/models/request_register_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/data/models/store_model.dart';
import 'package:bookstore/data/models/tokens_model.dart';
import 'package:bookstore/data/api/api.dart';
import 'package:bookstore/data/models/user_model.dart';
import 'package:bookstore/interfaces/services/auth_service_interface.dart';

class AuthService implements AuthServiceInterface {
  final Api apiClient = Api();

  @override
  Future<(StoreModel, TokensModel)> login(RequestAuthModel data) async {
    try {
      final response = await apiClient.api.post(
        '/v1/auth/login',
        data: data.toMap(),
      );
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
      debugPrint("Error to login in AuthService: $e");
      throw CustomException(e.toString());
    }
  }

  @override
  Future<(StoreModel, TokensModel)> register(
    RequestRegisterModel storeModel,
  ) async {
    try {
      final formData = FormData.fromMap({
        'name': storeModel.name,
        'password': storeModel.password,
        'username': storeModel.username,
        'slogan': storeModel.slogan,
        'adminName': storeModel.adminName,
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

      final response = await apiClient.api.post(
        '/v1/auth/register',
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
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
      debugPrint('Failed to create store in auth service: $e');
      throw CustomException(e.toString());
    }
  }
}
