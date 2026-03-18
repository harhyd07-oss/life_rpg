import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../tasks/providers/habit_provider.dart';
import '../tasks/providers/daily_provider.dart';
import '../tasks/providers/todo_provider.dart';
import '../core/app_theme.dart';

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final habits = ref.watch(habitProvider);
    final dailies = ref.watch(dailyProvider);
    final todos = ref.watch(todoProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Habits'),
                  const SizedBox(width: 6),
                  _CountBadge(count: habits.length),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Dailies'),
                  const SizedBox(width: 6),
                  _CountBadge(count: dailies.length),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('To-Dos'),
                  const SizedBox(width: 6),
                  _CountBadge(count: todos.length),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_HabitsTab(), _DailiesTab(), _TodosTab()],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        icon: Icon(
          Icons.add,
          color: isDark ? AppTheme.darkBackground : AppTheme.lightCard,
        ),
        label: Text(
          'Add Task',
          style: TextStyle(
            color: isDark ? AppTheme.darkBackground : AppTheme.lightCard,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final tab = _tabController.index;
    if (tab == 0) _showAddHabitDialog(context);
    if (tab == 1) _showAddDailyDialog(context);
    if (tab == 2) _showAddTodoDialog(context);
  }

  void _showAddHabitDialog(BuildContext context) {
    _showTaskDialog(
      context: context,
      title: 'New Habit',
      hint: 'Enter habit name',
      onAdd: (name) => ref.read(habitProvider.notifier).addHabit(name),
    );
  }

  void _showAddDailyDialog(BuildContext context) {
    _showTaskDialog(
      context: context,
      title: 'New Daily',
      hint: 'Enter daily name',
      onAdd: (name) => ref.read(dailyProvider.notifier).addDaily(name),
    );
  }

  void _showAddTodoDialog(BuildContext context) {
    _showTaskDialog(
      context: context,
      title: 'New To-Do',
      hint: 'Enter task name',
      onAdd: (name) => ref.read(todoProvider.notifier).addTodo(name),
    );
  }

  void _showTaskDialog({
    required BuildContext context,
    required String title,
    required String hint,
    required Function(String) onAdd,
  }) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
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
                onAdd(name);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

// ── Habits Tab ──────────────────────────────────────────────
class _HabitsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habits = ref.watch(habitProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;

    if (habits.isEmpty) {
      return const _EmptyState(
        icon: Icons.repeat,
        message: 'No habits yet.\nTap + Add Task to create one.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        return _TaskCard(
          title: habit.title,
          subtitle: habit.completed ? 'Completed' : 'Tap to complete',
          color: color,
          icon: Icons.repeat,
          onComplete: () =>
              ref.read(habitProvider.notifier).completeHabit(habit.id),
        );
      },
    );
  }
}

// ── Dailies Tab ─────────────────────────────────────────────
class _DailiesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailies = ref.watch(dailyProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark
        ? AppTheme.darkSecondary
        : AppTheme.lightSecondary;

    if (dailies.isEmpty) {
      return const _EmptyState(
        icon: Icons.calendar_today,
        message: 'No dailies yet.\nTap + Add Task to create one.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: dailies.length,
      itemBuilder: (context, index) {
        final daily = dailies[index];
        return _TaskCard(
          title: daily.title,
          subtitle:
              'Streak: ${daily.streak} day${daily.streak == 1 ? '' : 's'}',
          color: daily.wasCompletedToday ? Colors.green : activeColor,
          icon: Icons.calendar_today,
          isCompleted: daily.wasCompletedToday,
          onComplete: daily.wasCompletedToday
              ? null
              : () => ref.read(dailyProvider.notifier).completeDaily(daily.id),
        );
      },
    );
  }
}

// ── Todos Tab ───────────────────────────────────────────────
class _TodosTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;

    if (todos.isEmpty) {
      return const _EmptyState(
        icon: Icons.check_box_outline_blank,
        message: 'No to-dos yet.\nTap + Add Task to create one.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return _TaskCard(
          title: todo.title,
          subtitle: 'Added ${_formatDate(todo.createdAt)}',
          color: color,
          icon: Icons.check_box_outline_blank,
          onComplete: () =>
              ref.read(todoProvider.notifier).completeTodo(todo.id),
          onDelete: () => ref.read(todoProvider.notifier).deleteTodo(todo.id),
        );
      },
    );
  }

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

// ── Reusable Widgets ────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final bool isCompleted;
  final VoidCallback? onComplete;
  final VoidCallback? onDelete;

  const _TaskCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    this.isCompleted = false,
    this.onComplete,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.4), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted
                ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)
                : null,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onComplete != null)
              IconButton(
                icon: Icon(
                  isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                  color: Colors.green,
                ),
                onPressed: onComplete,
              ),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;

  const _CountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          color: isDark ? AppTheme.darkBackground : AppTheme.lightCard,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
