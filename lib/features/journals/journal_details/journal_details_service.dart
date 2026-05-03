import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:lms_core_frontend/features/auth/auth_service.dart';

import '../../../common/constants/lms_api.dart';

class JournalGrade {
  final int lessonId;
  final String? value;

  const JournalGrade({required this.lessonId, this.value});

  factory JournalGrade.fromJson(Map<String, dynamic> json) {
    return JournalGrade(
      lessonId: (json['lesson_id'] as num).toInt(),
      value: json['value']?.toString(),
    );
  }
}

class JournalLesson {
  final int id;
  final DateTime date;
  final String? groupTag;

  const JournalLesson({required this.id, required this.date, this.groupTag});

  factory JournalLesson.fromJson(Map<String, dynamic> json) {
    return JournalLesson(
      id: (json['id'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      groupTag: json['group_tag']?.toString(),
    );
  }
}

class JournalStudent {
  final int id;
  final String fullName;
  final List<JournalGrade> grades;

  const JournalStudent({
    required this.id,
    required this.fullName,
    required this.grades,
  });

  factory JournalStudent.fromJson(Map<String, dynamic> json) {
    return JournalStudent(
      id: (json['id'] as num).toInt(),
      fullName: (json['full_name'] ?? json['name'] ?? '').toString(),
      grades:
          (json['grades'] as List<dynamic>? ?? [])
              .map((e) => JournalGrade.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  String? gradeFor(int lessonId) {
    try {
      return grades.firstWhere((g) => g.lessonId == lessonId).value;
    } catch (_) {
      return null;
    }
  }
}

class JournalDetails {
  final int id;
  final String subject;
  final String groupName;
  final String teacherName;
  final List<JournalLesson> lessons;
  final List<JournalStudent> students;

  const JournalDetails({
    required this.id,
    required this.subject,
    required this.groupName,
    required this.teacherName,
    required this.lessons,
    required this.students,
  });


  factory JournalDetails.fromJson(Map<String, dynamic> json) {
    final subjectMap =
        json['subject'] is Map ? json['subject'] as Map<String, dynamic> : null;

    final groupMap =
        json['group'] is Map ? json['group'] as Map<String, dynamic> : null;

    final teacherMap =
        json['teacher'] is Map ? json['teacher'] as Map<String, dynamic> : null;

    return JournalDetails(
      id: (json['id'] as num).toInt(),
      subject:
          subjectMap != null
              ? (subjectMap['name'] ?? '').toString()
              : (json['subject'] ?? '').toString(),
      groupName:
          groupMap != null
              ? (groupMap['name'] ?? '').toString()
              : (json['group_name'] ?? '').toString(),
      teacherName:
          teacherMap != null
              ? (teacherMap['name'] ?? '').toString()
              : (json['teacher_name'] ?? '').toString(),
      lessons:
          (json['lessons'] as List<dynamic>? ?? [])
              .map((e) => JournalLesson.fromJson(e as Map<String, dynamic>))
              .toList(),
      students:
          (json['students'] as List<dynamic>? ?? [])
              .map((e) => JournalStudent.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

class JournalDetailsService {
  final AuthService _authService = AuthService();

  Future<JournalDetails> getJournalById(int id) async {
    final token = await _authService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/journals/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return JournalDetails.fromJson(
        jsonDecode(response.body) as Map<String, dynamic>,
      );
    }

    final body = jsonDecode(response.body);
    final detail =
        body['detail'] ?? 'Failed to fetch journal (${response.statusCode})';
    throw Exception(detail);
  }
}
