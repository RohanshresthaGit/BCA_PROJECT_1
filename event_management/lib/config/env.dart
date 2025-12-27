import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  /// Load environment from a .env file. Call this during app initialization.
  ///
  /// Example: `await Env.load(fileName: '.env');`
  static Future<void> load({String fileName = '.env'}) async {
    try {
      await dotenv.load(fileName: fileName);
    } catch (e) {
      throw Exception('Failed to load environment file: ${e.toString()}');
    }
  }

  /// API base URL (`API_BASE_URL` in .env). Falls back to a sensible default.
  static String get apiBaseUrl => dotenv.get('API_BASE_URL', fallback: 'https://api.example.com');

  /// Additional env getters can be added here.
}
