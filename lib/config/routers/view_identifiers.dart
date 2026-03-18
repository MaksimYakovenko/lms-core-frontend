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
}
