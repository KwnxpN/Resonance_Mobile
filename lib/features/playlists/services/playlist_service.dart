import 'package:dio/dio.dart';

class PlaylistApiService {
  final Dio _dio;

  PlaylistApiService(this._dio);

  Future<Response> getPersonalPlaylists(String userId) {
    return _dio.get('/users/$userId/playlists');
  }

  Future<Response> addTrackToPlaylist(String playlistId, String trackId) {
    return _dio.post('/playlists/$playlistId/tracks/$trackId');
  }
}