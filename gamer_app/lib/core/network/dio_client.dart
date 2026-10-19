import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  late final Dio dio;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.178.45.9:3000/', 
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Automatically attach JWT token if present
          final token = await secureStorage.read(key: 'jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          // Handle global network errors or token expiration
          if (error.response?.statusCode == 401) {
            // Trigger logout or token refresh logic
          }
          return handler.next(error);
        },
      ),
    );
  }
}