import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mapRepositoryProvider = Provider((ref) => MapRepository(Supabase.instance.client));

class MapRepository {
  final SupabaseClient _client;

  MapRepository(this._client);

  // Fetch verified helpers who are not blocked.
  // In a real app, this would use PostGIS for "Nearby".
  // MVP: Fetch all helpers and filter client-side or just show all for demo.
  Future<List<Map<String, dynamic>>> getNearbyHelpers() async {
     final response = await _client
        .from('profiles')
        .select()
        .eq('role', 'helper')
        .eq('is_verified', true);
        
     return List<Map<String, dynamic>>.from(response);
  }
}
