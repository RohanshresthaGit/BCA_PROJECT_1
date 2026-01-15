import 'package:event_management/features/auth/pages/signup_page.dart';
import 'package:event_management/features/dashboard/views/admin_dashboard.dart';
import 'package:event_management/features/dashboard/views/organizer_dashboard.dart';
import 'package:event_management/features/dashboard/views/profile_view.dart';
import 'package:event_management/features/events/models/event_model.dart';
import 'package:event_management/features/events/views/create_event_view.dart';
import 'package:event_management/features/events/views/event_details_view.dart';
import 'package:flutter/material.dart';

import '../features/auth/pages/login_page.dart';
import '../features/dashboard/views/edit_profile_page.dart';
import '../features/dashboard/views/user/user_dashboard.dart';
import '../features/events/views/edit_event_view.dart';
import '../features/home/home_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String adminDashboard = '/adminDashboard';
  static const String organizerDashboard = '/organizerBoard';
  static const String userDashboard = '/dashboard';
  static const String profile = '/profile';
  static const String editProfile = '/editProfile';
  static const String eventDetailsScreen = '/eventDetailsScreen';
  static const String createEventScreen = '/createEventScreen';
  static const String editEvent = '/editEvent';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
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
      case editEvent:
        final args = settings.arguments as Map<String, dynamic>;
        final event = args['event'] as EventModel;
        return MaterialPageRoute(builder: (_) => UpdateEventPage(event: event));
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
      case eventDetailsScreen:
        final args = settings.arguments as Map<String, dynamic>;
        final event = args['event'] as EventModel;
        final role = args['role'] as String;
        final userId = args['userId'] as int;
        return MaterialPageRoute(
          builder: (_) => EventDetailScreen(event: event, role: role, userId: userId  ),
        );
      case createEventScreen:
        return MaterialPageRoute(builder: (_) => CreateEventPage());
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
