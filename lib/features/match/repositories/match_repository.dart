import '../models/match_model.dart';
import '../services/match_api_service.dart';

class MatchRepository {
  final MatchApiService apiService;
  MatchRepository(this.apiService);

  Future<List<MatchModel>> getMatches() async {
    try {
      final response = await apiService.fetchAllMatches();
      final data = response.data['matches'] as List;

      return data.map((e) => MatchModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load matches: $e');
    }
  }

  Future<List<MatchModel>> getMatchByUserId(String userId) async {
    try {
      final response = await apiService.fetchMatchByUserId(userId);
      final data = response.data['matches'] as List;
      return data.map((e) => MatchModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load match: $e');
    }
  }

  Future<MatchModel> getMatchByMatchId(String matchId) async {
    try {
      final response = await apiService.fetchMatchByMatchId(matchId);
      return MatchModel.fromJson(response.data['match'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to load match: $e');
    }
  }
}