import 'package:dio/dio.dart';

class UserApiService {
  final Dio _dio;

  UserApiService(this._dio);

  Future<Response> me() {
    return _dio.get('/me');
  }
}
