import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lms_core_frontend/features/auth/auth_service.dart';
import 'package:lms_core_frontend/common/constants/lms_api.dart';

class Appointment {
  final int id;
  final String name;
  final List<int> groupIds;
  final List<int> subjectIds;

  const Appointment({
    required this.id,
    required this.name,
    required this.groupIds,
    required this.subjectIds,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as int,
      name: (json['name'] ?? '') as String,
      groupIds:
          (json['group_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      subjectIds:
          (json['subject_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }
}

class AppointmentService {
  final AuthService _authService = AuthService();

  Future<List<Appointment>> getAppointments() async {
    final token = await _authService.getToken();

    final uri = Uri.parse('$baseUrl/appointments/get_appointments');

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
          .map((e) => Appointment.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Failed to fetch appointments (${response.statusCode})');
  }
}
