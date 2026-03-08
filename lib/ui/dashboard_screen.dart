import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../player/player_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Life RPG")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Level: ${player.level}",
              style: const TextStyle(fontSize: 20),
            ),
            Text("XP: ${player.xp}", style: const TextStyle(fontSize: 20)),
            Text("Gold: ${player.gold}", style: const TextStyle(fontSize: 20)),
            Text(
              "Health: ${player.health}",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
