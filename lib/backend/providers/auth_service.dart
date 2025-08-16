
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  bool _isAuthenticated = false;

  VoidCallback? onAuthChange; // 👈 Add this hook

  bool get isAuthenticated => _isAuthenticated;

  AuthService();

  Future<void> _checkAuth() async {
    final token = await _storage.read(key: 'auth_token');
    _isAuthenticated = token != null && token.isNotEmpty;
    notifyListeners();
    onAuthChange?.call(); // 👈 Trigger router refresh
  }

  Future<void> login(String token) async {
    await _storage.write(key: 'auth_token', value: token);
    _isAuthenticated = true;
    notifyListeners();
    onAuthChange?.call(); // 👈 Trigger router refresh
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    _isAuthenticated = false;
    notifyListeners();
    onAuthChange?.call(); // 👈 Trigger router refresh
  }

  Future<void> refresh() => _checkAuth();
}
