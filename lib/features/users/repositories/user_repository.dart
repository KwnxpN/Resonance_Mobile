import '../models/user.dart';
import '../services/user_service.dart';

class UserRepository {
  final UserApiService api;

  UserRepository(this.api);

  Future<UserModel?> getProfile() async {
    try {
      final res = await api.me();
      return UserModel.fromJson(res.data['profile']);
    } catch (e) {
      return null;
    }
  }

  Future<bool> checkSession() async {
    try {
      await api.me();
      return true;
    } catch (e) {
      return false;
    }
  }
}
