import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import '../../auth/presentation/login_screen.dart';

class ProfilePhotoScreen extends ConsumerStatefulWidget {
  const ProfilePhotoScreen({super.key});

  @override
  ConsumerState<ProfilePhotoScreen> createState() => _ProfilePhotoScreenState();
}

class _ProfilePhotoScreenState extends ConsumerState<ProfilePhotoScreen> {
  bool _isUploading = false;

  void _skip() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  Future<void> _uploadPhoto() async {
    setState(() => _isUploading = true);
    // Simulate upload delay
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _isUploading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo Uploaded (Simulated)!')),
      );
      _skip(); // Go to login after upload
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.white, Colors.green.shade50],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeInDown(
                child: Column(
                  children: [
                    Text("Add a Profile Photo", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Text("Help others recognize you!", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey[600])),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              
              FadeIn(
                delay: const Duration(milliseconds: 300),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey[200],
                      child: Icon(Icons.person, size: 80, color: Colors.grey[400]),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: _uploadPhoto,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 60),
              
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: _isUploading ? null : _uploadPhoto,
                      child: _isUploading 
                         ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white)) 
                         : const Text("Upload Photo"),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _skip,
                      child: const Text("Skip for now", style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
