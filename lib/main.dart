import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:lms_core_frontend/config/routers/dashboard_routers.dart';
import 'package:lms_core_frontend/features/auth/auth_provider.dart';
import 'package:lms_core_frontend/features/not_found_page/not_found_page_screen.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';

final _router = GoRouter(
  routes: dashboardRoutes,
  errorBuilder: (context, state) => const NotFoundPageScreen(),
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
    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'LMS',
        theme: ThemeData(
          // set global scaffold background to main app background
          scaffoldBackgroundColor: AppColors.background1,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: _router,
      ),
    );
  }
}
