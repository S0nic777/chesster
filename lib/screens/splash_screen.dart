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
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      // For now, always go to Auth. Logic for 'first time' can be added later via SharedPreferences.
      context.go('/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.grid_4x4_rounded, // Placeholder for actual logo
              size: 100,
              color: Color(0xFF3B82F6),
            ).animate().fadeIn(duration: 800.ms).scale(delay: 200.ms),
            const SizedBox(height: 24),
            const Text(
              'CHESSTER',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                color: Colors.white,
              ),
            ).animate().fadeIn(delay: 500.ms).moveY(begin: 20, end: 0),
          ],
        ),
      ),
    );
  }
}
