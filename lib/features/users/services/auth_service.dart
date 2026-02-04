import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class AuthApiService {
  final Dio _dio;

  AuthApiService(DioClient client) : _dio = client.dio;

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
    required String email,
    required String password,
  }) {
    return _dio.post(
      "/login",
      data: {
        "email": email,
        "password": password,
      },
    );
  }

  Future<Response> me() {
  return _dio.get("/me");
}
}
