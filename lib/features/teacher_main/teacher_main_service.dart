import 'package:flutter/src/widgets/framework.dart';
import 'package:lms_core_frontend/features/auth/auth_service.dart';

class TeacherMainService {
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

  Future<void> logout() async {
    await _authService.deleteToken();
  }
}