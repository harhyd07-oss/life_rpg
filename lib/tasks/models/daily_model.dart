import 'package:hive/hive.dart';

part 'daily_model.g.dart';

@HiveType(typeId: 2)
class Daily extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  bool completedToday;

  @HiveField(3)
  int streak;

  @HiveField(4)
  DateTime? lastCompletedDate;

  Daily({
    required this.id,
    required this.title,
    this.completedToday = false,
    this.streak = 0,
    this.lastCompletedDate,
  });

  bool get wasCompletedYesterday {
    if (lastCompletedDate == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return lastCompletedDate!.year == yesterday.year &&
        lastCompletedDate!.month == yesterday.month &&
        lastCompletedDate!.day == yesterday.day;
  }

  bool get wasCompletedToday {
    if (lastCompletedDate == null) return false;
    final today = DateTime.now();
    return lastCompletedDate!.year == today.year &&
        lastCompletedDate!.month == today.month &&
        lastCompletedDate!.day == today.day;
  }

  Daily copyWith({
    String? id,
    String? title,
    bool? completedToday,
    int? streak,
    DateTime? lastCompletedDate,
  }) {
    return Daily(
      id: id ?? this.id,
      title: title ?? this.title,
      completedToday: completedToday ?? this.completedToday,
      streak: streak ?? this.streak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
    );
  }
}
