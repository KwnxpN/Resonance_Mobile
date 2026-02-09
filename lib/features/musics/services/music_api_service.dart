import 'package:dio/dio.dart';

class MusicApiService {
  final Dio _dio;

  MusicApiService(this._dio);

  Future<Response> fetchTracks() {
    return _dio.get('/tracks');
  }

  Future<Response> fetchRandomTracks() {
    return _dio.get('/tracks/random');
  }

  Future<Response> fetchTrackById(String id) {
    return _dio.get('/tracks/$id');
  }
  
  Future<Response> postUserPreferences(Map<String, dynamic> genreCounter) {
    return _dio.post(
      '/user/preferences',
      data: {
      "genres": genreCounter,
    },
    );
  }

}
