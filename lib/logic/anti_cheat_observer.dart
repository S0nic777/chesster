import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class AntiCheatNotifier extends Notifier<int> with WidgetsBindingObserver {
  Timer? _backgroundTimer;
  bool _isMatchActive = false;
  int _strikes = 0;

  @override
  int build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _backgroundTimer?.cancel();
    });
    return 0;
  }

  void startMatchMonitoring() {
    _isMatchActive = true;
    _strikes = 0;
    state = _strikes;
  }

  void stopMatchMonitoring() {
    _isMatchActive = false;
    _backgroundTimer?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    super.didChangeAppLifecycleState(appState);

    if (!_isMatchActive) return;

    if (appState == AppLifecycleState.paused || appState == AppLifecycleState.inactive) {
      _backgroundTimer = Timer(const Duration(seconds: 3), () {
        _issueStrike();
      });
    } else if (appState == AppLifecycleState.resumed) {
      _backgroundTimer?.cancel();
    }
  }

  void _issueStrike() {
    _strikes++;
    state = _strikes;
    if (_strikes >= 2) {
      _triggerForfeit();
    }
  }

  void _triggerForfeit() {
    debugPrint("MATCH FORFEITED DUE TO ANTI-CHEAT");
  }
}

final antiCheatProvider = NotifierProvider<AntiCheatNotifier, int>(() {
  return AntiCheatNotifier();
});
