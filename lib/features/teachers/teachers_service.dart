import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lms_core_frontend/features/auth/auth_service.dart';

class TeacherUser {
  final int id;
  final String email;
  final String name;
  final String role;
  final String? lastLogin;

  const TeacherUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.lastLogin,
  });

  factory TeacherUser.fromJson(Map<String, dynamic> json) {
    return TeacherUser(
      id: json['id'] as int,
      email: (json['email'] ?? '') as String,
      name: (json['name'] ?? '') as String,
      role: (json['role'] ?? '') as String,
      lastLogin: json['last_login'] as String?,
    );
  }
}

class TeachersService {
  static const _baseUrl = 'https://lms-core-api-production.up.railway.app';

  final AuthService _authService = AuthService();

  Future<List<TeacherUser>> getTeachers() async {
    final token = await _authService.getToken();

    final uri = Uri.parse('$_baseUrl/teachers/get_teachers');

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
          .map((e) => TeacherUser.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to fetch teachers (${response.statusCode})');
  }

  Future<void> createTeacher(String email) async {
    final token = await _authService.getToken();

    final uri = Uri.parse('$_baseUrl/teachers/create_teacher');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'email': email, 'role': 'TEACHER'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) return;

    final body = jsonDecode(response.body);
    final detail = body['detail'] ?? 'Failed to create teacher (${response.statusCode})';
    throw Exception(detail);
  }

  Future<void> deleteTeacher(int id) async {
    final token = await _authService.getToken();

    final uri = Uri.parse('$_baseUrl/teachers/delete_teacher/$id')
        .replace(queryParameters: {'teacher_id': '$id'});

    final response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) return;

    final body = jsonDecode(response.body);
    final detail = body['detail'] ?? 'Failed to delete teacher (${response.statusCode})';
    throw Exception(detail);
  }
}

