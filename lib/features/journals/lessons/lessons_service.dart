import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lms_core_frontend/features/auth/auth_service.dart';
import '../../../common/constants/lms_api.dart';

class LessonType {
  final String value;
  final String label;

  const LessonType({required this.value, required this.label});

  factory LessonType.fromJson(Map<String, dynamic> json) {
    return LessonType(
      value: json['value'] as String,
      label: json['label'] as String,
    );
  }
}

class LessonPeriod {
  final int number;
  final String label;
  final String startTime;
  final String endTime;

  const LessonPeriod({
    required this.number,
    required this.label,
    required this.startTime,
    required this.endTime,
  });

  factory LessonPeriod.fromJson(Map<String, dynamic> json) {
    return LessonPeriod(
      number: (json['number'] as num).toInt(),
      label: json['label'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
    );
  }
}

class LessonsService {
  final AuthService _authService = AuthService();

  Future<Map<String, String>> _headers() async {
    final token = await _authService.getToken();

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<List<LessonType>> getLessonTypes() async {
    final uri = Uri.parse('$baseUrl/lessons/get_lesson_types');

    final response = await http.get(uri, headers: await _headers());

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;

      return list.map((e) => LessonType.fromJson(e)).toList();
    }

    throw Exception('Failed to fetch lesson types');
  }

  Future<List<LessonPeriod>> getLessonPeriods() async {
    final uri = Uri.parse('$baseUrl/lessons/get_lesson_periods');

    final response = await http.get(uri, headers: await _headers());

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;

      return list.map((e) => LessonPeriod.fromJson(e)).toList();
    }

    throw Exception('Failed to fetch lesson periods');
  }

  Future<void> createLesson({
    required DateTime date,
    required String lessonType,
    int? classroomId,
    int? lessonNumber,
    required int journalId,
  }) async {
    final uri = Uri.parse('$baseUrl/journals/$journalId/lessons');

    final requestBody = <String, dynamic>{
      'date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
      'lesson_type': lessonType,
      if (classroomId != null) 'classroom_id': classroomId,
      if (lessonNumber != null) 'lesson_number': lessonNumber,
    };

    final response = await http.post(
      uri,
      headers: await _headers(),
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200 || response.statusCode == 201) return;

    final body = jsonDecode(response.body);
    final detail = body['detail'] ?? 'Failed to create lesson (${response.statusCode})';
    throw Exception(detail);
  }
}
