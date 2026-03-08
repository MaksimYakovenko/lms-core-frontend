import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lms_core_frontend/config/routers/dashboard_routers.dart';
import 'package:lms_core_frontend/features/auth/auth_provider.dart';

final _router = GoRouter(
  routes: dashboardRoutes,
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.checkAuth();
  runApp(
    ChangeNotifierProvider<AuthProvider>.value(
      value: authProvider,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LMS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _router,
    );
  }
}
