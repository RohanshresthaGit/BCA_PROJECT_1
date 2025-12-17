import 'package:event_management/config/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/localization/l10n/app_localizations.dart';
import 'config/localization/language_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);

    return Consumer(
      builder: (context, ref, child) {
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
          home: const MyHomePage(title: "hello"),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(appLocalizations.helloWorld),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 40),
            Consumer(
              builder: (context, ref, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(themeProvider.notifier).switchMode(false);
                      },
                      icon: const Icon(Icons.language),
                      label: const Text('Dark'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.read(themeProvider.notifier).switchMode(true);
                      },
                      icon: const Icon(Icons.language),
                      label: const Text('light'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref
                            .read(languageProvider.notifier)
                            .changeLanguage('en');
                      },
                      icon: const Icon(Icons.language),
                      label: const Text('English'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref
                            .read(languageProvider.notifier)
                            .changeLanguage('ne');
                      },
                      icon: const Icon(Icons.language),
                      label: const Text('Nepali'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
