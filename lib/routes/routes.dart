part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Route.SPLASH;
  static const AUTH = _Route.AUTH;
  static const HOME = _Route.HOME;
}

abstract class _Route {
  static const SPLASH = '/splash';
  static const AUTH = '/auth';
  static const HOME = '/home';
}
