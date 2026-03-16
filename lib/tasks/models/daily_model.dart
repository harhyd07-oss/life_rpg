class Daily {
  final String id;
  final String title;
  final bool completedToday;
  final int streak;
  final DateTime? lastCompletedDate;

  const Daily({
    required this.id,
    required this.title,
    this.completedToday = false,
    this.streak = 0,
    this.lastCompletedDate,
  });

  /// Whether this daily was completed yesterday.
  /// Used to determine if streak should continue or reset.
  bool get wasCompletedYesterday {
    if (lastCompletedDate == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return lastCompletedDate!.year == yesterday.year &&
        lastCompletedDate!.month == yesterday.month &&
        lastCompletedDate!.day == yesterday.day;
  }

  /// Whether this daily was completed today.
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
