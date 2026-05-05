enum CompetitionStatus { open, active, tieBreaker, completed, unfilled }

class CompetitionModel {
  final String id;
  final String tierId;
  final CompetitionStatus status;
  final DateTime createdAt;
  final DateTime closesAt;

  CompetitionModel({
    required this.id,
    required this.tierId,
    required this.status,
    required this.createdAt,
    required this.closesAt,
  });

  factory CompetitionModel.fromJson(Map<String, dynamic> json) {
    return CompetitionModel(
      id: json['id'] as String,
      tierId: json['tier_id'] as String,
      status: _statusFromString(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      closesAt: DateTime.parse(json['closes_at'] as String),
    );
  }

  static CompetitionStatus _statusFromString(String status) {
    switch (status) {
      case 'active': return CompetitionStatus.active;
      case 'tie_breaker': return CompetitionStatus.tieBreaker;
      case 'completed': return CompetitionStatus.completed;
      case 'unfilled': return CompetitionStatus.unfilled;
      case 'open':
      default:
        return CompetitionStatus.open;
    }
  }
}
