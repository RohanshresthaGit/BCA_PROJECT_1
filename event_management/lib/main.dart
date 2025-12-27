import 'package:device_preview/device_preview.dart';
import 'package:event_management/config/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/env.dart';
import 'config/localization/l10n/app_localizations.dart';
import 'config/localization/language_provider.dart';
import 'core/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.load(fileName: '.env');
  // Print for quick debug; remove in production
  print(Env.apiBaseUrl);

  runApp( ProviderScope(child: DevicePreview(builder:(context) =>  MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final locale = ref.watch(languageProvider);
        final theme = ref.watch(themeProvider);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Localized App',
          theme: theme ? ThemeData.light() : ThemeData.dark(),
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate, // Custom generated localization
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('ne'), // Nepali
          ],
          initialRoute: AppRoutes.home,
          onGenerateRoute: AppRoutes.generateRoute,
        );
      },
    );
  }
}
