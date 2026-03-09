import '../models/swipe.dart';
import '../services/swipe_service.dart';

class SwipeRepository {
  final SwipeApiService api;

  SwipeRepository(this.api);

  Future<SwipeModel> getSwipe(String swipeId) async {
    try {
      final res = await api.getSwipe(swipeId);
      return SwipeModel.fromJson(res.data);
    } catch (e) {
      throw Exception('Failed to retrieve swipe');
    }
  }

  Future<bool> swipe(String userId, String trackId, String action) async {
    try {
      await api.swipe(userId, trackId, action);
      return true;
    } catch (e) {
      return false;
    }
  }
}