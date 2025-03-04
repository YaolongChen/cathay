import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../ui/screen/home/home_screen.dart';
import '../ui/screen/login/login_screen.dart';
import 'routes.dart';

final router = GoRouter(
  initialLocation: Routes.home,
  debugLogDiagnostics: true,
  redirect: _redirect,
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) {
        return HomeScreen();
      },
    ),
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return LoginScreen();
      },
    ),
  ],
);

FutureOr<String?> _redirect(BuildContext context, GoRouterState state) {
  return null;
}