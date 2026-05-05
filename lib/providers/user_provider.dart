import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import 'dart:async';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

class UserNotifier extends AsyncNotifier<UserModel?> {
  @override
  FutureOr<UserModel?> build() async {
    return UserModel(
      id: 'demo123',
      username: 'DemoUser',
      walletEarned: 1000,
      walletPurchased: 500,
      eloRating: 1200,
      isPremium: true,
      isSuspicious: false,
      gamesPlayed: 5,
    );
  }

  Future<bool> deductNeurals(int amount) async {
    final currentUser = state.value;
    if (currentUser == null) return false;
    if (currentUser.totalNeurals < amount) return false;

    int newEarned = currentUser.walletEarned;
    int newPurchased = currentUser.walletPurchased;
    int remainingToDeduct = amount;

    if (newEarned >= remainingToDeduct) {
      newEarned -= remainingToDeduct;
      remainingToDeduct = 0;
    } else {
      remainingToDeduct -= newEarned;
      newEarned = 0;
      newPurchased -= remainingToDeduct;
    }

    state = AsyncData(currentUser.copyWith(
      walletEarned: newEarned,
      walletPurchased: newPurchased,
    ));
    return true;
  }

  Future<void> addEarnedNeurals(int amount) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    int newEarned = currentUser.walletEarned + amount;
    if (newEarned > currentUser.maxEarnedCap) {
      newEarned = currentUser.maxEarnedCap;
    }

    state = AsyncData(currentUser.copyWith(
      walletEarned: newEarned,
    ));
  }

  Future<void> addPurchasedNeurals(int amount) async {
    final currentUser = state.value;
    if (currentUser == null) return;

    int newPurchased = currentUser.walletPurchased + amount;

    state = AsyncData(currentUser.copyWith(
      walletPurchased: newPurchased,
    ));
  }
}

final userProvider = AsyncNotifierProvider<UserNotifier, UserModel?>(() {
  return UserNotifier();
});
