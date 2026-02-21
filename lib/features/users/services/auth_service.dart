import 'package:dio/dio.dart';

class AuthApiService {
  final Dio _dio;

  AuthApiService(this._dio);

  Future<Response> register({
    required String email,
    required String password,
    required String name,
  }) {
    return _dio.post(
      "/register",
      data: {
        "email": email,
        "password": password,
        "name": name,
      },
    );
  }

  Future<Response> login({
    required String identifier,
    required String password,
  }) {
    return _dio.post(
      "/login",
      data: {
        "identifier": identifier,
        "password": password,
      },
    );
  }

  Future<Response> me() {
  return _dio.get("/me");
}
}
