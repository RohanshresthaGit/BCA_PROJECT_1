import 'package:flutter/material.dart';

import '../../../core/extensions/build_context_extension.dart';

class OrganizerDashboard extends StatelessWidget {
  const OrganizerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Organizer')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Organizer Dashboard'),
            ElevatedButton(
              onPressed: () => context.goToHome(),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
