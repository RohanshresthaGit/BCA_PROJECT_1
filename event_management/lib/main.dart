import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:device_preview/device_preview.dart';
import 'package:event_management/config/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/localization/l10n/app_localizations.dart';
import 'config/localization/language_provider.dart';
import 'core/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: DevicePreview(builder: (context) => MyApp())));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        final locale =
            ref.watch(languageProvider).asData?.value ?? const Locale('en');
        final theme = ref.watch(themeProvider).asData?.value ?? true;

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Evento',
          theme: (theme) ? ThemeData.light() : ThemeData.dark(),
          locale: locale,
          navigatorObservers: [ChuckerFlutter.navigatorObserver],
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
