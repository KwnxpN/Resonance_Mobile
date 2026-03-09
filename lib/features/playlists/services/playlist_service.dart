import 'package:dio/dio.dart';

class PlaylistApiService {
  final Dio _dio;

  PlaylistApiService(this._dio);

  Future<Response> getPersonalPlaylists(String userId) {
    return _dio.get('/users/$userId/playlists');
  }
}