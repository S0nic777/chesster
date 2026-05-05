import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/user_provider.dart';

class NeuralWalletHeader extends ConsumerWidget {
  const NeuralWalletHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return userState.when(
      data: (user) {
        final totalNeurals = user?.totalNeurals ?? 0;
        
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bolt, color: Colors.amberAccent, size: 20)
                .animate(onPlay: (controller) => controller.repeat(reverse: true))
                .scaleXY(begin: 0.8, end: 1.2, duration: 1.seconds)
                .tint(color: Colors.white, duration: 1.seconds, curve: Curves.easeInOut),
              const SizedBox(width: 8),
              Text(
                '$totalNeurals',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.blueAccent, size: 14),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(
        width: 60,
        height: 30,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
