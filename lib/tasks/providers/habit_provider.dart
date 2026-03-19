import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../player/player_provider.dart';
import '../../core/analytics_provider.dart';
import '../models/habit_model.dart';
import '../../core/character_class.dart';

class HabitNotifier extends StateNotifier<List<Habit>> {
  HabitNotifier(this.ref) : super([]) {
    Future.microtask(() => _loadFromHive());
  }

  final Ref ref;

  void _loadFromHive() {
    final box = Hive.box<Habit>('habitBox');
    state = box.values.toList();
  }

  void _save() {
    final box = Hive.box<Habit>('habitBox');
    box.clear();
    for (final habit in state) {
      box.put(habit.id, habit);
    }
  }

  void addHabit(String title) {
    final newHabit = Habit(id: DateTime.now().toString(), title: title);
    state = [...state, newHabit];
    _save();
  }

  void completeHabit(String id) {
    state = [
      for (final habit in state)
        if (habit.id == id)
          Habit(id: habit.id, title: habit.title, completed: true)
        else
          habit,
    ];
    _save();

    // Apply class multiplier
    final player = ref.read(playerProvider);
    final multiplier = player.characterClass?.habitMultiplier ?? 1.0;
    final xp = (20 * multiplier).round();

    ref.read(playerProvider.notifier).addXp(xp);
    ref.read(analyticsProvider.notifier).recordHabitCompleted(xp);
  }
}

final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>((ref) {
  return HabitNotifier(ref);
});
