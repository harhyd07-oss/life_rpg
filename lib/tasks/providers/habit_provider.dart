import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../player/player_provider.dart';
import '../models/habit_model.dart';

class HabitNotifier extends StateNotifier<List<Habit>> {
  HabitNotifier(this.ref) : super([]) {
    // Load after provider is fully initialized
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
    ref.read(playerProvider.notifier).addXp(20);
  }
}

final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>((ref) {
  return HabitNotifier(ref);
});
