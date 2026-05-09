import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:lms_core_frontend/features/auth/auth_service.dart';

import '../../../common/constants/lms_api.dart';

class JournalRef {
  final int journalId;
  final int groupId;
  final String name;
  final int courseNumber;
  final String? teacherName;
  final DateTime? lastUpdated;

  const JournalRef({
    required this.journalId,
    required this.groupId,
    required this.name,
    this.courseNumber = 0,
    this.teacherName,
    this.lastUpdated,
  });

  factory JournalRef.fromJson(Map<String, dynamic> json) {
    return JournalRef(
      journalId: (json['journal_id'] as num).toInt(),
      groupId: (json['group_id'] as num).toInt(),
      name: (json['name'] ?? '').toString(),
      courseNumber:
          json['course_number'] != null
              ? (json['course_number'] as num).toInt()
              : 0,
      teacherName: json['teacher_name']?.toString(),
      lastUpdated:
          json['last_updated'] != null
              ? DateTime.tryParse(json['last_updated'].toString())
              : null,
    );
  }
}

class Journal {
  final String subject;
  final List<JournalRef> groups;

  const Journal({required this.subject, required this.groups});

  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
      subject: (json['subject'] ?? '').toString(),
      groups:
          (json['groups'] as List<dynamic>? ?? [])
              .map((e) => JournalRef.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class JournalsService {
  final AuthService _authService = AuthService();

  Future<List<Journal>> getJournals() async {
    final token = await _authService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/journals'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final list = jsonDecode(response.body) as List<dynamic>;
      return list
          .map((e) => Journal.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to fetch groups (${response.statusCode})');
  }

  Future<List<Journal>> getTeacherJournals() async {
    final token = await _authService.getToken();
    final uri = Uri.parse('$baseUrl/journals/my');
    debugPrint('[JournalsService] getTeacherJournals → $uri');
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
          .map((e) => Journal.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to fetch groups (${response.statusCode})');
  }

  Future<void> createJournalWithAssignment({
    required int groupId,
    required int subjectId,
    required int teacherId,
    required int? assistantId,
  }) async {
    final token = await _authService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/journals'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'group_id': groupId,
        'subject_id': subjectId,
        'teacher_id': teacherId,
        'assistant_id': assistantId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) return;

    final body = jsonDecode(response.body);
    final detail =
        body['detail'] ?? 'Failed to create journal (${response.statusCode})';
    throw Exception(detail);
  }

  Future<void> deleteJournal(int id) async {
    final token = await _authService.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/journals/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) return;

    final body = jsonDecode(response.body);
    final detail =
        body['detail'] ?? 'Failed to delete journal (${response.statusCode})';
    throw Exception(detail);
  }
}
