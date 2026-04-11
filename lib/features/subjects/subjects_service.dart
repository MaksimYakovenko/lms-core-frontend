import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lms_core_frontend/features/auth/auth_service.dart';

class Subject {
  final int id;
  final String name;

  const Subject({required this.id, required this.name});

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(id: json['id'] as int, name: (json['name'] ?? '') as String);
  }
}

class SubjectsService {
  static const _baseUrl = 'https://lms-core-api-production.up.railway.app';

  final AuthService _authService = AuthService();

  Future<List<Subject>> getSubjects() async {
    final token = await _authService.getToken();

    final uri = Uri.parse('$_baseUrl/subjects/get_subjects');

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
          .map((e) => Subject.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to fetch subjects (${response.statusCode})');
  }

  Future<void> createSubject(String name) async {
    final token = await _authService.getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/subjects/create_subject'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) return;

    final body = jsonDecode(response.body);
    final detail =
        body['detail'] ?? 'Failed to create subject (${response.statusCode})';
    throw Exception(detail);
  }

  Future<void> updateSubject(int id, {required String name}) async {
    final token = await _authService.getToken();

    final response = await http.put(
      Uri.parse('$_baseUrl/subjects/update_subject'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'id': id, 'name': name}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) return;

    final body = jsonDecode(response.body);
    final detail =
        body['detail'] ?? 'Failed to update subject (${response.statusCode})';
    throw Exception(detail);
  }

  Future<void> deleteSubject(int id) async {
    final token = await _authService.getToken();

    final uri = Uri.parse(
      '$_baseUrl/subjects/delete_subject/$id',
    ).replace(queryParameters: {'subject_id': '$id'});

    final response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) return;

    final body = jsonDecode(response.body);
    final detail =
        body['detail'] ?? 'Failed to delete student (${response.statusCode})';
    throw Exception(detail);
  }
}
