import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lms_core_frontend/features/auth/auth_service.dart';

class JournalRef {
  final int id;
  final String name;

  const JournalRef({required this.id, required this.name});

  factory JournalRef.fromJson(Map<String, dynamic> json) {
    return JournalRef(
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
    );
  }
}

class Journal {
  final int id;
  final JournalRef group;
  final JournalRef subject;
  final JournalRef teacher;
  final JournalRef? assistant;
  final List<dynamic> lessons;

  const Journal({
    required this.id,
    required this.group,
    required this.subject,
    required this.teacher,
    this.assistant,
    required this.lessons,
  });

  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
      id: json['id'] as int,
      group: JournalRef.fromJson(json['group'] as Map<String, dynamic>),
      subject: JournalRef.fromJson(json['subject'] as Map<String, dynamic>),
      teacher: JournalRef.fromJson(json['teacher'] as Map<String, dynamic>),
      assistant: json['assistant'] != null
          ? JournalRef.fromJson(json['assistant'] as Map<String, dynamic>)
          : null,
      lessons: (json['lessons'] as List<dynamic>?) ?? [],
    );
  }
}

class JournalsService {
  static const _baseUrl = 'https://lms-core-api-production.up.railway.app';

  final AuthService _authService = AuthService();

  Future<List<Journal>> getJournals() async {
    final token = await _authService.getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/journals'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final list = jsonDecode(response.body) as List<dynamic>;
      return list.map((e) => Journal.fromJson(e as Map<String, dynamic>)).toList();
    }

    throw Exception('Failed to fetch groups (${response.statusCode})');
  }

  Future<void> getJournalById(int id) async {
    final token = await _authService.getToken();

    final response = await http.get(
      Uri.parse('$_baseUrl/journals/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) return;

    final body = jsonDecode(response.body);
    final detail = body['detail'] ?? 'Failed to fetch journal (${response.statusCode})';
    throw Exception(detail);
  }

  Future<void> createJournal(String name, int courseNumber) async {
    final token = await _authService.getToken();

    final response = await http.post(
      Uri.parse('$_baseUrl/journals'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name, 'course_number': courseNumber}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) return;

    final body = jsonDecode(response.body);
    final detail = body['detail'] ?? 'Failed to create group (${response.statusCode})';
    throw Exception(detail);
  }

  Future<void> deleteJournal(int id) async {
    final token = await _authService.getToken();

    final response = await http.delete(
      Uri.parse('$_baseUrl/journals/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) return;

    final body = jsonDecode(response.body);
    final detail = body['detail'] ?? 'Failed to delete journal (${response.statusCode})';
    throw Exception(detail);
  }
}

