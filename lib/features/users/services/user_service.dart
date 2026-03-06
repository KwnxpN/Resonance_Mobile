import 'package:dio/dio.dart';

class UserApiService {
  final Dio _dio;

  UserApiService(this._dio);

  Future<Response> me() {
    return _dio.get('/me');
  }

  Future<Response> getProfiles() {
    return _dio.get('/profiles');
  }

  Future<Response> getProfile(String userId) {
    return _dio.get('/profiles/$userId');
  }

  Future<Response> updateProfile(String userId, Map<String, dynamic> data) {
    return _dio.patch('/profiles/$userId', data: data);
  }

  Future<Response> deleteProfile(String userId) {
    return _dio.delete('/profiles/$userId');
  }
}
