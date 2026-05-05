import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/neural_wallet_header.dart';
import '../providers/user_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final eloRating = userState.value?.eloRating ?? 1200;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'ARENA',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2.0),
        ).animate().fade(duration: 500.ms).slideX(begin: -0.2, end: 0),
        actions: [
          const Center(child: NeuralWalletHeader())
              .animate()
              .fade(duration: 500.ms)
              .slideY(begin: -0.2, end: 0, delay: 200.ms),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF064E3B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ELO Display
                Container(
                  padding: const EdgeInsets.all(48),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.tealAccent.withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                    border: Border.all(color: Colors.tealAccent.withOpacity(0.5), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.tealAccent.withOpacity(0.2),
                        blurRadius: 40,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$eloRating',
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'ELO RATING',
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 3.0,
                          color: Colors.tealAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ).animate(onPlay: (controller) => controller.repeat(reverse: true))
                 .scaleXY(begin: 0.95, end: 1.05, duration: 2.seconds, curve: Curves.easeInOutSine)
                 .boxShadow(begin: BoxShadow(color: Colors.tealAccent.withOpacity(0.1), blurRadius: 20),
                            end: BoxShadow(color: Colors.tealAccent.withOpacity(0.4), blurRadius: 60),
                            duration: 2.seconds),
                const SizedBox(height: 80),
                // Action Button
                ElevatedButton(
                  onPressed: () => context.push('/competitions'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 12,
                    shadowColor: Colors.blueAccent.withOpacity(0.5),
                  ),
                  child: const Text(
                    'VIEW COMPETITIONS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Colors.white,
                    ),
                  ),
                ).animate()
                 .fade(delay: 400.ms, duration: 500.ms)
                 .slideY(begin: 0.5, end: 0)
                 .then(delay: 500.ms)
                 .animate(onPlay: (controller) => controller.repeat(reverse: true))
                 .shimmer(color: Colors.white30, duration: 2.seconds),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
