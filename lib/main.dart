import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:lms_core_frontend/config/routers/dashboard_routers.dart';
import 'package:lms_core_frontend/features/auth/auth_provider.dart';
import 'package:lms_core_frontend/features/not_found_page/not_found_page_screen.dart';
import 'package:lms_core_frontend/common/constants/colors.dart';

GoRouter _createRouter(AuthProvider authProvider) {
  const publicPaths = {'/login', '/registry'};

  return GoRouter(
    routes: dashboardRoutes,
    errorBuilder: (context, state) => const NotFoundPageScreen(),
    refreshListenable: authProvider,
    redirect: (context, state) {
      final isAuthenticated = authProvider.isAuthenticated;
      final isPublic = publicPaths.contains(state.matchedLocation);

      if (!isAuthenticated && !isPublic) {
        return '/login';
      }
      if (isAuthenticated && isPublic) {
        return '/dashboard';
      }
      return null;
    },
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.checkAuth();
  runApp(
    ChangeNotifierProvider<AuthProvider>.value(
      value: authProvider,
      child: MyApp(authProvider: authProvider),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.authProvider});

  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        locale: const Locale('uk'),
        supportedLocales: const [Locale('uk'), Locale('en'), Locale('ru')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'LMS',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background1,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        routerConfig: _createRouter(authProvider),
      ),
    );
  }
}
