import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/chess_board.dart';
import '../providers/game_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Chesster Arena'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(gameProvider.notifier).reset(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Opponent Info
            _buildPlayerInfo('Opponent', 1200, isTop: true),
            
            const SizedBox(height: 20),
            
            // The Interactive Board
            ChessBoard(
              size: MediaQuery.of(context).size.width * 0.95,
              lightSquareColor: const Color(0xFFE2E8F0),
              darkSquareColor: const Color(0xFF475569),
            ),
            
            const SizedBox(height: 20),
            
            // User Info
            _buildPlayerInfo('You', 1250, isTop: false),

            if (gameState.isGameOver)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  'Game Over! ${gameState.winner} wins.',
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerInfo(String name, int elo, {required bool isTop}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: isTop ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isTop) const CircleAvatar(child: Icon(Icons.person)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: isTop ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text('$elo Elo', style: const TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(width: 12),
          if (isTop) const CircleAvatar(child: Icon(Icons.computer)),
        ],
      ),
    );
  }
}
