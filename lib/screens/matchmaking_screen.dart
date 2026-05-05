import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';

class MatchmakingScreen extends ConsumerStatefulWidget {
  const MatchmakingScreen({super.key});

  @override
  ConsumerState<MatchmakingScreen> createState() => _MatchmakingScreenState();
}

class _MatchmakingScreenState extends ConsumerState<MatchmakingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _secondsPassed = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _secondsPassed++;
        });
        if (_secondsPassed >= 30) {
          timer.cancel();
          context.push('/tiebreaker'); 
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String get _currentPhaseText {
    if (_secondsPassed <= 10) return "Phase 1: Searching ± 50 ELO";
    if (_secondsPassed <= 20) return "Phase 2: Expanding ± 100 ELO";
    return "Phase 3: Expanding ± 200 ELO";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: const Color(0xFF0F172A),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: 200 + (_controller.value * 50),
                      height: 200 + (_controller.value * 50),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blueAccent.withOpacity(0.1 + (_controller.value * 0.1)),
                        border: Border.all(
                          color: Colors.blueAccent.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.radar, color: Colors.blueAccent, size: 80),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 64),
                const Text(
                  'FINDING OPPONENT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4.0,
                  ),
                ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                 .shimmer(duration: 1.seconds, color: Colors.blueAccent.withOpacity(0.5))
                 .shake(),
                const SizedBox(height: 16),
                Text(
                  _currentPhaseText,
                  key: ValueKey(_currentPhaseText),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                    letterSpacing: 1.5,
                  ),
                ).animate()
                 .fade(duration: 300.ms)
                 .slideY(begin: 0.2, end: 0),
                const SizedBox(height: 8),
                Text(
                  '00:${_secondsPassed.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 64),
                TextButton(
                  onPressed: () {
                    context.pop();
                  },
                  child: const Text('CANCEL', style: TextStyle(color: Colors.redAccent, letterSpacing: 2.0)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
