import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:near_help/features/profile/data/profile_repository.dart';
import 'package:near_help/features/profile/data/profile_controller.dart';

class RoleSwitchScreen extends ConsumerStatefulWidget {
  final String targetRole;
  final String userId;

  const RoleSwitchScreen({super.key, required this.targetRole, required this.userId});

  @override
  ConsumerState<RoleSwitchScreen> createState() => _RoleSwitchScreenState();
}

class _RoleSwitchScreenState extends ConsumerState<RoleSwitchScreen> {
  @override
  void initState() {
    super.initState();
    _executeSwitch();
  }

  Future<void> _executeSwitch() async {
    // Artificial delay for animation
    await Future.delayed(const Duration(seconds: 2));

    try {
      // 1. Update in DB
      await ref.read(profileRepositoryProvider).updateRole(widget.userId, widget.targetRole);
      
      // 2. Refresh Provider
      ref.invalidate(userProfileProvider);
      
      // 3. Wait for data refresh
      // We wait a bit more to ensure the provider rebuilds
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        // 4. Restart App (Go to root)
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to switch role: $e")));
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHelper = widget.targetRole == 'helper';
    
    return Scaffold(
      backgroundColor: isHelper ? Colors.blue.shade50 : Colors.green.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Transformation
            ZoomIn(
              duration: const Duration(seconds: 1),
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 10))
                  ],
                ),
                child: Icon(
                  isHelper ? Icons.radar : Icons.map_outlined,
                  size: 80,
                  color: isHelper ? Colors.blue : Colors.green,
                ),
              ),
            ),
            const SizedBox(height: 40),
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: Text(
                "Switching to ${isHelper ? 'Helper' : 'User'} Mode...",
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            FadeInUp(
              delay: const Duration(milliseconds: 800),
              child: const SizedBox(
                width: 200,
                child: LinearProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
