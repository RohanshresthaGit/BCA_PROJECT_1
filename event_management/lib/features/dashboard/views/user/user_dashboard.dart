import 'package:event_management/config/storage/shared_prefs_service.dart';
import 'package:event_management/features/dashboard/views/profile_view.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/build_context_extension.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  late final ValueNotifier<int> _selectedIndex;
  late int userId;
  @override
  void initState() {
    super.initState();
    _selectedIndex = ValueNotifier<int>(0);
    userId = SharedPrefsService.instance.getUserId() ?? 0;
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      Center(child: Text(context.l10n.home)),
      Center(child: Text(context.l10n.search)),
      ProfileView(userId: userId),
    ];
    return Scaffold(
      // appBar: AppBar(title: const Text('User')),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: (context, value, child) {
          return BottomNavigationBar(
            
            selectedFontSize: 18,
            iconSize: 20,
            selectedIconTheme: IconThemeData(size: 24),
            showUnselectedLabels: false,
            currentIndex: _selectedIndex.value,
            onTap: (index) {
              _selectedIndex.value = index;
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: context.l10n.dashboard,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: context.l10n.search,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: context.l10n.profile,
              ),
            ],
          );
        },
      ),
      body: ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: (context, value, child) {
          return screens[value];
        },
      ),
    );
  }
}
