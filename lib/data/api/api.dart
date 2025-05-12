import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:bookstore/config/constants.dart';
import 'package:bookstore/data/models/tokens_model.dart';
import 'package:bookstore/data/models/user_session_model.dart';
import 'package:bookstore/interfaces/services/local_service_interface.dart';
import 'package:bookstore/ui/auth/bloc/auth_bloc.dart';
import 'package:bookstore/ui/auth/bloc/auth_events.dart';

class Api {
  final LocalServiceInterface storage = GetIt.I<LocalServiceInterface>();

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
          if (options.path != '/v1/auth/refresh') {
            final userSession = await storage.readMap(userSessionKey);
            if (userSession != null) {
              final user = SessionModel.fromMap(userSession);
              options.headers['Authorization'] =
                  'Bearer ${user.tokens.accessToken}';
            }
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.requestOptions.path == '/v1/auth/refresh') {
            return handler.next(error);
          }

          if (error.response?.statusCode == 401 &&
              error.response?.data?.toString().toLowerCase().contains(
                    'the token has expired',
                  ) ==
                  true) {
            final retryCount = error.requestOptions.extra['retryCount'] ?? 0;
            if (retryCount >= 1) {
              GetIt.I<AuthBloc>().add(LogoutEvent());
              return handler.next(error);
            }

            final userSession = await storage.readMap(userSessionKey);
            if (userSession != null) {
              final user = SessionModel.fromMap(userSession);
              final tokens = await _refreshToken(user.tokens.refreshToken);

              if (tokens != null) {
                user.tokens = tokens;
                await storage.writeMap(
                  key: userSessionKey,
                  value: user.toMap(),
                );

                error.requestOptions.headers['Authorization'] =
                    'Bearer ${tokens.accessToken}';
                error.requestOptions.extra['retryCount'] = retryCount + 1;

                return handler.resolve(await _dio.fetch(error.requestOptions));
              }
            }

            GetIt.I<AuthBloc>().add(LogoutEvent());
          }

          final customError = error.copyWith(
            message: error.response?.data['detail'] ?? 'An error occurred',
          );
          return handler.next(customError);
        },
      ),
    );
  }

  Future<TokensModel?> _refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post(
        '/v1/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      return TokensModel.fromMap(response.data);
    } catch (e) {
      debugPrint("Error refreshing token: $e");
      return null;
    }
  }

  Dio get api => _dio;
}
