import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/competition_tier.dart';

class CompetitionsScreen extends StatelessWidget {
  const CompetitionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('COMPETITIONS', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2.0)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: CompetitionTier.tiers.length,
        itemBuilder: (context, index) {
          final tier = CompetitionTier.tiers[index];
          // Staggered entrance
          return _buildTierCard(context, tier)
              .animate()
              .fade(duration: 400.ms, delay: (index * 100).ms)
              .slideX(begin: 0.2, end: 0, curve: Curves.easeOutQuad);
        },
      ),
    );
  }

  Widget _buildTierCard(BuildContext context, CompetitionTier tier) {
    Color tierColor;
    bool isPremium = false;
    switch(tier.name) {
      case 'Bronze': tierColor = Colors.orangeAccent.shade400; break;
      case 'Silver': tierColor = Colors.grey.shade400; break;
      case 'Gold': tierColor = Colors.amber; break;
      case 'Platinum': 
        tierColor = Colors.lightBlueAccent; 
        isPremium = true;
        break;
      case 'Diamond': 
        tierColor = Colors.purpleAccent; 
        isPremium = true;
        break;
      default: tierColor = Colors.white;
    }

    Widget cardContent = Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: tierColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: tierColor.withOpacity(isPremium ? 0.3 : 0.1),
            blurRadius: isPremium ? 20 : 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(20),
        title: Text(
          tier.name.toUpperCase(),
          style: TextStyle(color: tierColor, fontWeight: FontWeight.w900, fontSize: 24, letterSpacing: 2.0),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Prize: ${tier.prize}', style: const TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.bolt, color: Colors.amberAccent, size: 16),
                const SizedBox(width: 4),
                Text('${tier.entryCost} Entry Fee', style: TextStyle(color: Colors.white.withOpacity(0.7))),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: tierColor.withOpacity(0.2),
            foregroundColor: tierColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            context.push('/matchmaking');
          },
          child: const Text('JOIN'),
        ),
      ),
    );

    // Apply continuous shimmer to premium tier cards
    if (isPremium) {
      cardContent = cardContent
          .animate(onPlay: (controller) => controller.repeat())
          .shimmer(duration: 3.seconds, color: Colors.white24, angle: 1.0);
    }

    return cardContent;
  }
}
