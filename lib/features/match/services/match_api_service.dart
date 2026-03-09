import 'package:dio/dio.dart';

class MatchApiService {
  final Dio _dio;

  MatchApiService(this._dio);

  Future<Response> fetchAllMatches() {
    return _dio.get('/');
  }

  Future<Response> fetchMatchByUserId(String userId) {
    return _dio.get('/user/$userId');
  }

  Future<Response> fetchMatchByMatchId(String matchId) {
    return _dio.get('/$matchId');
  }
}
