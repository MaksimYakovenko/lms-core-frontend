import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lms_core_frontend/features/auth/auth_service.dart';

import '../../../common/constants/lms_api.dart';

class JournalGrade {
  final int? id;
  final int lessonId;
  final int? studentId;
  final String? value;

  const JournalGrade({this.id, required this.lessonId, this.studentId, this.value});

  factory JournalGrade.fromJson(Map<String, dynamic> json) {
    return JournalGrade(
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      lessonId: (json['lesson_id'] as num).toInt(),
      studentId:
          json['student_id'] != null
              ? (json['student_id'] as num).toInt()
              : null,
      value: json['value']?.toString(),
    );
  }
}

class JournalLesson {
  final int id;
  final DateTime date;
  final String? lessonType;
  final int? orderIndex;
  final String? title;
  final String? description;
  final int? classroomId;

  const JournalLesson({
    required this.id,
    required this.date,
    this.lessonType,
    this.orderIndex,
    this.title,
    this.description,
    this.classroomId,
  });

  factory JournalLesson.fromJson(Map<String, dynamic> json) {
    return JournalLesson(
      id: (json['id'] as num).toInt(),
      date: DateTime.parse(json['date'] as String),
      lessonType: json['lesson_type']?.toString(),
      orderIndex:
          json['order_index'] != null
              ? (json['order_index'] as num).toInt()
              : null,
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      classroomId: json['classroom_id'] != null ? (json['classroom_id'] as num).toInt() : null,
    );
  }

  String? get typeLabel {
    switch (lessonType) {
      case 'LECTURE':
        return 'Лек.';
      case 'SEMINAR':
        return 'Сем.';
      case 'PRACTICE':
        return 'Пр.';
      case 'CREDIT':
        return 'Зал.';
      case 'EXAM':
        return 'Екз.';
      case 'LAB':
        return 'Лаб.';
      case 'MODULE':
        return 'МКР';
      case 'COLLOQUIUM':
        return 'Колокв.';
      case 'CONSULTATION':
        return 'Конс.';
      case 'FACULTATIVE':
        return 'Факул.';
      default:
        return lessonType;
    }
  }

  Color get typeBadgeBg {
    switch (lessonType) {
      case 'LECTURE':
        return const Color(0xFFDBEAFE);

      case 'SEMINAR':
        return const Color(0xFFF3E8FF);

      case 'PRACTICE':
        return const Color(0xFFD1FAE5);

      case 'LAB':
        return const Color(0xFFE0F2FE);

      case 'CREDIT':
        return const Color(0xFFFEF3C7);

      case 'EXAM':
        return const Color(0xFFFEE2E2);

      case 'MODULE':
        return const Color(0xFFE5E7EB);

      case 'COLLOQUIUM':
        return const Color(0xFFFFEDD5);

      case 'CONSULTATION':
        return const Color(0xFFE0E7FF);

      case 'FACULTATIVE':
        return const Color(0xFFF0FDF4);

      default:
        return const Color(0xFFF3F4F6);
    }
  }

  /// Badge text color per type
  Color get typeBadgeText {
    switch (lessonType) {
      case 'LECTURE':
        return const Color(0xFF1D4ED8);
      case 'SEMINAR':
        return const Color(0xFF7C3AED);
      case 'PRACTICAL':
        return const Color(0xFF065F46);
      case 'CREDIT':
        return const Color(0xFF92400E);
      case 'EXAM':
        return const Color(0xFF991B1B);
      case 'LAB':
        return const Color(0xFF0369A1);
      default:
        return const Color(0xFF374151);
    }
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

  factory JournalStudent.fromJson(
    Map<String, dynamic> json, {
    List<JournalGrade> externalGrades = const [],
  }) {
    final embedded =
        (json['grades'] as List<dynamic>? ?? [])
            .map((e) => JournalGrade.fromJson(e as Map<String, dynamic>))
            .toList();

    final studentId = (json['id'] as num).toInt();
    final fromExternal =
        externalGrades.where((g) => g.studentId == studentId).toList();

    return JournalStudent(
      id: studentId,
      fullName: (json['full_name'] ?? json['name'] ?? '').toString(),
      grades: embedded.isNotEmpty ? embedded : fromExternal,
    );
  }

  String? gradeFor(int lessonId) {
    try {
      return grades.firstWhere((g) => g.lessonId == lessonId).value;
    } catch (_) {
      return null;
    }
  }

  JournalGrade? gradeObjectFor(int lessonId) {
    try {
      return grades.firstWhere((g) => g.lessonId == lessonId);
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

    final topGrades =
        (json['grades'] as List<dynamic>? ?? [])
            .map((e) => JournalGrade.fromJson(e as Map<String, dynamic>))
            .toList();

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
              .map(
                (e) => JournalStudent.fromJson(
                  e as Map<String, dynamic>,
                  externalGrades: topGrades,
                ),
              )
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

  Future<void> deleteGrade(int journalId, int gradeId) async {
    final token = await _authService.getToken();

    final uri = Uri.parse('$baseUrl/journals/$journalId/grades/$gradeId');

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
        body['detail'] ??
        'Failed to delete grade for student (${response.statusCode})';
    throw Exception(detail);
  }

  Future<void> putGrade(
    int journalId, {
    required int lessonId,
    required int studentId,
    required String value,
    String? remark,
  }) async {
    final token = await _authService.getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/journals/$journalId/grades'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'lesson_id': lessonId,
        'student_id': studentId,
        'value': value,
        'remark': remark ?? '',
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) return;

    final body = jsonDecode(response.body);
    final detail =
        body['detail'] ?? 'Failed to save grade (${response.statusCode})';
    throw Exception(detail);
  }
}
