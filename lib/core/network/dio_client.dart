import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class DioClient {
  final Dio dio;
  final _storage = const FlutterSecureStorage();

  DioClient()
      : dio = Dio(
          BaseOptions(
            baseUrl: 'http://10.0.2.2:9090',
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {'Content-Type': 'application/json'},
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: "access_token");

          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },

        onError: (e, handler) {
          final message = e.response?.data?["error"];

          if (message != null) {
            handler.reject(
              DioException(
                requestOptions: e.requestOptions,
                error: message,
              ),
            );
            return;
          }

          handler.next(e);
        },
      ),
    );

    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }
}