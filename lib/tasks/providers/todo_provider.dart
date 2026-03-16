import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../player/player_provider.dart';
import '../models/todo_model.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier(this.ref) : super([]);

  final Ref ref;

  /// XP rewarded per todo completion.
  static const int todoXp = 25;

  /// Gold rewarded per todo completion.
  static const int todoGold = 10;

  void addTodo(String title) {
    final newTodo = Todo(
      id: DateTime.now().toString(),
      title: title,
      createdAt: DateTime.now(),
    );
    state = [...state, newTodo];
  }

  void completeTodo(String id) {
    final player = ref.read(playerProvider.notifier);

    // Remove completed todo from the list
    state = state.where((todo) => todo.id != id).toList();

    // Reward player
    player.addXp(todoXp);
    player.addGold(todoGold);
  }

  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier(ref);
});
