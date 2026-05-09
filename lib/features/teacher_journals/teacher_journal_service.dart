import 'dart:convert';
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

class TeacherJournal {
  final String subject;
  final List<JournalRef> groups;

  const TeacherJournal({required this.subject, required this.groups});

  factory TeacherJournal.fromJson(Map<String, dynamic> json) {
    return TeacherJournal(
      subject: (json['subject'] ?? '').toString(),
      groups:
      (json['groups'] as List<dynamic>? ?? [])
          .map((e) => JournalRef.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TeacherJournalService {
  final AuthService _authService = AuthService();

  Future<List<TeacherJournal>> getTeacherJournals() async {
    final token = await _authService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/journals/my'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final list = jsonDecode(response.body) as List<dynamic>;
      return list
          .map((e) => TeacherJournal.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to fetch groups (${response.statusCode})');
  }
}
