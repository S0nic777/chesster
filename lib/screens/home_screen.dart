import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/chess_board.dart';
import '../widgets/move_history_bar.dart';
import '../providers/game_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

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
          child: Column(
            children: [
              _buildHeader(ref),
              const MoveHistoryBar(),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPlayerCard('Opponent', 1200, isOpponent: true),
                      const SizedBox(height: 32),
                      ChessBoard(
                        size: MediaQuery.of(context).size.width * 0.95,
                        lightSquareColor: const Color(0xFF334155),
                        darkSquareColor: const Color(0xFF1E293B),
                      ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),
                      const SizedBox(height: 32),
                      _buildPlayerCard('You', 1250, isOpponent: false),
                      
                      if (gameState.isGameOver)
                        Container(
                          margin: const EdgeInsets.only(top: 24),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.blue.withOpacity(0.5)),
                          ),
                          child: Text(
                            'GAME OVER • ${gameState.winner?.toUpperCase()} WINS',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                        ).animate().fadeIn().moveY(begin: 10, end: 0),
                    ],
                  ),
                ),
              ),
              _buildControlBar(ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 20),
            onPressed: () {},
          ),
          const Text(
            'CHESSTER ARENA',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              fontSize: 12,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white70, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(String name, int elo, {required bool isOpponent}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          if (!isOpponent) ...[
            _buildAvatar(isOpponent),
            const SizedBox(width: 12),
          ],
          Column(
            crossAxisAlignment: isOpponent ? CrossAxisAlignment.start : CrossAxisAlignment.start,
            children: [
              Text(
                name.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
              Text(
                '$elo ELO',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),
          if (isOpponent) ...[
            const SizedBox(width: 12),
            _buildAvatar(isOpponent),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isOpponent) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: isOpponent ? Colors.redAccent : Colors.blueAccent, width: 2),
      ),
      child: CircleAvatar(
        radius: 18,
        backgroundColor: Colors.white.withOpacity(0.1),
        child: Icon(
          isOpponent ? Icons.smart_toy_outlined : Icons.person_outline_rounded,
          size: 18,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildControlBar(WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        border: const Border(top: BorderSide(color: Colors.white10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildControlIcon(Icons.flag_outlined, () {}),
          _buildControlIcon(Icons.undo_rounded, () {}),
          _buildControlIcon(Icons.refresh_rounded, () => ref.read(gameProvider.notifier).reset()),
          _buildControlIcon(Icons.chat_bubble_outline_rounded, () {}),
        ],
      ),
    );
  }

  Widget _buildControlIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: Colors.white.withOpacity(0.6), size: 24),
    );
  }
}
