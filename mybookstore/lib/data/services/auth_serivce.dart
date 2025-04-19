import 'package:flutter/material.dart';
import 'package:mybookstore/config/constants.dart';
import 'package:mybookstore/data/models/request_auth_model.dart';
import 'package:mybookstore/data/models/request_register_model.dart';
import 'package:mybookstore/data/models/store_model.dart';
import 'package:mybookstore/data/models/tokens_model.dart';
import 'package:mybookstore/data/models/user_model.dart';
import 'package:mybookstore/data/models/user_session_model.dart';
import 'package:mybookstore/interfaces/repositories/auth_repository_interface.dart';
import 'package:mybookstore/interfaces/repositories/local_repository_interface.dart';
import 'package:mybookstore/interfaces/repositories/store_repository_interface.dart';
import 'package:mybookstore/interfaces/services/auth_service_interface.dart';

class AuthSerivce implements AuthServiceInterface {
  final AuthRepositoryInterface authRepository;
  final StoreRepositoryInterface storeRepository;

  final LocalRepositoryInterface localRepository;

  AuthSerivce({
    required this.authRepository,
    required this.storeRepository,
    required this.localRepository,
  });

  @override
  Future<StoreModel?> initSession() async {
    try {
      final storedSession = await localRepository.readMap(userSessionKey);

      if (storedSession != null && storedSession != {}) {
        final userSession = SessionModel.fromMap(storedSession);

        final store = await storeRepository.getStore(userSession.storeId);

        final user = UserModel(
          id: userSession.id,
          name: userSession.name,
          photo: userSession.photo,
          role: userSession.role,
        );

        store.user = user;

        return store;
      } else {
        debugPrint("No session found");
        return null;
      }
    } catch (e) {
      debugPrint("Error in AuthService: $e");
      rethrow;
    }
  }

  @override
  Future<StoreModel> login(RequestAuthModel requestAuthModel) async {
    try {
      final (store, tokens) = await authRepository.login(
        requestAuthModel.toMap(),
      );

      _saveUserSession(store, tokens);

      return store;
    } catch (e) {
      debugPrint("Error in AuthService: $e");
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localRepository.clear();
    } catch (e) {
      debugPrint("Error in AuthService: $e");
      rethrow;
    }
  }

  @override
  Future<StoreModel> register(RequestRegisterModel registerModel) async {
    try {
      final (store, tokens) = await authRepository.register(
        registerModel.toMap(),
      );

      _saveUserSession(store, tokens);

      return store;
    } catch (e) {
      debugPrint("Error in AuthService: $e");
      rethrow;
    }
  }

  Future<void> _saveUserSession(StoreModel store, TokensModel tokens) async {
    SessionModel userSessionModel = SessionModel(
      tokens: tokens,
      id: store.user.id,
      name: store.user.name,
      photo: store.user.photo,
      role: store.user.role,
      storeId: store.id,
    );

    await localRepository.writeMap(
      key: userSessionKey,
      value: userSessionModel.toMap(),
    );
  }
}
