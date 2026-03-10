import 'package:flutter/foundation.dart';
import 'package:lms_core_frontend/features/auth/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _error;
  String? _userName;
  String? _userRole;
  String? _token;

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userName => _userName;
  String? get userRole => _userRole;
  String? get token => _token;

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

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _authService.signIn(email: email, password: password);

      final user = await _authService.getMe(result.accessToken);

      await _authService.saveToken(result.accessToken);
      await _authService.saveUserInfo(name: user.fullName, role: user.roleFormatted);

      _token = result.accessToken;
      _userName = user.fullName;
      _userRole = user.roleFormatted;
      _isAuthenticated = true;
      _error = null;
      return true;
    } catch (e) {
      _error = e.toString().replaceFirst('Exception: ', '');
      _isAuthenticated = false;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.deleteToken();
    _token = null;
    _userName = null;
    _userRole = null;
    _isAuthenticated = false;
    _error = null;
    notifyListeners();
  }
}
