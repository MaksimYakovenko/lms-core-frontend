import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lms_core_frontend/common/components/app_toast_component.dart';
import 'package:lms_core_frontend/common/components/left_sidebar_component.dart';
import 'package:lms_core_frontend/config/routers/view_identifiers.dart';
import 'package:lms_core_frontend/features/auth/auth_provider.dart';

const _studentPathToIndex = {
  '/dashboard': 0,
  '/results': 1,
  '/tests': 2,
  '/resources': 3,
  '/news': 4,
  '/subjects': 5,
};

const _adminPathToIndex = {
  '/admin-admin_main': 0,
  '/teachers': 1,
  '/admins': 2,
  '/students': 3,
  '/groups': 4,
  '/subjects': 5,
  '/journals': 6,
  '/appointment': 7,
  '/news': 8,
};

class DashboardScreen extends StatelessWidget {
  final Widget child;

  const DashboardScreen({super.key, required this.child});

  static const _studentIndexToRoute = [
    'student-home',
    'results',
    'tests',
    'resources',
    'news',
    'subjects',
  ];

  static const _adminIndexToRoute = [
    'admin-admin_main',
    'teachers',
    'admins',
    'students',
    'groups',
    'subjects',
    'journals',
    'appointment',
    'news',
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isAdmin = auth.userRole?.toLowerCase() == 'admin';

    final pathToIndex = isAdmin ? _adminPathToIndex : _studentPathToIndex;
    final indexToRoute = isAdmin ? _adminIndexToRoute : _studentIndexToRoute;
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = pathToIndex[location] ?? 0;
    final isAuthPage = location == '/login' || location == '/registry';
    if (isAuthPage) return child;

    return Scaffold(
      body: Row(
        children: [
          LeftSidebarComponent(
            selectedIndex: selectedIndex,
            isAuthenticated: auth.isAuthenticated,
            userName: auth.userName,
            userRole: auth.userRole,
            onItemSelected: (index) {
              context.goNamed(indexToRoute[index]);
            },
            onLogout: () async {
              await context.read<AuthProvider>().logout();
              if (context.mounted) {
                AppToast.info(
                  context,
                  title: 'Вийшли із системи',
                  description: 'Ви успішно вийшли з системи.',
                  alignment: Alignment.topRight,
                );
                context.goNamed(ViewIdentifiers.login.name);
              }
            },
            onSignIn: () {
              context.goNamed(ViewIdentifiers.login.name);
            },
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

