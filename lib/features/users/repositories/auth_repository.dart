import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthApiService api;
  final _storage = const FlutterSecureStorage();

  AuthRepository(this.api);

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    await api.register(
      email: email,
      password: password,
      name: name,
    );
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final res = await api.login(
      email: email,
      password: password,
    );

    final token = res.data['access_token'];
    final userJson = res.data["user"];

    await _storage.write(
      key: "access_token",
      value: token,
    );

    return UserModel.fromJson(userJson);
  }

  Future<void> logout() async {
    await _storage.delete(key: "access_token");
  }

  Future<bool> checkSession() async {
  try {
    final res = await api.me();

    print("ME RESPONSE = ${res.data}");

    return true;
  } catch (e) {
    print("SESSION FAIL = $e");
    return false;
  }
}
}

