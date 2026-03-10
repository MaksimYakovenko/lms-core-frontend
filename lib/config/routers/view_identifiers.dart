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
}
