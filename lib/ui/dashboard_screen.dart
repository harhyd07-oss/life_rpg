import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../player/player_provider.dart';
import '../player/player_model.dart';
import '../tasks/providers/habit_provider.dart';
import '../tasks/providers/daily_provider.dart';
import '../tasks/providers/todo_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _previousLevel = 1;

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerProvider);
    final habits = ref.watch(habitProvider);
    final dailies = ref.watch(dailyProvider);
    final todos = ref.watch(todoProvider);

    // Level-up detection — compare previous level to current
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (player.level > _previousLevel) {
        _previousLevel = player.level;
        _showLevelUpSnackbar(context, player.level);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Life RPG'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _PlayerStatsCard(player: player),
              const SizedBox(height: 24),

              // ── Habits Section ──────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Habits',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () => _showAddHabitDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              habits.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'No habits yet. Add one!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: habits.length,
                      itemBuilder: (context, index) {
                        final habit = habits[index];
                        return Card(
                          child: ListTile(
                            title: Text(habit.title),
                            trailing: IconButton(
                              icon: const Icon(
                                Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                ref
                                    .read(habitProvider.notifier)
                                    .completeHabit(habit.id);
                              },
                            ),
                          ),
                        );
                      },
                    ),

              const SizedBox(height: 24),

              // ── Dailies Section ─────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dailies',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () => _showAddDailyDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              dailies.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'No dailies yet. Add one!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dailies.length,
                      itemBuilder: (context, index) {
                        final daily = dailies[index];
                        return Card(
                          child: ListTile(
                            title: Text(daily.title),
                            subtitle: Text(
                              'Streak: ${daily.streak} day${daily.streak == 1 ? '' : 's'}',
                              style: TextStyle(
                                color: daily.streak > 0
                                    ? Colors.orange
                                    : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            trailing: daily.wasCompletedToday
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : IconButton(
                                    icon: const Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      ref
                                          .read(dailyProvider.notifier)
                                          .completeDaily(daily.id);
                                    },
                                  ),
                          ),
                        );
                      },
                    ),

              const SizedBox(height: 24),

              // ── Todos Section ───────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'To-Dos',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () => _showAddTodoDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              todos.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'No to-dos yet. Add one!',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return Card(
                          child: ListTile(
                            title: Text(todo.title),
                            subtitle: Text(
                              'Added ${_formatDate(todo.createdAt)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Complete button
                                IconButton(
                                  icon: const Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(todoProvider.notifier)
                                        .completeTodo(todo.id);
                                  },
                                ),
                                // Delete button
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    ref
                                        .read(todoProvider.notifier)
                                        .deleteTodo(todo.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

              const SizedBox(height: 80), // padding above FAB
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddHabitDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showLevelUpSnackbar(BuildContext context, int newLevel) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.star, color: Colors.yellow),
            const SizedBox(width: 8),
            Text(
              'Level Up! You are now Level $newLevel!',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        backgroundColor: Colors.deepPurple,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showAddHabitDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Habit'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter habit name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                ref.read(habitProvider.notifier).addHabit(name);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddDailyDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Daily'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter daily name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                ref.read(dailyProvider.notifier).addDaily(name);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New To-Do'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter task name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                ref.read(todoProvider.notifier).addTodo(name);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  /// Formats date as 'today', 'yesterday', or 'dd/mm/yyyy'
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);
    final diff = today.difference(taskDate).inDays;

    if (diff == 0) return 'today';
    if (diff == 1) return 'yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Extracted widget — keeps build() clean and focused.
class _PlayerStatsCard extends StatelessWidget {
  final PlayerModel player;

  const _PlayerStatsCard({required this.player});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Level + Gold row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level ${player.level}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${player.gold} Gold',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // XP Progress Bar
            Row(
              children: [
                const Text('XP  ', style: TextStyle(fontSize: 13)),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: player.xpProgress,
                      minHeight: 12,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${player.xp} / ${player.xpToNextLevel}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Health Bar
            Row(
              children: [
                const Text('HP  ', style: TextStyle(fontSize: 13)),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: player.health / 100,
                      minHeight: 12,
                      backgroundColor: Colors.grey[300],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${player.health} / 100',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
