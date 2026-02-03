import 'dart:math';
import 'dart:convert';
import '../models/user.dart';
import '../services/mock_hash_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthService {
  static final MockAuthService _instance = MockAuthService._();
  static const _usersKey = "mock_users";
  static const _tokenKey = "mock_token";
  static const _currentUserKey = "mock_current_user";

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = jsonEncode(_users);
    await prefs.setString(_usersKey, jsonList);
  }

  Future<void> _loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_usersKey);
    if (str == null) return;

    final list = jsonDecode(str) as List;
    _users.clear();
    _users.addAll(list.map((e) => Map<String, String>.from(e)));
  }

  Future<void> _saveSession() async {
    final prefs = await SharedPreferences.getInstance();

    if (accessToken != null) {
      await prefs.setString(_tokenKey, accessToken!);
    }

    if (currentUser != null) {
      await prefs.setString(
        _currentUserKey,
        jsonEncode({
          "id": currentUser!.id,
          "email": currentUser!.email,
          "name": currentUser!.name,
        }),
      );
    }
  }

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();

    accessToken = prefs.getString(_tokenKey);

    final userStr = prefs.getString(_currentUserKey);
    if (userStr != null) {
      final j = jsonDecode(userStr);
      currentUser = User(id: j["id"], email: j["email"], name: j["name"]);
    }

    await _loadUsers();
  }

  MockAuthService._();

  factory MockAuthService() => _instance;

  final List<Map<String, String>> _users = [];

  User? currentUser;
  String? accessToken;

  Future<void> register({
    required String email,
    required String password,
    required String name,
  }) async {
    await _loadUsers();

    final exists = _users.any((u) => u['email'] == email);
    if (exists) {
      throw Exception("Email already exists");
    }

    _users.add({
      "id": _id(),
      "email": email,
      "password": hashPassword(password),
      "name": name,
    });

    await _saveUsers();
  }

  Future<User> login({required String email, required String password}) async {
    await _loadUsers();

    final hashed = hashPassword(password);

    final u = _users.firstWhere(
      (e) => e['email'] == email && e['password'] == hashed,
      orElse: () => {},
    );

    if (u.isEmpty) {
      throw Exception("Invalid credentials");
    }

    currentUser = User(id: u['id']!, email: u['email']!, name: u['name']!);

    accessToken = _fakeJwt();

    await _saveSession();

    return currentUser!;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_currentUserKey);

    currentUser = null;
    accessToken = null;
  }

  String _id() => Random().nextInt(999999).toString();

  String _fakeJwt() =>
      "mock.jwt.token.${DateTime.now().millisecondsSinceEpoch}";
}
