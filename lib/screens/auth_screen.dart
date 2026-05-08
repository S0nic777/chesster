import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.auto_awesome_motion_rounded, size: 64, color: Color(0xFF60A5FA))
                    .animate().fadeIn().scale(),
                const SizedBox(height: 24),
                const Text(
                  'Welcome to\nChesster',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),
                const SizedBox(height: 12),
                Text(
                  'The world\'s first neural-powered chess arena.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 64),
                _buildButton(
                  label: 'SIGN IN / REGISTER',
                  onPressed: () => context.go('/home'),
                  isPrimary: true,
                ).animate().fadeIn(delay: 600.ms),
                const SizedBox(height: 16),
                _buildButton(
                  label: 'PLAY OFFLINE',
                  onPressed: () => context.go('/bot-selection'),
                  isPrimary: false,
                ).animate().fadeIn(delay: 800.ms),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(height: 1, width: 40, color: Colors.white10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('OR', style: TextStyle(color: Colors.white24, fontSize: 10)),
                    ),
                    Container(height: 1, width: 40, color: Colors.white10),
                  ],
                ).animate().fadeIn(delay: 1.seconds),
                const SizedBox(height: 32),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'CONTINUE AS GUEST',
                    style: TextStyle(color: Colors.white.withOpacity(0.4), letterSpacing: 2, fontSize: 12),
                  ),
                ).animate().fadeIn(delay: 1200.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required String label, required VoidCallback onPressed, required bool isPrimary}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: isPrimary ? [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ] : null,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? const Color(0xFF3B82F6) : Colors.white.withOpacity(0.05),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isPrimary ? BorderSide.none : const BorderSide(color: Colors.white10),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
      ),
    );
  }
}
