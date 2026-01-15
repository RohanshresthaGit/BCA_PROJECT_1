import 'package:event_management/config/storage/shared_prefs_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/env.dart';
import '../../config/network/dio_client.dart';
import '../../core/extensions/context_extensions.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    _init();
    // WidgetsBinding.instance.addPostFrameCallback((_) => navigate());
  }

  Future<void> _init() async {
    await Env.load(fileName: '.env');
    await SharedPrefsService.instance.init();

    DioClient().init(
      baseUrl: Env.apiBaseUrl,
      tokenGetter: () async => SharedPrefsService.instance.getToken(),
    );

    _navigate();
  }

  void _navigate() {
    final token = SharedPrefsService.instance.getToken();

    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      Navigator.pushReplacementNamed(context, '/dashboard');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation<Color>(
            context.theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
