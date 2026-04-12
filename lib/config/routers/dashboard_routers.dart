import 'package:go_router/go_router.dart';
import 'package:lms_core_frontend/config/routers/view_identifiers.dart';
import 'package:lms_core_frontend/features/admins/admins_screen.dart';
import 'package:lms_core_frontend/features/auth/login_screen.dart';
import 'package:lms_core_frontend/features/auth/registry_screen.dart';
import 'package:lms_core_frontend/features/dashboard/dashboard_screen.dart';
import 'package:lms_core_frontend/features/groups/groups_screen.dart';
import 'package:lms_core_frontend/features/news/news_screen.dart';
import 'package:lms_core_frontend/features/payment/payment_screen.dart';
import 'package:lms_core_frontend/features/resources/resources_screen.dart';
import 'package:lms_core_frontend/features/results/results_screen.dart';
import 'package:lms_core_frontend/features/student_home/student_home_screen.dart';
import 'package:lms_core_frontend/features/students/students_screen.dart';
import 'package:lms_core_frontend/features/subjects/subjects_screen.dart';
import 'package:lms_core_frontend/features/teachers/teachers_screen.dart';
import 'package:lms_core_frontend/features/tests/tests_screen.dart';

import '../../features/admin_main/main_screen.dart';

final dashboardRoutes = [
  ShellRoute(
    builder: (context, state, shellChild) => DashboardScreen(child: shellChild),
    routes: [
      GoRoute(
        path: ViewIdentifiers.home.path,
        name: ViewIdentifiers.home.name,
        redirect: (_, __) => '/${ViewIdentifiers.studentHome.path}',
      ),
      GoRoute(
        path: '/${ViewIdentifiers.login.path}',
        name: ViewIdentifiers.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.registry.path}',
        name: ViewIdentifiers.registry.name,
        builder: (context, state) => const RegistryScreen(),
      ),

      // Student routes
      GoRoute(
        path: '/${ViewIdentifiers.studentHome.path}',
        name: ViewIdentifiers.studentHome.name,
        builder: (context, state) => const StudentHomeScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.results.path}',
        name: ViewIdentifiers.results.name,
        builder: (context, state) => const ResultsScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.tests.path}',
        name: ViewIdentifiers.tests.name,
        builder: (context, state) => const TestsScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.resources.path}',
        name: ViewIdentifiers.resources.name,
        builder: (context, state) => const ResourcesScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.payment.path}',
        name: ViewIdentifiers.payment.name,
        builder: (context, state) => const PaymentScreen(),
      ),

      // Admin routes
      GoRoute(
        path: '/${ViewIdentifiers.teachers.path}',
        name: ViewIdentifiers.teachers.name,
        builder: (context, state) => const TeachersScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.admins.path}',
        name: ViewIdentifiers.admins.name,
        builder: (context, state) => const AdminsScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.students.path}',
        name: ViewIdentifiers.students.name,
        builder: (context, state) => const StudentsScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.groups.path}',
        name: ViewIdentifiers.groups.name,
        builder: (context, state) => const GroupsScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.news.path}',
        name: ViewIdentifiers.news.name,
        builder: (context, state) => const NewsScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.subjects.path}',
        name: ViewIdentifiers.subjects.name,
        builder: (context, state) => const SubjectsScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.adminMain.path}',
        name: ViewIdentifiers.adminMain.name,
        builder: (context, state) => const AdminMainScreen(),
      ),
    ],
  ),
];



