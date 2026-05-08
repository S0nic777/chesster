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
    this.lightSquareColor = const Color(0xFFF0D9B5),
    this.darkSquareColor = const Color(0xFFB58863),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final boardData = _parseFen(gameState.fen);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
      ),
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

          return GestureDetector(
            onTap: () => ref.read(gameProvider.notifier).selectSquare(square),
            child: Container(
              color: isSelected 
                  ? Colors.yellow.withOpacity(0.5) 
                  : (isLight ? lightSquareColor : darkSquareColor),
              child: Stack(
                children: [
                  if (piece != null)
                    Center(
                      child: _getPieceWidget(piece),
                    ),
                  if (isLegalMove)
                    Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  // Coordinate labels
                  if (col == 0)
                    Positioned(
                      left: 2,
                      top: 2,
                      child: Text('${8 - row}', style: TextStyle(fontSize: 8, color: isLight ? darkSquareColor : lightSquareColor)),
                    ),
                  if (row == 7)
                    Positioned(
                      right: 2,
                      bottom: 2,
                      child: Text(String.fromCharCode(97 + col), style: TextStyle(fontSize: 8, color: isLight ? darkSquareColor : lightSquareColor)),
                    ),
                ],
              ),
            ),
          );
        },
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
      width: size / 9,
      height: size / 9,
      // Fallback if SVG missing
      placeholderBuilder: (context) => Text(code, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
