import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../map/presentation/user_home_screen.dart';
import '../../profile/presentation/helper_home_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../history/presentation/history_screen.dart';
import 'package:near_help/l10n/app_localizations.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

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
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.white,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.blue.shade600,
              color: Colors.black,
              tabs: [
                GButton(
                  icon: isHelper ? Icons.radar : Icons.map_outlined,
                  text: isHelper ? l10n.jobRadar : "Map",
                ),
                GButton(
                  icon: Icons.history,
                  text: l10n.myHistory,
                ),
                GButton(
                  icon: Icons.person,
                  text: l10n.profile,
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
