import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lms_core_frontend/features/auth/auth_service.dart';

class AdminUser {
  final int id;
  final String email;
  final String name;
  final String role;
  final String? lastLogin;

  const AdminUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.lastLogin,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'] as int,
      email: (json['email'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      role: (json['role'] ?? '') as String,
      lastLogin: json['last_login'] as String?,
    );
  }
}

class AdminsService {
  static const _baseUrl = 'https://lms-core-api-production.up.railway.app';

  final AuthService _authService = AuthService();

  Future<List<AdminUser>> getAdmins() async {
    final token = await _authService.getToken();

    final uri = Uri.parse('$_baseUrl/admins/get_admins');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final list = jsonDecode(response.body) as List<dynamic>;
      return list
          .map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to fetch admins (${response.statusCode})');
  }

  Future<void> createAdmin(String email) async {
    final token = await _authService.getToken();

    final uri = Uri.parse('$_baseUrl/admins/create_admin');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'email': email, 'role': 'ADMIN'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) return;

    final body = jsonDecode(response.body);
    final detail = body['detail'] ?? 'Failed to create admin (${response.statusCode})';
    throw Exception(detail);
  }
}

