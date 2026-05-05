import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TieBreakerState {
  initial,
  awaitingFee,
  suddenDeathPaygate,
  armageddonBidding,
  resolved
}

class TieBreakerData {
  final String compId;
  final String opponentId;
  final int tbFee;
  final bool isByeRound;

  TieBreakerData({
    required this.compId,
    required this.opponentId,
    required this.tbFee,
    this.isByeRound = false,
  });
}

class TieBreakerNotifier extends Notifier<TieBreakerState> {
  TieBreakerData? data;

  @override
  TieBreakerState build() {
    return TieBreakerState.initial;
  }

  void initiateTieBreaker(TieBreakerData tbData) {
    data = tbData;
    if (data!.isByeRound) {
      state = TieBreakerState.awaitingFee; 
    } else {
      state = TieBreakerState.awaitingFee;
    }
  }

  Future<bool> payPhase1Fee(Future<bool> Function(int) chargeUser) async {
    if (state != TieBreakerState.awaitingFee || data == null) return false;
    
    bool success = await chargeUser(data!.tbFee);
    if (success) {
      if (data!.isByeRound) {
        state = TieBreakerState.resolved;
      }
      return true;
    }
    return false;
  }

  void triggerPhase1Draw() {
    if (state == TieBreakerState.awaitingFee) {
      state = TieBreakerState.suddenDeathPaygate;
    }
  }

  Future<bool> payPhase2Fee(Future<bool> Function(int) chargeUser) async {
    if (state != TieBreakerState.suddenDeathPaygate || data == null) return false;
    
    bool success = await chargeUser(data!.tbFee);
    if (success) {
      state = TieBreakerState.armageddonBidding;
      return true;
    }
    return false;
  }

  void triggerArmageddonBidComplete() {
    if (state == TieBreakerState.armageddonBidding) {
      state = TieBreakerState.resolved;
    }
  }
}

final tieBreakerProvider = NotifierProvider<TieBreakerNotifier, TieBreakerState>(() {
  return TieBreakerNotifier();
});
