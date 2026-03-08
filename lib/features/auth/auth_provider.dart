import 'package:flutter/foundation.dart';
import 'package:lms_core_frontend/features/auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isAuthenticated = false;
  String? _userName;
  String? _userRole;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  String? get userName => _userName;
  String? get userRole => _userRole;
  String? get token => _token;

  /// Ініціалізація при старті — перевіряємо збережений токен
  Future<void> checkAuth() async {
    final authenticated = await _authService.isAuthenticated();
    if (authenticated) {
      _token = await _authService.getToken();
      _userName = await _authService.getUserName();
      _userRole = await _authService.getUserRole();
      _isAuthenticated = true;
    } else {
      _isAuthenticated = false;
      _token = null;
      _userName = null;
      _userRole = null;
    }
    notifyListeners();
  }

  /// Виклик після успішного логіну — зберігаємо токен та дані юзера
  Future<void> login({
    required String token,
    required String name,
    required String role,
  }) async {
    await _authService.saveToken(token);
    await _authService.saveUserInfo(name: name, role: role);
    _token = token;
    _userName = name;
    _userRole = role;
    _isAuthenticated = true;
    notifyListeners();
  }

  /// Логаут — чистимо токен і стан
  Future<void> logout() async {
    await _authService.deleteToken();
    _token = null;
    _userName = null;
    _userRole = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}

