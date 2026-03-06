import '../models/user.dart';
import '../services/user_service.dart';

class UserRepository {
  final UserApiService api;

  UserRepository(this.api);

  Future<UserModel?> me() async {
    try {
      final res = await api.me();
      return UserModel.fromJson(res.data['profile']);
    } catch (e) {
      return null;
    }
  }

  Future<List<UserModel>> getProfiles() async {
    try {
      final res = await api.getProfiles();
      return (res.data['profiles'] as List)
          .map((json) => UserModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<UserModel?> getProfile(String userId) async {
    try {
      final res = await api.getProfile(userId);
      return UserModel.fromJson(res.data['profile']);
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateProfile(String userId, Map<String, dynamic> data) async {
    try {
      await api.updateProfile(userId, data);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProfile(String userId) async {
    try {
      await api.deleteProfile(userId);
      return true;
    } catch (e) {
      return false;
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
