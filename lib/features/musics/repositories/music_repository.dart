import '../models/music_model.dart';
import '../services/music_api_service.dart';

class MusicRepository {
  final MusicApiService apiService;
  MusicRepository(this.apiService);

  Future<List<TrackModel>> getTracks() async {
    try {
      final response = await apiService.fetchTracks();
      final data = response.data as List;

      return data.map((e) => TrackModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load tracks');
    }
  }

  Future<List<TrackModel>> getRandomTracks() async {
    try {
      final response = await apiService.fetchRandomTracks();
      final data = response.data as List;

      return data.map((e) => TrackModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load tracks');
    }
  }
}