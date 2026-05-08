import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/chess_game_logic.dart';

class GameState {
  final String fen;
  final bool isWhiteTurn;
  final bool isGameOver;
  final String? winner;
  final String? selectedSquare;
  final List<String> legalMoves;

  GameState({
    required this.fen,
    required this.isWhiteTurn,
    required this.isGameOver,
    this.winner,
    this.selectedSquare,
    this.legalMoves = const [],
  });

  GameState copyWith({
    String? fen,
    bool? isWhiteTurn,
    bool? isGameOver,
    String? winner,
    String? selectedSquare,
    List<String>? legalMoves,
  }) {
    return GameState(
      fen: fen ?? this.fen,
      isWhiteTurn: isWhiteTurn ?? this.isWhiteTurn,
      isGameOver: isGameOver ?? this.isGameOver,
      winner: winner ?? this.winner,
      selectedSquare: selectedSquare,
      legalMoves: legalMoves ?? this.legalMoves,
    );
  }
}

class GameNotifier extends Notifier<GameState> {
  final ChessGameLogic _logic = ChessGameLogic();

  @override
  GameState build() {
    return GameState(
      fen: 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1',
      isWhiteTurn: true,
      isGameOver: false,
    );
  }

  void selectSquare(String square) {
    if (state.selectedSquare == square) {
      state = state.copyWith(selectedSquare: null, legalMoves: []);
      return;
    }

    if (state.selectedSquare != null && state.legalMoves.contains(square)) {
      _makeMove(state.selectedSquare!, square);
    } else {
      final moves = _logic.getLegalMoves(square);
      state = state.copyWith(selectedSquare: square, legalMoves: moves);
    }
  }

  void _makeMove(String from, String to) {
    if (_logic.makeMove(from, to)) {
      state = state.copyWith(
        fen: _logic.fen,
        isWhiteTurn: _logic.isWhiteTurn,
        isGameOver: _logic.isGameOver,
        winner: _logic.winner,
        selectedSquare: null,
        legalMoves: [],
        history: _logic.sanHistory,
      );
    }
  }

  void reset() {
    _logic.reset();
    state = GameState(
      fen: _logic.fen,
      isWhiteTurn: _logic.isWhiteTurn,
      isGameOver: _logic.isGameOver,
      history: [],
    );
  }
}

final gameProvider = NotifierProvider<GameNotifier, GameState>(() {
  return GameNotifier();
});
erProvider<GameNotifier, GameState>(() {
  return GameNotifier();
});
