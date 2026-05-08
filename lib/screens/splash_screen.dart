import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2500, milliseconds: 0));
    if (mounted) {
      context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0F172A)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(color: Colors.white12),
                ),
                child: const Icon(
                  Icons.auto_awesome_motion_rounded,
                  size: 80,
                  color: Color(0xFF60A5FA),
                ),
              ).animate()
                .fadeIn(duration: 1.seconds)
                .scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut)
                .shimmer(delay: 2.seconds, duration: 2.seconds),
              const SizedBox(height: 32),
              const Text(
                'CHESSTER',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 8,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.blueAccent, blurRadius: 20),
                  ],
                ),
              ).animate().fadeIn(delay: 500.ms).moveY(begin: 30, end: 0),
              const SizedBox(height: 8),
              Text(
                'NEURAL STRATEGY ARENA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 4,
                  color: Colors.white.withOpacity(0.5),
                ),
              ).animate().fadeIn(delay: 1200.ms),
            ],
          ),
        ),
      ),
    );
  }
}
