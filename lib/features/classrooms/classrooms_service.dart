import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lms_core_frontend/features/auth/auth_service.dart';

import '../../common/constants/lms_api.dart';

class Classroom {
  final int id;
  final String name;

  const Classroom({
    required this.id,
    required this.name,
  });

  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
    );
  }
}

class ClassroomsService {

  final AuthService _authService = AuthService();

  Future<List<Classroom>> getClassrooms() async {
    final token = await _authService.getToken();

    final uri = Uri.parse('$baseUrl/classrooms/get_classrooms');

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
          .map((e) => Classroom.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to fetch students (${response.statusCode})');
  }


  Future<void> createClassroom(String name) async {
    final token = await _authService.getToken();

    final uri = Uri.parse('$baseUrl/classrooms/create_classroom');

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) return;

    final body = jsonDecode(response.body);
    final detail = body['detail'] ?? 'Failed to create classroom (${response.statusCode})';
    throw Exception(detail);
  }

  Future<void> updateClassroom(int id, {required String name}) async {
    final token = await _authService.getToken();

    final uri = Uri.parse('$baseUrl/classrooms/update_classroom');

    final response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'id': id, 'name': name}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) return;

    final body = jsonDecode(response.body);
    final detail = body['detail'] ?? 'Failed to update classroom (${response.statusCode})';
    throw Exception(detail);
  }

  Future<void> deleteClassroom(int id) async {
    final token = await _authService.getToken();

    final uri = Uri.parse('$baseUrl/classrooms/delete_classroom/$id')
        .replace(queryParameters: {'student_id': '$id'});

    final response = await http.delete(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) return;

    final body = jsonDecode(response.body);
    final detail = body['detail'] ?? 'Failed to delete classroom (${response.statusCode})';
    throw Exception(detail);
  }
}

