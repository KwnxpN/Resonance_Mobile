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
      final data = response.data["data"] as List;
      
      print('API Response (first item): ${data.isNotEmpty ? data.first : 'empty'}');
      
      final tracks = data.map((e) => TrackModel.fromJson(e)).toList();
      
      if (tracks.isNotEmpty) {
        print('First track imageUrl: ${tracks.first.imageUrl}');
      }

      return tracks;
    } catch (e) {
      print('Error loading tracks: $e');
      throw Exception('Failed to load tracks');
    }
  }

  Future<void> saveUserTaste(Map<String, int> genreCounter) async {
    await apiService.postUserPreferences(genreCounter);
    
  }

}