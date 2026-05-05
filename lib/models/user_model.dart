class UserModel {
  final String id;
  final String username;
  final int eloRating;
  final int walletEarned;
  final int walletPurchased;
  final bool isPremium;
  final bool isSuspicious;
  final int gamesPlayed;

  UserModel({
    required this.id,
    required this.username,
    required this.eloRating,
    required this.walletEarned,
    required this.walletPurchased,
    required this.isPremium,
    required this.isSuspicious,
    required this.gamesPlayed,
  });

  int get totalNeurals => walletEarned + walletPurchased;
  int get maxEarnedCap => isPremium ? 250 : 50;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      eloRating: json['elo_rating'] as int? ?? 1200,
      walletEarned: json['wallet_earned'] as int? ?? 0,
      walletPurchased: json['wallet_purchased'] as int? ?? 0,
      isPremium: json['is_premium'] as bool? ?? false,
      isSuspicious: json['is_suspicious'] as bool? ?? false,
      gamesPlayed: json['games_played'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'elo_rating': eloRating,
      'wallet_earned': walletEarned,
      'wallet_purchased': walletPurchased,
      'is_premium': isPremium,
      'is_suspicious': isSuspicious,
      'games_played': gamesPlayed,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    int? eloRating,
    int? walletEarned,
    int? walletPurchased,
    bool? isPremium,
    bool? isSuspicious,
    int? gamesPlayed,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      eloRating: eloRating ?? this.eloRating,
      walletEarned: walletEarned ?? this.walletEarned,
      walletPurchased: walletPurchased ?? this.walletPurchased,
      isPremium: isPremium ?? this.isPremium,
      isSuspicious: isSuspicious ?? this.isSuspicious,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
    );
  }
}
