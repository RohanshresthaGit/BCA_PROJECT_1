import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/themes/theme_provider.dart';
import '../../config/localization/language_provider.dart';
import '../../core/extensions/build_context_extension.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            Text(context.l10n.helloWorld),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 40),
            Consumer(
              builder: (context, ref, child) {
                return Wrap(
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
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.goToLogin();
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Login'),
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
