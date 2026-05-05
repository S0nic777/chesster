import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import '../logic/tie_breaker_state_machine.dart';

class TieBreakerScreen extends ConsumerStatefulWidget {
  const TieBreakerScreen({super.key});

  @override
  ConsumerState<TieBreakerScreen> createState() => _TieBreakerScreenState();
}

class _TieBreakerScreenState extends ConsumerState<TieBreakerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tieBreakerProvider.notifier).initiateTieBreaker(
        TieBreakerData(compId: 'demo', opponentId: 'opp1', tbFee: 300)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tbState = ref.watch(tieBreakerProvider);

    Widget content = const SizedBox.shrink();
    switch (tbState) {
      case TieBreakerState.initial:
        content = const Center(child: CircularProgressIndicator());
        break;
      case TieBreakerState.awaitingFee:
        content = _buildPhase1UI();
        break;
      case TieBreakerState.suddenDeathPaygate:
        content = const _PaygateTimerView();
        break;
      case TieBreakerState.armageddonBidding:
        content = _buildPhase3ArmageddonUI();
        break;
      case TieBreakerState.resolved:
        content = const Center(
          child: Text('MATCH RESOLVED', style: TextStyle(color: Colors.tealAccent, fontSize: 32, fontWeight: FontWeight.bold)),
        );
        break;
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(child: content),
    );
  }

  Widget _buildPhase1UI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 80),
            const SizedBox(height: 24),
            const Text(
              'TIE-BREAKER SHOWDOWN',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'You have tied for 1st place! Pay the 50% Tie-Breaker fee to enter the Rapid Chess showdown.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                ref.read(tieBreakerProvider.notifier).triggerPhase1Draw();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
              child: const Text('PAY 300 NEURALS', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhase3ArmageddonUI() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.gavel, color: Colors.redAccent, size: 80),
            const SizedBox(height: 24),
            const Text(
              'ARMAGEDDON BIDDING',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bid your time for the Black pieces.\\nBase time: 5:00.\\nLowest bid wins Black (Draw odds).',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBidButton('4:30'),
                const SizedBox(width: 16),
                _buildBidButton('4:00'),
                const SizedBox(width: 16),
                _buildBidButton('3:30'),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(tieBreakerProvider.notifier).triggerArmageddonBidComplete();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
              child: const Text('SUBMIT CUSTOM BID', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBidButton(String time) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white54),
      ),
      child: Text(time),
    );
  }
}

class _PaygateTimerView extends ConsumerStatefulWidget {
  const _PaygateTimerView();

  @override
  ConsumerState<_PaygateTimerView> createState() => _PaygateTimerViewState();
}

class _PaygateTimerViewState extends ConsumerState<_PaygateTimerView> {
  int _secondsLeft = 600;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _secondsLeft > 0) {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_secondsLeft / 60).floor().toString().padLeft(2, '0');
    final seconds = (_secondsLeft % 60).toString().padLeft(2, '0');

    return Container(
      width: double.infinity,
      color: Colors.redAccent.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_clock, color: Colors.redAccent, size: 80)
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scaleXY(begin: 1.0, end: 1.2, duration: 500.ms)
              .shake(duration: 500.ms),
          const SizedBox(height: 24),
          const Text(
            'SUDDEN DEATH PAYGATE',
            style: TextStyle(color: Colors.redAccent, fontSize: 24, fontWeight: FontWeight.w900),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .shimmer(color: Colors.white, duration: 1.seconds),
          const SizedBox(height: 16),
          Text(
            '$minutes:$seconds',
            style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .tint(color: Colors.redAccent, duration: 500.ms),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'Phase 1 Rapid Match ended in a draw. Pay the second fee to enter Armageddon, or forfeit the match.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              ref.read(tieBreakerProvider.notifier).payPhase2Fee((fee) async => true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            ),
            child: const Text('PAY 300 NEURALS NOW', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ).animate(onPlay: (controller) => controller.repeat(reverse: true))
           .scaleXY(begin: 1.0, end: 1.05, duration: 400.ms),
        ],
      ),
    );
  }
}
