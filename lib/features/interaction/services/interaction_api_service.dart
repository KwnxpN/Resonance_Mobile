import '../models/swipe_model.dart';
import '../models/playlist_model.dart';
import '../repositories/interaction_repository.dart';

class InteractionService {
  final InteractionRepository _repo;

  InteractionService(this._repo);

  Future<void> likeTrack(String userId, String trackId) async {
    final swipe = SwipeModel(
      id: "",
      userId: userId,
      trackId: trackId,
      action: "like",
      createdAt: DateTime.now(),
    );

    await _repo.swipe(swipe);
  }

  Future<void> dislikeTrack(String userId, String trackId) async {
    final swipe = SwipeModel(
      id: "",
      userId: userId,
      trackId: trackId,
      action: "dislike",
      createdAt: DateTime.now(),
    );

    await _repo.swipe(swipe);
  }

  Future<List<SwipeModel>> getUserSwipes(String userId) {
    return _repo.getUserSwipes(userId);
  }

  Future<PlaylistModel> createPlaylist(String userId, String name) {
    return _repo.createPlaylist(userId, name);
  }

  Future<List<PlaylistModel>> getUserPlaylists(String userId) {
    return _repo.getUserPlaylists(userId);
  }

  Future<PlaylistModel> getRecommended(String userId) {
    return _repo.getRecommended(userId);
  }
}