class ScoringLogic {
  static double calculateMQI(Map<String, int> moveCounts) {
    double base = 1.0;
    double score = base + 
      ((moveCounts['brilliant'] ?? 0) * 0.40) +
      ((moveCounts['excellent'] ?? 0) * 0.15) -
      ((moveCounts['inaccuracy'] ?? 0) * 0.10) -
      ((moveCounts['mistake'] ?? 0) * 0.30) -
      ((moveCounts['blunder'] ?? 0) * 0.60);
    
    // Clamp between 0.0 and 2.0
    return score.clamp(0.0, 2.0);
  }

  static int getBucketedBonus(double rawMQI) {
    if (rawMQI >= 1.50) return 2;
    if (rawMQI >= 0.75) return 1;
    return 0;
  }

  static double calculateTotalMatchScore(double matchResultPoints, double rawMQI) {
    return matchResultPoints + getBucketedBonus(rawMQI);
  }
}
