import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../map/presentation/user_home_screen.dart';
import '../../profile/presentation/helper_home_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../history/presentation/history_screen.dart';
import 'package:near_help/l10n/app_localizations.dart';

class MainShell extends ConsumerStatefulWidget {
  final Map<String, dynamic> userProfile;

  const MainShell({super.key, required this.userProfile});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final role = widget.userProfile['role'];
    final isHelper = role == 'helper';
    final l10n = AppLocalizations.of(context)!;

    // Define Screens
    final List<Widget> screens = [
      isHelper ? const HelperHomeScreen() : const UserHomeScreen(),
      const HistoryScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
          elevation: 0,
          backgroundColor: Colors.white,
          destinations: [
            NavigationDestination(
              icon: Icon(isHelper ? Icons.radar : Icons.map_outlined),
              selectedIcon: Icon(isHelper ? Icons.radar : Icons.map),
              label: isHelper ? l10n.jobRadar : "Map",
            ),
            NavigationDestination(
              icon: const Icon(Icons.history_outlined),
              selectedIcon: const Icon(Icons.history),
              label: l10n.myHistory,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: l10n.profile,
            ),
          ],
        ),
      ),
    );
  }
}
