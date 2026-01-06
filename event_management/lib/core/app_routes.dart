import 'package:event_management/features/auth/pages/signup_page.dart';
import 'package:event_management/features/dashboard/views/admin_dashboard.dart';
import 'package:event_management/features/dashboard/views/organizer_dashboard.dart';
import 'package:event_management/features/dashboard/views/profile_view.dart';
import 'package:flutter/material.dart';

import '../features/auth/pages/login_page.dart';
import '../features/dashboard/views/edit_profile_page.dart';
import '../features/dashboard/views/user/user_dashboard.dart';
import '../features/home/home_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String adminDashboard = '/adminDashboard';
  static const String organizerDashboard = '/organizerBoard';
  static const String userDashboard = '/UserDashboard';
  static const String profile = '/profile';
  static const String editProfile = '/editProfile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (_) => const HomePage(title: 'hello'),
        );
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());
      case adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      case organizerDashboard:
        return MaterialPageRoute(builder: (_) => const OrganizerDashboard());
      case userDashboard:
        return MaterialPageRoute(builder: (_) => const UserDashboard());
      case editProfile:
        final args = settings.arguments as Map<String, String>;
        final userId = int.tryParse(args['userId'] ?? '') ?? 0;
        return MaterialPageRoute(
          builder: (_) => EditProfilePage(userId: userId),
        );
      case profile:
        final args = settings.arguments as Map<String, String>;
        final userId = int.tryParse(args['userId'] ?? '') ?? 0;
        return MaterialPageRoute(builder: (_) => ProfileView(userId: userId));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Not Found')),
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
