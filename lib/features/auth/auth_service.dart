import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignInResponse {
  final String accessToken;

  const SignInResponse({required this.accessToken});

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      accessToken: (json['access_token'] ?? json['token'] ?? '') as String,
    );
  }
}

class AuthService {
  static const _baseUrl = 'https://lms-core-api-production.up.railway.app';
  static const _tokenKey = 'access_token';
  static const _userNameKey = 'user_name';
  static const _userRoleKey = 'user_role';

  Future<SignInResponse> signIn({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/sign-in');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return SignInResponse.fromJson(json);
    }

    String message = 'Invalid email or password';
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      message = (json['message'] ?? json['error'] ?? message).toString();
    } catch (_) {}

    throw Exception(message);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userRoleKey);
  }

  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> saveUserInfo({required String name, required String role}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
    await prefs.setString(_userRoleKey, role);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }
}
