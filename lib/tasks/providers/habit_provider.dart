import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../player/player_provider.dart';
import '../models/habit_model.dart';

class HabitNotifier extends StateNotifier<List<Habit>> {
  HabitNotifier(this.ref) : super([]);

  final Ref ref;

  void addHabit(String title) {
    final newHabit = Habit(id: DateTime.now().toString(), title: title);
    state = [...state, newHabit];
  }

  void completeHabit(String id) {
    state = [
      for (final habit in state)
        if (habit.id == id)
          Habit(id: habit.id, title: habit.title, completed: true)
        else
          habit,
    ];

    // Correctly calls addXp() on PlayerNotifier
    ref.read(playerProvider.notifier).addXp(20);
  }
}

final habitProvider = StateNotifierProvider<HabitNotifier, List<Habit>>((ref) {
  return HabitNotifier(ref);
});
