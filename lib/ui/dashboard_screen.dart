import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../player/player_provider.dart';
import '../tasks/providers/habit_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final habits = ref.watch(habitProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Life RPG")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(habitProvider.notifier).addHabit("New Habit");
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Text("Level: ${player.level}", style: const TextStyle(fontSize: 18)),
          Text("XP: ${player.xp}", style: const TextStyle(fontSize: 18)),
          Text("Gold: ${player.gold}", style: const TextStyle(fontSize: 18)),
          Text(
            "Health: ${player.health}",
            style: const TextStyle(fontSize: 18),
          ),

          const Divider(),

          const Text(
            "Habits",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];

                return ListTile(
                  title: Text(habit.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.check),
                    onPressed: () {
                      ref.read(habitProvider.notifier).completeHabit(habit.id);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
