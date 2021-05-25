import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/export_screens.dart';
part 'routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Route.SPLASH,
      page: () => SplashScreen(),
      settings: const RouteSettings(name: Routes.SPLASH),
    ),
    GetPage(
      name: _Route.AUTH,
      page: () => AuthScreen(),
      settings: const RouteSettings(name: Routes.AUTH),
    ),
    GetPage(
      name: _Route.HOME,
      page: () => HomeScreen(),
      settings: const RouteSettings(name: Routes.HOME),
    ),
  ];
}
