import 'package:dio/dio.dart';

class PlaylistApiService {
  final Dio _dio;

  PlaylistApiService(this._dio);

  Future<Response> getPersonalPlaylists(String userId) {
    return _dio.get('/users/$userId/playlists');
  }

  Future<Response> getRecommendedPlaylist(String userId) {
    return _dio.get('/users/$userId/recommended');
  }

  Future<Response> createPlaylist(String userId, String name) {
    return _dio.post('/playlists', data: {'UserId': userId, 'Name': name});
  }

  Future<Response> addTrackToPlaylist(String playlistId, String trackId) {
    return _dio.post('/playlists/$playlistId/tracks/$trackId');
  }

  Future<Response> removeTrackFromPlaylist(String playlistId, String trackId) {
    return _dio.delete('/playlists/$playlistId/tracks/$trackId');
  }
}