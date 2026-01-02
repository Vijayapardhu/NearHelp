import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/data/auth_repository.dart';
import '../data/request_repository.dart';

final requestControllerProvider = StateNotifierProvider<RequestController, AsyncValue<void>>((ref) {
  final repo = ref.watch(requestRepositoryProvider);
  final userId = ref.watch(authRepositoryProvider).currentUser?.id;
  return RequestController(repo, userId);
});

class RequestController extends StateNotifier<AsyncValue<void>> {
  final RequestRepository _repo;
  final String? _userId;

  RequestController(this._repo, this._userId) : super(const AsyncData(null));

  Future<void> createRequest({
    required String title,
    required String description,
    required double amount,
    required double lat,
    required double lng,
  }) async {
    if (_userId == null) return;
    
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.createRequest(
      userId: _userId!,
      title: title,
      description: description,
      amount: amount,
      lat: lat,
      lng: lng,
    ));
  }
  
  Future<void> acceptRequest(String requestId) async {
    if (_userId == null) return;
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.acceptRequest(requestId, _userId!));
  }

  Future<void> updateRequestStatus(String requestId, String status) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _repo.updateStatus(requestId, status));
  }
}
