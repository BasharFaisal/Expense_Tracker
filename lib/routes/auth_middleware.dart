import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';
import 'app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final storage = StorageService.instance;

    // If not logged in, redirect to login
    if (!storage.isLoggedIn) {
      return const RouteSettings(name: AppRoutes.login);
    }

    // If route targets admin area (convention: routes starting with '/admin')
    // only allow users with role 'Admin'. Otherwise redirect to dashboard.
    if (route != null && route.startsWith('/admin')) {
      final role = storage.role ?? 'User';
      if (role.toLowerCase() != 'admin') {
        return const RouteSettings(name: AppRoutes.dashboard);
      }
    }

    return null;
  }
}
