import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:mybookstore/config/constants.dart';
import 'package:mybookstore/data/models/tokens_model.dart';
import 'package:mybookstore/data/models/user_session_model.dart';
import 'package:mybookstore/interfaces/repositories/local_repository_interface.dart';
import 'package:mybookstore/ui/auth/bloc/auth_bloc.dart';
import 'package:mybookstore/ui/auth/bloc/auth_events.dart';

class Api {
  final LocalRepositoryInterface storage = GetIt.I<LocalRepositoryInterface>();

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Api() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final userSession = await storage.readMap(userSessionKey);

          if (userSession != null) {
            final user = SessionModel.fromMap(userSession);

            options.headers['Authorization'] =
                'Bearer ${user.tokens.accessToken}';
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401 &&
              !(error.requestOptions.method == 'POST' &&
                  [
                    "/v1/auth",
                    "/v1/store",
                  ].contains(error.requestOptions.path))) {
            final userSession = await storage.readMap(userSessionKey);

            if (userSession != null) {
              final user = SessionModel.fromMap(userSession);

              final tokens = await _refreshToken(user.tokens.refreshToken);

              if (tokens != null) {
                user.tokens = tokens;

                await storage.writeMap(key: userSessionKey, value: userSession);

                error.requestOptions.headers['Authorization'] =
                    'Bearer ${tokens.accessToken}';
                return handler.resolve(await _dio.fetch(error.requestOptions));
              }

              GetIt.I<AuthBloc>().add(LogoutEvent());
              return handler.next(error);
            }

            GetIt.I<AuthBloc>().add(LogoutEvent());
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<TokensModel?> _refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/v1/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      return TokensModel.fromMap(response.data);
    } catch (e) {
      debugPrint("Error refreshing token: $e");
      return null;
    }
  }

  Dio get api => _dio;
}
