class RouteDescriptor {
  const RouteDescriptor(
      this.name, {
        String? path,
      }) : path = path ?? name;

  final String name;
  final String path;
}

class ViewIdentifiers {
  const ViewIdentifiers._();

//------------------------------ MODULE DASHBOARD ----------------------------//
// ----------------------------------- HOME ----------------------------------//
  static RouteDescriptor home = const RouteDescriptor('home', path: '/');

// ---------------------------------- AUTH -----------------------------------//
  static RouteDescriptor login = const RouteDescriptor('login', path: 'login');
  static RouteDescriptor registry =
      const RouteDescriptor('registry', path: 'registry');

// --------------------------------- STUDENT ---------------------------------//
  static RouteDescriptor studentHome =
      const RouteDescriptor('student-home', path: 'dashboard');
  static RouteDescriptor results =
      const RouteDescriptor('results', path: 'results');
  static RouteDescriptor tests =
      const RouteDescriptor('tests', path: 'tests');
  static RouteDescriptor resources =
      const RouteDescriptor('resources', path: 'resources');
  static RouteDescriptor payment =
      const RouteDescriptor('payment', path: 'payment');

// --------------------------------- TEACHER ---------------------------------//
  static RouteDescriptor teacherHome =
      const RouteDescriptor('teacher-home', path: 'teacher-home');
  static RouteDescriptor teacherJournal =
      const RouteDescriptor('teacher-journal', path: 'teacher-journal');

// --------------------------------- ADMIN -----------------------------------//
  static RouteDescriptor teachers =
      const RouteDescriptor('teachers', path: 'teachers');
  static RouteDescriptor admins =
      const RouteDescriptor('admins', path: 'admins');
  static RouteDescriptor students =
      const RouteDescriptor('students', path: 'students');
  static RouteDescriptor groups =
      const RouteDescriptor('groups', path: 'groups');
  static RouteDescriptor news =
      const RouteDescriptor('news', path: 'news');
  static RouteDescriptor subjects =
      const RouteDescriptor('subjects', path: 'subjects');
  static RouteDescriptor adminMain =
      const RouteDescriptor('admin-admin_main', path: 'admin-admin_main');
  static RouteDescriptor journals =
      const RouteDescriptor('journals', path: 'journals');
  static RouteDescriptor journalDetails =
      const RouteDescriptor('journal-details', path: 'journals/:id');
  static RouteDescriptor teacherQuickAdd =
      const RouteDescriptor('teacher-quick-add', path: 'teacher-quick-add');
  static RouteDescriptor groupQuickAdd =
      const RouteDescriptor('group-quick-add', path: 'group-quick-add');
  static RouteDescriptor subjectQuickAdd =
      const RouteDescriptor('subject-quick-add', path: 'subject-quick-add');
  static RouteDescriptor appointment =
      const RouteDescriptor('appointment', path: 'appointment');
  static RouteDescriptor classrooms =
      const RouteDescriptor('classrooms', path: 'classrooms');
}
