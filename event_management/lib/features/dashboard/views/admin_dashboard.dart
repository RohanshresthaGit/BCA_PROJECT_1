import 'package:flutter/material.dart';

import '../../../core/extensions/build_context_extension.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Admin Dashboard'),
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
