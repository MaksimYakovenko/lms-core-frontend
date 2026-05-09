import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lms_core_frontend/features/auth/auth_service.dart';

import '../../common/constants/lms_api.dart';

class Group {
  final int id;
  final String name;
  final int courseNumber;

  const Group({required this.id, required this.name, required this.courseNumber});

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
      courseNumber: (json['course_number'] ?? 0) as int,
    );
  }
}

class GroupsService {

  final AuthService _authService = AuthService();

  Future<List<Group>> getGroups() async {
    final token = await _authService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/groups/get_groups'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final list = jsonDecode(response.body) as List<dynamic>;
      return list.map((e) => Group.fromJson(e as Map<String, dynamic>)).toList();
    }

    throw Exception('Failed to fetch groups (${response.statusCode})');
  }


  Future<List<Group>> getTeacherGroups() async {
    final token = await _authService.getToken();

    final response = await http.get(
      Uri.parse('$baseUrl/groups/my'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final list = jsonDecode(response.body) as List<dynamic>;
      return list.map((e) => Group.fromJson(e as Map<String, dynamic>)).toList();
    }

    throw Exception('Failed to fetch teacher groups (${response.statusCode})');
  }

  Future<void> createGroup(String name, int courseNumber) async {
    final token = await _authService.getToken();

    final response = await http.post(
      Uri.parse('$baseUrl/groups/create_group'),
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

  Future<void> updateGroup(int id, int courseNumber, {required String name}) async {
    final token = await _authService.getToken();

    final response = await http.put(
      Uri.parse('$baseUrl/groups/update_group/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'id': id, 'name': name, 'course_number': courseNumber}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) return;

    final body = jsonDecode(response.body);
    final detail = body['detail'] ?? 'Failed to update group (${response.statusCode})';
    throw Exception(detail);
  }

  Future<void> deleteGroup(int id) async {
    final token = await _authService.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/groups/delete_group/$id'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) return;

    final body = jsonDecode(response.body);
    final detail = body['detail'] ?? 'Failed to delete group (${response.statusCode})';
    throw Exception(detail);
  }
}

