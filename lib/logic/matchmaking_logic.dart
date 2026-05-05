import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

final matchmakingProvider = Provider<MatchmakingLogic>((ref) {
  return MatchmakingLogic(Supabase.instance.client);
});

class MatchmakingLogic {
  final SupabaseClient _supabase;

  MatchmakingLogic(this._supabase);

  Future<String?> findMatch(int userElo) async {
    bool matchFound = false;
    String? matchId;

    // Simulate 3-phase matchmaking expansion
    for (int i = 0; i < 30; i++) {
      if (matchFound) break;

      int bounds = 50;
      if (i >= 10) bounds = 100;
      if (i >= 20) bounds = 200;

      try {
        // We simulate a backend function `find_global_match` that takes elo_bounds
        // and returns a match UUID if successful, or null.
        final response = await _supabase.rpc('find_global_match', params: {
          'p_user_elo': userElo,
          'p_elo_bounds': bounds
        });

        if (response != null && response is String && response.isNotEmpty) {
          matchFound = true;
          matchId = response;
        }
      } catch (e) {
        // log or ignore timeout
      }

      if (!matchFound) {
        await Future.delayed(const Duration(seconds: 1));
      }
    }

    return matchId;
  }
}
