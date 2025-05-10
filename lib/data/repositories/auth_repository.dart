import 'package:bookstore/interfaces/services/auth_service_interface.dart';
import 'package:flutter/material.dart';
import 'package:bookstore/config/constants.dart';
import 'package:bookstore/data/models/request_auth_model.dart';
import 'package:bookstore/data/models/request_register_model.dart';
import 'package:bookstore/data/models/store_model.dart';
import 'package:bookstore/data/models/tokens_model.dart';
import 'package:bookstore/data/models/user_model.dart';
import 'package:bookstore/data/models/user_session_model.dart';
import 'package:bookstore/interfaces/services/local_service_interface.dart';
import 'package:bookstore/interfaces/services/store_service_interface.dart';
import 'package:bookstore/interfaces/repositories/auth_repository_interface.dart';

class AuthRepository implements AuthRepositoryInterface {
  final AuthServiceInterface authService;
  final StoreServiceInterface storeService;
  final LocalServiceInterface localService;

  AuthRepository({
    required this.authService,
    required this.storeService,
    required this.localService,
  });

  @override
  Future<StoreModel?> initSession() async {
    try {
      final storedSession = await localService.readMap(userSessionKey);

      if (storedSession != null && storedSession != {}) {
        final userSession = SessionModel.fromMap(storedSession);

        final store = await storeService.getStore(userSession.storeId);

        final user = UserModel(
          id: userSession.id,
          name: userSession.name,
          role: userSession.role,
          username: userSession.username,
        );

        store.user = user;

        return store;
      } else {
        debugPrint("No session found");
        return null;
      }
    } catch (e) {
      debugPrint("Filed to init session in auth repository: $e");
      rethrow;
    }
  }

  @override
  Future<StoreModel> login(RequestAuthModel requestAuthModel) async {
    try {
      final (store, tokens) = await authService.login(requestAuthModel);

      _saveUserSession(store, tokens);

      return store;
    } catch (e) {
      debugPrint("Filed to login in auth repository: $e");
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await localService.clear();
    } catch (e) {
      debugPrint("Filed to logout in auth repository: $e");
      rethrow;
    }
  }

  @override
  Future<StoreModel> register(RequestRegisterModel registerModel) async {
    try {
      final (store, tokens) = await authService.register(registerModel);

      _saveUserSession(store, tokens);

      return store;
    } catch (e) {
      debugPrint("Filed to register in auth repository: $e");
      rethrow;
    }
  }

  Future<void> _saveUserSession(StoreModel store, TokensModel tokens) async {
    SessionModel userSessionModel = SessionModel(
      tokens: tokens,
      id: store.user.id,
      name: store.user.name,
      username: store.user.username,
      role: store.user.role,
      storeId: store.id,
    );

    await localService.writeMap(
      key: userSessionKey,
      value: userSessionModel.toMap(),
    );
  }
}
