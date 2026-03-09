import 'package:dio/dio.dart';
import '../models/swipe_model.dart';
import '../models/playlist_model.dart';

import '../../../core/network/interaction_dio.dart';


class InteractionRepository {
  final Dio _dio = InteractionDio.create();

  Future<void> swipe(SwipeModel swipe) async {
    await _dio.post(
      "/swipe",
      data: swipe.toJson(),
    );
  }

  Future<List<SwipeModel>> getUserSwipes(String userId) async {
    final res = await _dio.get("/users/$userId/swipes");

    List data = res.data["data"];

    return data.map((e) => SwipeModel.fromJson(e)).toList();
  }

  Future<PlaylistModel> createPlaylist(
    String userId,
    String name,
  ) async {
    final res = await _dio.post(
      "/playlists",
      data: {
        "userId": userId,
        "name": name,
      },
    );

    return PlaylistModel.fromJson(res.data["data"]);
  }

  Future<List<PlaylistModel>> getUserPlaylists(String userId) async {
    final res = await _dio.get("/users/$userId/playlists");

    List data = res.data["data"];

    return data.map((e) => PlaylistModel.fromJson(e)).toList();
  }

  Future<void> addTrack(String playlistId, String trackId) async {
    await _dio.post("/playlists/$playlistId/tracks/$trackId");
  }

  Future<void> removeTrack(String playlistId, String trackId) async {
    await _dio.delete("/playlists/$playlistId/tracks/$trackId");
  }

  Future<PlaylistModel> getRecommended(String userId) async {
    final res = await _dio.get("/users/$userId/recommended");

    return PlaylistModel.fromJson(res.data["data"]);
  }
}