import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';
import 'request_repository.dart';

// Polling for active request (Supabase Realtime is better, but polling is simpler for MVP/No cost edge cases)
final activeRequestProvider = StreamProvider.autoDispose<Map<String, dynamic>?>((ref) async* {
  final repo = ref.watch(requestRepositoryProvider);
  final userId = ref.watch(authRepositoryProvider).currentUser?.id;
  
  if (userId == null) yield null;

  // Poll every 5 seconds
  while (true) {
    if (userId != null) {
      final req = await repo.getActiveRequestForUser(userId);
      yield req;
    }
    await Future.delayed(const Duration(seconds: 5));
  }
});

final activeJobForHelperProvider = StreamProvider.autoDispose<Map<String, dynamic>?>((ref) async* {
  final repo = ref.watch(requestRepositoryProvider);
  final userId = ref.watch(authRepositoryProvider).currentUser?.id;
  
  if (userId == null) yield null;

  while (true) {
    if (userId != null) {
      final req = await repo.getActiveJobForHelper(userId);
      yield req;
    }
    await Future.delayed(const Duration(seconds: 5));
  }
});
