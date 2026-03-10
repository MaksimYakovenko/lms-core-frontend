import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lms_core_frontend/common/components/app_toast_component.dart';
import 'package:lms_core_frontend/config/routers/view_identifiers.dart';
import 'package:lms_core_frontend/features/auth/auth_provider.dart';
import 'package:lms_core_frontend/features/auth/login_screen.dart';
import 'package:lms_core_frontend/features/auth/registry_screen.dart';
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
      GoRoute(
        path: ViewIdentifiers.registry.path,
        name: ViewIdentifiers.registry.name,
        builder: (context, state) => const RegistryScreen(),
      ),
    ],
  ),
];

class _LoginScreen extends StatelessWidget {
  const _LoginScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return LoginForm(
            isLoading: auth.isLoading,
            error: auth.error,
            onLogin: (email, password) async {
              final success = await auth.login(
                email: email,
                password: password,
              );
              if (success && context.mounted) {
                AppToast.success(
                  context,
                  title: 'Welcome back!',
                  description: 'You have successfully signed in.',
                );
                context.goNamed(ViewIdentifiers.home.name);
              }
            },
          );
        },
      ),
    );
  }
}
