import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthApiService api;
  final _storage = const FlutterSecureStorage();

  AuthRepository(this.api);

  Future<void> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    await api.register(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final res = await api.login(email: email, password: password);
    final token = res.data['token'] as String;
    await _storage.write(key: 'access_token', value: token);
    return token;
  }

  Future<void> logout() async {
    await api.logout();
    await _storage.delete(key: 'access_token');
  }
}
