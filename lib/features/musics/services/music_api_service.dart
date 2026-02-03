import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';

class MusicApiService {
  final Dio _dio;

  MusicApiService(DioClient client) : _dio = client.dio;

  Future<Response> fetchTracks() {
    return _dio.get('/tracks');
  }

  Future<Response> fetchRandomTracks() {
    return _dio.get('/tracks/random');
  }

  Future<Response> fetchTrackById(String id) {
    return _dio.get('/tracks/$id');
  }
  
}
