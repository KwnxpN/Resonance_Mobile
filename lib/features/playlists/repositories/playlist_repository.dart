import '../models/playlist.dart';
import '../services/playlist_service.dart';

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
      return PlaylistModel.fromJson(res.data['data']);
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

  Future<bool> addTrackToPlaylist(String playlistId, String trackId) async {
    try {
      await api.addTrackToPlaylist(playlistId, trackId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeTrackFromPlaylist(String playlistId, String trackId) async {
    try {
      await api.removeTrackFromPlaylist(playlistId, trackId);
      return true;
    } catch (e) {
      return false;
    }
  }
}