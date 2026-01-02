import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';
import 'profile_repository.dart';

final userProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authState = ref.watch(authRepositoryProvider).currentUser;
  if (authState == null) return null;

  final profileRepo = ref.watch(profileRepositoryProvider);
  final profile = await profileRepo.getProfile(authState.id);
  
  // Robustness: If profile doesn't exist (trigger error), try creating it from metadata
  if (profile == null && authState.userMetadata != null) {
      final meta = authState.userMetadata!;
      if (meta.containsKey('name')) {
         await profileRepo.createProfile(
           userId: authState.id, 
           name: meta['name'], 
           phone: meta['phone'] ?? '',
         );
         return await profileRepo.getProfile(authState.id);
      }
  }
  
  return profile;
});
