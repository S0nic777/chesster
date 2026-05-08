import 'dart:math';

class EloCalculator {
  /// Calculates the new Elo rating for a player.
  /// [currentRating] The player's current Elo.
  /// [opponentRating] The opponent's Elo.
  /// [actualScore] 1.0 for a win, 0.5 for a draw, 0.0 for a loss.
  /// [kFactor] The sensitivity factor (usually 32 for most players).
  static int calculateNewRating({
    required int currentRating,
    required int opponentRating,
    required double actualScore,
    int kFactor = 32,
  }) {
    double expectedScore = 1 / (1 + pow(10, (opponentRating - currentRating) / 400));
    int newRating = (currentRating + kFactor * (actualScore - expectedScore)).round();
    return newRating;
  }

  /// Estimates the probability of winning against an opponent.
  static double winProbability(int playerElo, int opponentElo) {
    return 1 / (1 + pow(10, (opponentElo - playerElo) / 400));
  }
}
