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

class UserMe {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String? lastLogin;

  const UserMe({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.lastLogin,
  });

  String get fullName => '$firstName $lastName'.trim();

  String get roleFormatted =>
      role.isEmpty ? '' : role[0].toUpperCase() + role.substring(1).toLowerCase();

  factory UserMe.fromJson(Map<String, dynamic> json) {
    return UserMe(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: (json['first_name'] ?? '') as String,
      lastName: (json['last_name'] ?? '') as String,
      role: (json['role'] ?? '') as String,
      lastLogin: json['last_login'] as String?,
    );
  }
}

class CaptchaResponse {
  final String captchaId;
  final String image;

  const CaptchaResponse({
    required this.captchaId,
    required this.image,
  });

  factory CaptchaResponse.fromJson(Map<String, dynamic> json) {
    return CaptchaResponse(
      captchaId: json['captcha_id'] as String,
      image: json['image'] as String,
    );
  }
}

class AuthService {
  static const _baseUrl = 'https://lms-core-api-production.up.railway.app';
  static const _tokenKey = 'access_token';
  static const _userNameKey = 'user_name';
  static const _userRoleKey = 'user_role';

  Future<CaptchaResponse> getCaptcha() async {
    final uri = Uri.parse('$_baseUrl/auth/captcha');

    final response = await http.get(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return CaptchaResponse.fromJson(json);
    }

    throw Exception('Failed to fetch captcha');
  }

  Future<void> signUp({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String birthday,
    required String captchaId,
    required String captchaAnswer,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/sign-up');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'birthday': birthday,
        'captcha_id': captchaId,
        'captcha_answer': captchaAnswer,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }

    String message = 'Registration failed';
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      message = (json['message'] ?? json['error'] ?? message).toString();
    } catch (_) {}

    throw Exception(message);
  }

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

  Future<UserMe> getMe(String accessToken) async {
    final uri = Uri.parse('$_baseUrl/users/me');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UserMe.fromJson(json);
    }

    throw Exception('Failed to fetch user info');
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
