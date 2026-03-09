import 'package:dio/dio.dart';

class SwipeApiService {
  final Dio _dio;

  SwipeApiService(this._dio);

  Future<Response> getSwipe(String swipeId) {
    return _dio.get('/swipes/$swipeId');
  }

  Future<Response> swipe(String userId, String trackId, String action) {
    return _dio.post('/swipe', data: {
      'UserID': userId,
      'TrackID': trackId,
      'Action': action,
    });
  }
}