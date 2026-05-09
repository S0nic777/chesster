import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/chess_game_logic.dart';

class GameState {
  final String fen;
  final bool isWhiteTurn;
  final bool isGameOver;
  final String? winner;
  final String? selectedSquare;
  final List<String> legalMoves;
  final List<String> history;
  final String? pendingPromotionFrom;
  final String? pendingPromotionTo;

  GameState({
    required this.fen,
    required this.isWhiteTurn,
    required this.isGameOver,
    this.winner,
    this.selectedSquare,
    this.legalMoves = const [],
    this.history = const [],
    this.pendingPromotionFrom,
    this.pendingPromotionTo,
  });

  GameState copyWith({
    String? fen,
    bool? isWhiteTurn,
    bool? isGameOver,
    String? winner,
    String? selectedSquare,
    List<String>? legalMoves,
    List<String>? history,
    String? pendingPromotionFrom,
    String? pendingPromotionTo,
  }) {
    return GameState(
      fen: fen ?? this.fen,
      isWhiteTurn: isWhiteTurn ?? this.isWhiteTurn,
      isGameOver: isGameOver ?? this.isGameOver,
      winner: winner ?? this.winner,
      selectedSquare: selectedSquare,
      legalMoves: legalMoves ?? this.legalMoves,
      history: history ?? this.history,
      pendingPromotionFrom: pendingPromotionFrom,
      pendingPromotionTo: pendingPromotionTo,
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
    if (state.pendingPromotionFrom != null) return; // Wait for promotion

    if (state.selectedSquare == square) {
      state = state.copyWith(selectedSquare: null, legalMoves: []);
      return;
    }

    if (state.selectedSquare != null && state.legalMoves.contains(square)) {
      // Check for pawn promotion
      if (_isPromotionMove(state.selectedSquare!, square)) {
        state = state.copyWith(
          pendingPromotionFrom: state.selectedSquare,
          pendingPromotionTo: square,
        );
      } else {
        _makeMove(state.selectedSquare!, square);
      }
    } else {
      final moves = _logic.getLegalMoves(square);
      state = state.copyWith(selectedSquare: square, legalMoves: moves);
    }
  }

  bool _isPromotionMove(String from, String to) {
    final piece = _logic.getPiece(from);
    if (piece?.type.toUpperCase() == 'P') {
      if ((piece?.color == 'white' && to[1] == '8') ||
          (piece?.color == 'black' && to[1] == '1')) {
        return true;
      }
    }
    return false;
  }

  void promote(String pieceType) {
    if (state.pendingPromotionFrom != null && state.pendingPromotionTo != null) {
      _makeMove(state.pendingPromotionFrom!, state.pendingPromotionTo!, promotion: pieceType);
    }
  }

  void _makeMove(String from, String to, {String? promotion}) {
    if (_logic.makeMove(from, to, promotion: promotion)) {
      state = state.copyWith(
        fen: _logic.fen,
        isWhiteTurn: _logic.isWhiteTurn,
        isGameOver: _logic.isGameOver,
        winner: _logic.winner,
        selectedSquare: null,
        legalMoves: [],
        history: _logic.sanHistory,
        pendingPromotionFrom: null,
        pendingPromotionTo: null,
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

  void undo() {
    _logic.undo();
    state = state.copyWith(
      fen: _logic.fen,
      isWhiteTurn: _logic.isWhiteTurn,
      isGameOver: _logic.isGameOver,
      winner: _logic.winner,
      history: _logic.sanHistory,
      selectedSquare: null,
      legalMoves: [],
    );
  }
}

final gameProvider = NotifierProvider<GameNotifier, GameState>(() {
  return GameNotifier();
});
