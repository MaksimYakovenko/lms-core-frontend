import 'package:go_router/go_router.dart';
import 'package:lms_core_frontend/config/routers/view_identifiers.dart';
import 'package:lms_core_frontend/features/admins/admins_screen.dart';
import 'package:lms_core_frontend/features/appointment/appointment_screen.dart';
import 'package:lms_core_frontend/features/auth/login_screen.dart';
import 'package:lms_core_frontend/features/auth/registry_screen.dart';
import 'package:lms_core_frontend/features/classrooms/classrooms_screen.dart';
import 'package:lms_core_frontend/features/dashboard/dashboard_screen.dart';
import 'package:lms_core_frontend/features/groups/groups_screen.dart';
import 'package:lms_core_frontend/features/journals/journals/journals_screen.dart';
import 'package:lms_core_frontend/features/journals/journal_details/journal_details_screen.dart';
import 'package:lms_core_frontend/features/news/news_screen.dart';
import 'package:lms_core_frontend/features/student_home/student_home_screen.dart';
import 'package:lms_core_frontend/features/students/students_screen.dart';
import 'package:lms_core_frontend/features/subjects/subjects_screen.dart';
import 'package:lms_core_frontend/features/teacher_journals/teacher_journal_screen.dart';
import 'package:lms_core_frontend/features/teachers/teachers_screen.dart';
import 'package:lms_core_frontend/features/tests/tests_screen.dart';
import '../../features/admin_main/main_screen.dart';
import '../../features/teacher_main/teacher_main_screen.dart';

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
      GoRoute(
        path: '/${ViewIdentifiers.studentHome.path}',
        name: ViewIdentifiers.studentHome.name,
        builder: (context, state) => const StudentHomeScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.tests.path}',
        name: ViewIdentifiers.tests.name,
        builder: (context, state) => const TestsScreen(),
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
      GoRoute(
        path: '/${ViewIdentifiers.journals.path}',
        name: ViewIdentifiers.journals.name,
        builder: (context, state) => const JournalsScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.journalDetails.path}',
        name: ViewIdentifiers.journalDetails.name,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return JournalDetailsScreen(journalId: id);
        },
      ),
      GoRoute(
        path: '/${ViewIdentifiers.appointment.path}',
        name: ViewIdentifiers.appointment.name,
        builder: (context, state) => const AppointmentScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.classrooms.path}',
        name: ViewIdentifiers.classrooms.name,
        builder: (context, state) => const ClassroomsScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.teacherHome.path}',
        name: ViewIdentifiers.teacherHome.name,
        builder: (context, state) => const TeacherMainScreen(),
      ),
      GoRoute(
        path: '/${ViewIdentifiers.teacherJournal.path}',
        name: ViewIdentifiers.teacherJournal.name,
        builder: (context, state) => const TeacherJournalScreen(),
      )
    ],
  ),
];
