import 'package:dio/dio.dart';
import '../models/playlist.dart';
import '../services/playlist_service.dart';

enum AddTrackResult { success, alreadyExists, failed }

class PlaylistRepository {
  final PlaylistApiService api;

  PlaylistRepository(this.api);

  Future<List<PlaylistModel>> getPersonalPlaylists(String userId) async {
    try {
      final res = await api.getPersonalPlaylists(userId);
      return (res.data['data'] as List)
          .map((json) => PlaylistModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<PlaylistModel> getRecommendedPlaylist(String userId) async {
    try {
      final res = await api.getRecommendedPlaylist(userId);

      final body = res.data as Map<String, dynamic>;

      if (body['success'] == false || body['data'] == null) {
        return PlaylistModel(id: '', userId: '', name: '', tracks: []);
      }

      return PlaylistModel.fromJson(body['data']);
    } catch (e) {
      return PlaylistModel(id: '', userId: '', name: '', tracks: []);
    }
  }

  Future<bool> createPlaylist(String userId, String name) async {
    try {
      await api.createPlaylist(userId, name);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<AddTrackResult> addTrackToPlaylist(
    String playlistId,
    String trackId,
  ) async {
    try {
      final res = await api.addTrackToPlaylist(playlistId, trackId);
      final body = res.data as Map<String, dynamic>?;
      if (body != null && body['success'] == false) {
        final msg = (body['message'] as String? ?? '').toLowerCase();
        if (msg.contains('already exists')) return AddTrackResult.alreadyExists;
        return AddTrackResult.failed;
      }
      return AddTrackResult.success;
    } on DioException catch (e) {
      final body = e.response?.data as Map<String, dynamic>?;
      if (body != null) {
        final msg = (body['message'] as String? ?? '').toLowerCase();
        if (msg.contains('already exists')) return AddTrackResult.alreadyExists;
      }
      return AddTrackResult.failed;
    } catch (_) {
      return AddTrackResult.failed;
    }
  }

  Future<bool> removeTrackFromPlaylist(
    String playlistId,
    String trackId,
  ) async {
    try {
      await api.removeTrackFromPlaylist(playlistId, trackId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
