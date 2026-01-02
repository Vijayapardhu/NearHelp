import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final requestRepositoryProvider = Provider((ref) => RequestRepository(Supabase.instance.client));

class RequestRepository {
  final SupabaseClient _client;

  RequestRepository(this._client);

  Future<void> createRequest({
    required String userId,
    required String title,
    required String description,
    required double amount,
    required double lat,
    required double lng,
  }) async {
    await _client.from('help_requests').insert({
      'user_id': userId,
      'title': title,
      'description': description,
      'amount': amount,
      'user_lat': lat,
      'user_lng': lng,
      'status': 'pending',
    });
  }

  // Fetch pending requests for helpers
  // In a real app, use PostGIS to filter by distance.
  Future<List<Map<String, dynamic>>> getPendingRequests() async {
    final response = await _client
        .from('help_requests')
        .select('*, profiles:user_id(name, phone, base_trust_score)')
        .eq('status', 'pending')
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> acceptRequest(String requestId, String helperId) async {
    await _client.from('help_requests').update({
      'status': 'accepted',
      'helper_id': helperId,
    }).eq('id', requestId);
  }
    // Fetch active request for User (where status is NOT completed/paid/cancelled)
  Future<Map<String, dynamic>?> getActiveRequestForUser(String userId) async {
    final response = await _client
        .from('help_requests')
        .select('*, profiles:helper_id(name, phone, base_trust_score)')
        .eq('user_id', userId)
        .neq('status', 'completed')
        .neq('status', 'paid')
        .neq('status', 'cancelled')
        .neq('status', 'expired')
        .maybeSingle(); // Returns null if no active request
    return response;
  }

  // Fetch active job for Helper
  Future<Map<String, dynamic>?> getActiveJobForHelper(String helperId) async {
      final response = await _client
        .from('help_requests')
        .select('*, profiles:user_id(name, phone)')
        .eq('helper_id', helperId)
        .neq('status', 'completed')
        .neq('status', 'paid')
        .neq('status', 'cancelled')
        .neq('status', 'expired')
        .maybeSingle();
      return response;
  }

  Future<void> updateStatus(String requestId, String status) async {
    await _client.from('help_requests').update({
      'status': status,
      'updated_at': DateTime.now().toIso8601String(),
    }).eq('id', requestId);
  }
  // History for Helper
  Future<List<Map<String, dynamic>>> getHelperHistory(String? helperId) async {
    if (helperId == null) return [];
    final response = await _client
        .from('help_requests')
        .select('*, profiles:user_id(*)')
        .eq('helper_id', helperId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  // History for User
  Future<List<Map<String, dynamic>>> getUserHistory(String? userId) async {
    if (userId == null) return [];
    final response = await _client
        .from('help_requests')
        .select('*, profiles:helper_id(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }
}
