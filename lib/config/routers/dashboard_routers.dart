import 'package:go_router/go_router.dart';
import 'package:lms_core_frontend/config/routers/view_identifiers.dart';
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
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: ViewIdentifiers.registry.path,
        name: ViewIdentifiers.registry.name,
        builder: (context, state) => const RegistryScreen(),
      ),
    ],
  ),
];

