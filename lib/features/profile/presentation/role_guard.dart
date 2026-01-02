import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../map/presentation/user_home_screen.dart';
import '../../profile/presentation/helper_home_screen.dart';
import '../data/profile_controller.dart';
import '../../home/presentation/main_shell.dart';

class RoleGuard extends ConsumerWidget {
  const RoleGuard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null) {
          return const Scaffold(body: Center(child: Text("Error loading profile")));
        }
        
        final role = profile['role'];
        switch (role) {
          case 'user':
          case 'helper':
            return MainShell(userProfile: profile);
          case 'admin':
          case 'supervisor':
            return const Scaffold(body: Center(child: Text("Admin Dashboard")));
          default:
            return const Scaffold(body: Center(child: Text("Unknown Role")));
        }
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
    );
  }
}
