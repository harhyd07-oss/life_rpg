import 'package:hive/hive.dart';

part 'analytics_model.g.dart';

@HiveType(typeId: 5)
class AnalyticsModel {
  @HiveField(0)
  final int totalHabitsCompleted;

  @HiveField(1)
  final int totalDailiesCompleted;

  @HiveField(2)
  final int totalTodosCompleted;

  @HiveField(3)
  final int totalXpEarned;

  @HiveField(4)
  final int bestStreak;

  @HiveField(5)
  final Map<String, int> dailyCompletions;

  const AnalyticsModel({
    this.totalHabitsCompleted = 0,
    this.totalDailiesCompleted = 0,
    this.totalTodosCompleted = 0,
    this.totalXpEarned = 0,
    this.bestStreak = 0,
    this.dailyCompletions = const {},
  });

  int get totalTasksCompleted =>
      totalHabitsCompleted + totalDailiesCompleted + totalTodosCompleted;

  AnalyticsModel copyWith({
    int? totalHabitsCompleted,
    int? totalDailiesCompleted,
    int? totalTodosCompleted,
    int? totalXpEarned,
    int? bestStreak,
    Map<String, int>? dailyCompletions,
  }) {
    return AnalyticsModel(
      totalHabitsCompleted: totalHabitsCompleted ?? this.totalHabitsCompleted,
      totalDailiesCompleted:
          totalDailiesCompleted ?? this.totalDailiesCompleted,
      totalTodosCompleted: totalTodosCompleted ?? this.totalTodosCompleted,
      totalXpEarned: totalXpEarned ?? this.totalXpEarned,
      bestStreak: bestStreak ?? this.bestStreak,
      dailyCompletions: dailyCompletions ?? this.dailyCompletions,
    );
  }
}
