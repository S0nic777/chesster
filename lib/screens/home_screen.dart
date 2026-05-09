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

    // Show promotion dialog if needed
    if (gameState.pendingPromotionFrom != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showPromotionDialog(context, ref, gameState.isWhiteTurn);
      });
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF161512), // Classic Chess.com background
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(ref),
              const MoveHistoryBar(),
              const Spacer(),
              _buildPlayerCard('Opponent', 1200, isOpponent: true),
              const SizedBox(height: 12),
              Center(
                child: ChessBoard(
                  size: MediaQuery.of(context).size.width,
                  lightSquareColor: const Color(0xFFEBECD0),
                  darkSquareColor: const Color(0xFF779556),
                ),
              ),
              const SizedBox(height: 12),
              _buildPlayerCard('You', 1250, isOpponent: false),
              const Spacer(),
              if (gameState.isGameOver) _buildGameOverBanner(gameState),
              _buildControlBar(ref),
            ],
          ),
        ),
      ),
    );
  }

  void _showPromotionDialog(BuildContext context, WidgetRef ref, bool isWhite) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Promote Pawn to:'),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['q', 'r', 'b', 'n'].map((type) {
            return IconButton(
              icon: Icon(_getPieceIcon(type)),
              onPressed: () {
                ref.read(gameProvider.notifier).promote(type);
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getPieceIcon(String type) {
    switch (type) {
      case 'q': return Icons.workspace_premium;
      case 'r': return Icons.fort;
      case 'b': return Icons.navigation;
      case 'n': return Icons.bedroom_baby;
      default: return Icons.help;
    }
  }

  Widget _buildGameOverBanner(GameState state) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      color: Colors.black87,
      child: Text(
        'GAME OVER • ${state.winner?.toUpperCase()} WINS',
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 2),
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
          _buildControlIcon(Icons.undo_rounded, () => ref.read(gameProvider.notifier).undo()),
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
