import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../player/player_provider.dart';
import '../models/todo_model.dart';

class TodoNotifier extends StateNotifier<List<Todo>> {
  TodoNotifier(this.ref) : super(_loadInitialState());

  final Ref ref;

  static const int todoXp = 25;
  static const int todoGold = 10;

  static List<Todo> _loadInitialState() {
    final box = Hive.box<Todo>('todoBox');
    return box.values.toList();
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
    ref.read(playerProvider.notifier).addXp(todoXp);
    ref.read(playerProvider.notifier).addGold(todoGold);
  }

  void deleteTodo(String id) {
    state = state.where((todo) => todo.id != id).toList();
    _save();
  }
}

final todoProvider = StateNotifierProvider<TodoNotifier, List<Todo>>((ref) {
  return TodoNotifier(ref);
});
