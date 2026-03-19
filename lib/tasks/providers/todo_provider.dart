import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../player/player_provider.dart';
import '../../core/analytics_provider.dart';
import '../models/todo_model.dart';
import '../../core/character_class.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier(this.ref) : super([]) {
    Future.microtask(() => _loadFromHive());
  }

  final Ref ref;

  static const int todoBaseXp = 25;
  static const int todoGold = 10;

  void _loadFromHive() {
    final box = Hive.box<Todo>('todoBox');
    state = box.values.toList();
  }

  void _save() {
    final box = Hive.box<Todo>('todoBox');
    box.clear();
    for (final todo in state) {
      box.put(todo.id, todo);
    }
  }

  void addTodo(String title) {
    final newTodo = Todo(
      id: DateTime.now().toString(),
      title: title,
      createdAt: DateTime.now(),
    );
    state = [...state, newTodo];
    _save();
  }

  void completeTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
    _save();

    // Apply class multiplier
    final player = ref.read(playerProvider);
    final multiplier = player.characterClass?.todoMultiplier ?? 1.0;
    final xp = (todoBaseXp * multiplier).round();

    ref.read(playerProvider.notifier).addXp(xp);
    ref.read(playerProvider.notifier).addGold(todoGold);
    ref.read(analyticsProvider.notifier).recordTodoCompleted(xp);
  }

  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
    _save();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier(ref);
});
