import '../models/music_model.dart';
import '../services/music_api_service.dart';

class MusicRepository {
  final MusicApiService apiService;
  MusicRepository(this.apiService);

  Future<List<TrackModel>> getTracks({Map<String, dynamic>? query}) async {
    try {
      final response = await apiService.fetchTracks(query: query);
      final data = response.data['data']['tracks'] as List;

      return data.map((e) => TrackModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load tracks: $e');
    }
  }

  Future<List<TrackModel>> getRandomTracks() async {
    try {
      final response = await apiService.fetchRandomTracks();
      final data = response.data['data'] as List;
      return data.map((e) => TrackModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load tracks');
    }
  }

  Future<TrackModel> getTrackById(String id) async {
    try {
      final response = await apiService.fetchTrackById(id);
      return TrackModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load track: $e');
    }
  }

  Future<void> saveUserTaste(Map<String, int> genreCounter) async {
    await apiService.postUserPreferences(genreCounter);
    
  }

}