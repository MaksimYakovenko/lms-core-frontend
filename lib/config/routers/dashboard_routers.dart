import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lms_core_frontend/config/routers/view_identifiers.dart';
import 'package:lms_core_frontend/features/auth/auth_provider.dart';
import 'package:lms_core_frontend/features/auth/login_screen.dart';
import 'package:lms_core_frontend/features/dashboard/dashboard_screen.dart';

final dashboardRoutes = [
  GoRoute(
    path: ViewIdentifiers.home.path,
    name: ViewIdentifiers.home.name,
    builder: (context, state) => const DashboardScreen(),
    routes: [
      GoRoute(
        path: ViewIdentifiers.login.path,
        name: ViewIdentifiers.login.name,
        builder: (context, state) => const _LoginScreen(),
      ),
    ],
  ),
];

class _LoginScreen extends StatelessWidget {
  const _LoginScreen();

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return Scaffold(
      body: LoginForm(
        onLogin: (email, password) async {
          await auth.login(token: 'mock_token', name: email, role: 'student');
          if (context.mounted) context.goNamed(ViewIdentifiers.home.name);
        },
      ),
    );
  }
}


