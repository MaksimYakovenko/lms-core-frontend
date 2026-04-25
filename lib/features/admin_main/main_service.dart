import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:lms_core_frontend/features/auth/auth_service.dart';

class AdminMainService {
  final AuthService _authService = AuthService();

  Future<String?> fetchDisplayName(BuildContext context) async {
    final token = await _authService.getToken();

    if (token == null || token.isEmpty) {
      return null;
    }

    final user = await _authService.getMe(token);
    final name = user.fullName;

    return name.isNotEmpty ? name : 'Test User';
  }

  Future<Map<String, int>?> fetchTotals(BuildContext context) async {
    final token = await _authService.getToken();

    if (token == null || token.isEmpty) {
      return null;
    }

    final uri = Uri.parse(
      'https://lms-core-api-production.up.railway.app/total_count',
    );

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to fetch totals');
    }

    final data = response.body.isNotEmpty
        ? jsonDecode(response.body) as Map<String, dynamic>
        : <String, dynamic>{};

    return {
      'total_teachers': (data['total_teachers'] ?? 0) as int,
      'total_students': (data['total_students'] ?? 0) as int,
      'total_groups': (data['total_groups'] ?? 0) as int,
      'total_subjects': (data['total_subjects'] ?? 0) as int,
    };
  }

  Future<void> logout() async {
    await _authService.deleteToken();
  }
}