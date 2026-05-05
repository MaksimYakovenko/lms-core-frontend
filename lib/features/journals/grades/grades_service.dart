import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lms_core_frontend/features/auth/auth_service.dart';

import '../../../common/constants/lms_api.dart';

class GradesService {
  final AuthService _authService = AuthService();

  Future<void> updateGrades(
    int journalId,
    int lessonId,
    int studentId,
    String value,
    String? remark,
  ) async {
    final token = await _authService.getToken();

    final uri = Uri.parse('$baseUrl/journals/$journalId/grades');

    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'lesson_id': lessonId,
        'student_id': studentId,
        'value': value,
        'remark': remark,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) return;

    final body = jsonDecode(response.body);
    final detail =
        body['detail'] ??
        'Failed to update grade for student (${response.statusCode})';
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
}
