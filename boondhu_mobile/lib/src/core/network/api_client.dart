import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  final _storage = const FlutterSecureStorage();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    // Detect environment and set base URL automatically
    String baseUrl = 'http://127.0.0.1:8000/api/v1'; // Default for Web / Windows

    if (!kIsWeb) {
      if (defaultTargetPlatform == TargetPlatform.android) {
        baseUrl = 'http://10.0.2.2:8000/api/v1'; // Android Emulator
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        baseUrl = 'http://127.0.0.1:8000/api/v1'; // iOS Simulator
      }
    }

    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) async {
        if (e.response?.statusCode == 401) {
          // Token expired, attempt to refresh
          final refreshToken = await _storage.read(key: 'refresh_token');
          if (refreshToken != null) {
            try {
              final response = await Dio().post(
                '$baseUrl/auth/token/refresh/',
                data: {'refresh': refreshToken},
              );
              final newAccessToken = response.data['access'];
              await _storage.write(key: 'access_token', value: newAccessToken);
              
              // Retry original request
              e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
              final retryResponse = await Dio().fetch(e.requestOptions);
              return handler.resolve(retryResponse);
            } catch (refreshError) {
              // Refresh failed, clear tokens
              await _storage.delete(key: 'access_token');
              await _storage.delete(key: 'refresh_token');
            }
          }
        }
        return handler.next(e);
      },
    ));
  }
}
