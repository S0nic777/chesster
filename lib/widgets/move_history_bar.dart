import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/game_provider.dart';

class MoveHistoryBar extends ConsumerWidget {
  const MoveHistoryBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(gameProvider.select((s) => s.history));
    final ScrollController scrollController = ScrollController();

    // Auto-scroll to end when new move added
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: const Border(
          top: BorderSide(color: Colors.white10),
          bottom: BorderSide(color: Colors.white10),
        ),
      ),
      child: ListView.builder(
        controller: scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: (history.length / 2).ceil(),
        itemBuilder: (context, index) {
          final moveNumber = index + 1;
          final whiteMove = history[index * 2];
          final blackMove = history.length > (index * 2 + 1) ? history[index * 2 + 1] : null;

          return Row(
            children: [
              Text(
                '$moveNumber. ',
                style: const TextStyle(
                  color: Colors.white24,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              _buildMoveItem(whiteMove, true),
              if (blackMove != null) ...[
                const SizedBox(width: 8),
                _buildMoveItem(blackMove, false),
              ],
              const SizedBox(width: 16),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMoveItem(String move, bool isWhite) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isWhite ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        move,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
