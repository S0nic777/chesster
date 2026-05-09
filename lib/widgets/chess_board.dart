import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/game_provider.dart';

class ChessBoard extends ConsumerWidget {
  final double size;
  final Color lightSquareColor;
  final Color darkSquareColor;

  const ChessBoard({
    super.key,
    required this.size,
    this.lightSquareColor = const Color(0xFFE2E8F0),
    this.darkSquareColor = const Color(0xFF475569),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final boardData = _parseFen(gameState.fen);

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemCount: 64,
          itemBuilder: (context, index) {
            int row = index ~/ 8;
            int col = index % 8;
            String square = '${String.fromCharCode(97 + col)}${8 - row}';
            bool isLight = (row + col) % 2 == 0;
            String? piece = boardData[square];

            bool isSelected = gameState.selectedSquare == square;
            bool isLegalMove = gameState.legalMoves.contains(square);
            
            // Highlight last move
            bool isLastMove = false;
            if (gameState.history.isNotEmpty) {
              // This is a bit simplified, ideally we track 'from' and 'to' in GameState
            }

            return GestureDetector(
              onTap: () => ref.read(gameProvider.notifier).selectSquare(square),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected 
                      ? const Color(0xFFF7F769).withOpacity(0.8) // Highlight selected
                      : (isLight ? lightSquareColor : darkSquareColor),
                  border: isSelected ? Border.all(color: Colors.white, width: 1) : null,
                ),
                child: Stack(
                  children: [
                    if (piece != null)
                      Center(
                        child: _getPieceWidget(piece),
                      ),
                    if (isLegalMove)
                      Center(
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: piece != null ? Colors.red.withOpacity(0.4) : Colors.black.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: piece != null ? Border.all(color: Colors.red, width: 2) : null,
                          ),
                        ),
                      ),
                    // Elegant Coordinate labels
                    if (col == 0)
                      Positioned(
                        left: 2,
                        top: 2,
                        child: Text('${8 - row}', style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: isLight ? darkSquareColor.withOpacity(0.5) : lightSquareColor.withOpacity(0.5))),
                      ),
                    if (row == 7)
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Text(String.fromCharCode(97 + col), style: TextStyle(fontSize: 7, fontWeight: FontWeight.bold, color: isLight ? darkSquareColor.withOpacity(0.5) : lightSquareColor.withOpacity(0.5))),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Map<String, String> _parseFen(String fen) {
    final board = <String, String>{};
    final parts = fen.split(' ');
    final rows = parts[0].split('/');

    for (int i = 0; i < 8; i++) {
      String rowStr = rows[i];
      int colIndex = 0;
      for (int j = 0; j < rowStr.length; j++) {
        String char = rowStr[j];
        if (RegExp(r'\d').hasMatch(char)) {
          colIndex += int.parse(char);
        } else {
          String square = '${String.fromCharCode(97 + colIndex)}${8 - i}';
          board[square] = char;
          colIndex++;
        }
      }
    }
    return board;
  }

  Widget _getPieceWidget(String code) {
    final color = code == code.toUpperCase() ? 'white' : 'black';
    final typeMap = {
      'p': 'pawn',
      'r': 'rook',
      'n': 'knight',
      'b': 'bishop',
      'q': 'queen',
      'k': 'king',
    };
    final type = typeMap[code.toLowerCase()];
    final assetPath = 'assets/pieces/${color}_$type.svg';
    
    return SvgPicture.asset(
      assetPath,
      width: size / 10, // Increased size slightly for better visibility
      height: size / 10,
      fit: BoxFit.contain,
      placeholderBuilder: (context) => Text(
        code, 
        style: TextStyle(
          color: color == 'white' ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        )
      ),
    );
  }
}
