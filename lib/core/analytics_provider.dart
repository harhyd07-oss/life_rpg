import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'analytics_model.dart';

class AnalyticsNotifier extends StateNotifier<AnalyticsModel> {
  AnalyticsNotifier() : super(const AnalyticsModel()) {
    Future.microtask(() => _loadFromHive());
  }

  void _loadFromHive() {
    final box = Hive.box<AnalyticsModel>('analyticsBox');
    final saved = box.get('analytics');
    if (saved != null) state = saved;
  }

  void _save() {
    final box = Hive.box<AnalyticsModel>('analyticsBox');
    box.put('analytics', state);
  }

  String get _todayKey {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  void recordHabitCompleted(int xpEarned) {
    final updatedCompletions = Map<String, int>.from(state.dailyCompletions);
    updatedCompletions[_todayKey] = (updatedCompletions[_todayKey] ?? 0) + 1;

    state = state.copyWith(
      totalHabitsCompleted: state.totalHabitsCompleted + 1,
      totalXpEarned: state.totalXpEarned + xpEarned,
      dailyCompletions: updatedCompletions,
    );
    _save();
  }

  void recordDailyCompleted(int xpEarned, int currentStreak) {
    final updatedCompletions = Map<String, int>.from(state.dailyCompletions);
    updatedCompletions[_todayKey] = (updatedCompletions[_todayKey] ?? 0) + 1;

    state = state.copyWith(
      totalDailiesCompleted: state.totalDailiesCompleted + 1,
      totalXpEarned: state.totalXpEarned + xpEarned,
      bestStreak: currentStreak > state.bestStreak
          ? currentStreak
          : state.bestStreak,
      dailyCompletions: updatedCompletions,
    );
    _save();
  }

  void recordTodoCompleted(int xpEarned) {
    final updatedCompletions = Map<String, int>.from(state.dailyCompletions);
    updatedCompletions[_todayKey] = (updatedCompletions[_todayKey] ?? 0) + 1;

    state = state.copyWith(
      totalTodosCompleted: state.totalTodosCompleted + 1,
      totalXpEarned: state.totalXpEarned + xpEarned,
      dailyCompletions: updatedCompletions,
    );
    _save();
  }
}

final analyticsProvider =
    StateNotifierProvider<AnalyticsNotifier, AnalyticsModel>((ref) {
      return AnalyticsNotifier();
    });
