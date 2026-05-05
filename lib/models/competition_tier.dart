class CompetitionTier {
  final String id;
  final String name;
  final String prize;
  final int entryCost;
  final int quota;
  final int timeLimitMins;
  final int tbFee;
  final int minPlayers;

  const CompetitionTier({
    required this.id,
    required this.name,
    required this.prize,
    required this.entryCost,
    required this.quota,
    required this.timeLimitMins,
    required this.tbFee,
    required this.minPlayers,
  });

  static const List<CompetitionTier> tiers = [
    CompetitionTier(
      id: 'tier_bronze',
      name: 'Bronze',
      prize: '\$10 Gift Card',
      entryCost: 20,
      quota: 10,
      timeLimitMins: 200,
      tbFee: 10,
      minPlayers: 85,
    ),
    CompetitionTier(
      id: 'tier_silver',
      name: 'Silver',
      prize: '\$25 Gift Card',
      entryCost: 50,
      quota: 15,
      timeLimitMins: 300,
      tbFee: 25,
      minPlayers: 115,
    ),
    CompetitionTier(
      id: 'tier_gold',
      name: 'Gold',
      prize: '\$100 GC / AirPods',
      entryCost: 150,
      quota: 20,
      timeLimitMins: 400,
      tbFee: 75,
      minPlayers: 190,
    ),
    CompetitionTier(
      id: 'tier_platinum',
      name: 'Platinum',
      prize: 'Switch / Controller',
      entryCost: 350,
      quota: 25,
      timeLimitMins: 500,
      tbFee: 175,
      minPlayers: 175,
    ),
    CompetitionTier(
      id: 'tier_diamond',
      name: 'Diamond',
      prize: 'iPhone / PS5',
      entryCost: 600,
      quota: 30,
      timeLimitMins: 600,
      tbFee: 300,
      minPlayers: 340,
    ),
  ];
}
