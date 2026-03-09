import 'package:dio/dio.dart';

class AuthApiService {
  final Dio _dio;

  AuthApiService(this._dio);

  Future<Response> register({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _dio.post(
      '/register',
      data: {
        'email': email,
        'password': password,
        'display_name': displayName,
      },
    );
  }

  Future<Response> login({
    required String email,
    required String password,
  }) {
    return _dio.post(
      '/login',
      data: {
        'email': email,
        'password': password,
      },
    );
  }

  Future<Response> logout() {
    return _dio.post('/logout');
  }
}
