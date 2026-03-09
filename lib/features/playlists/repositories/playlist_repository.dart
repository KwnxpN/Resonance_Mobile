import '../models/playlist.dart';
import '../services/playlist_service.dart';

class PlaylistRepository {
  final PlaylistApiService api;

  PlaylistRepository(this.api);

  Future<List<PersonalPlaylistModel>> getPersonalPlaylists(String userId) async {
    try {
      final res = await api.getPersonalPlaylists(userId);
      return (res.data['data'] as List)
          .map((json) => PersonalPlaylistModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
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