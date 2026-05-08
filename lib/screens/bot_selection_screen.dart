import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BotSelectionScreen extends StatelessWidget {
  const BotSelectionScreen({super.key});

  final List<Map<String, dynamic>> bots = const [
    {'name': 'Novice Nate', 'elo': 400, 'icon': '👶', 'desc': 'Good for learning basic moves.'},
    {'name': 'Casual Clara', 'elo': 1000, 'icon': '👨‍💼', 'desc': 'A balanced challenge for hobbyists.'},
    {'name': 'Master Magnus', 'elo': 2800, 'icon': '🧠', 'desc': 'Near-perfect play. Prepare for battle.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('Choose your opponent'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bots.length,
        itemBuilder: (context, index) {
          final bot = bots[index];
          return Card(
            color: const Color(0xFF1E293B),
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: Text(bot['icon'], style: const TextStyle(fontSize: 40)),
              title: Text(bot['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text('${bot['elo']} Elo • ${bot['desc']}', style: const TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.play_arrow_rounded, color: Color(0xFF3B82F6), size: 32),
              onTap: () {
                // Navigate to game screen with selected bot level
                context.go('/home'); // Placeholder for game screen
              },
            ),
          );
        },
      ),
    );
  }
}
