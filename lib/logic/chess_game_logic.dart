import 'package:chess/chess.dart' as chess;

class ChessGameLogic {
  final chess.Chess _game = chess.Chess();

  /// Returns the current FEN string representing the board state.
  String get fen => _game.fen;

  /// Returns the current turn (true for White, false for Black).
  bool get isWhiteTurn => _game.turn == chess.Color.WHITE;

  /// Returns whether the game is over.
  bool get isGameOver => _game.game_over;

  /// Returns the winner if the game is over (null for draw or ongoing).
  String? get winner {
    if (!_game.game_over) return null;
    if (_game.in_checkmate) {
      return _game.turn == chess.Color.WHITE ? 'Black' : 'White';
    }
    return 'Draw';
  }

  /// Attempts to make a move.
  /// [from] Square coordinate (e.g., 'e2').
  /// [to] Square coordinate (e.g., 'e4').
  /// [promotion] Piece type for promotion (e.g., 'q').
  bool makeMove(String from, String to, {String? promotion}) {
    final move = _game.move({
      'from': from,
      'to': to,
      'promotion': promotion ?? 'q',
    });
    return move != null;
  }

  /// Returns all legal moves for a given square.
  List<String> getLegalMoves(String square) {
    return _game.moves({'square': square, 'verbose': true}).map((m) => m['to'] as String).toList();
  }

  /// Returns the piece at a specific square.
  chess.Piece? getPiece(String square) {
    return _game.get(square);
  }

  /// Resets the game to the starting position.
  void reset() {
    _game.reset();
  }

  /// Undo the last move.
  void undo() {
    _game.undo();
  }

  /// Returns the history of moves in Standard Algebraic Notation (SAN).
  List<String> get sanHistory {
    // PGN format is "1. e4 e5 2. Nf3 Nc6 ..."
    // We want a list: ["e4", "e5", "Nf3", "Nc6"]
    final pgn = _game.pgn();
    if (pgn.isEmpty) return [];
    
    // Remove move numbers like "1. ", "2. ", etc.
    final moveParts = pgn.replaceAll(RegExp(r'\d+\.\s+'), '').split(RegExp(r'\s+'));
    return moveParts.where((s) => s.isNotEmpty).toList();
  }
}
