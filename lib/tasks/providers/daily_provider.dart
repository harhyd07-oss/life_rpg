import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../player/player_provider.dart';
import '../../core/analytics_provider.dart';
import '../models/daily_model.dart';
import '../../core/character_class.dart';

class DailyNotifier extends StateNotifier<List<Daily>> {
  DailyNotifier(this.ref) : super([]) {
    Future.microtask(() => _loadFromHive());
  }

  final Ref ref;

  static const int dailyBaseXp = 30;
  static const int streakBonusXp = 10;
  static const int dailyGold = 15;

  void _loadFromHive() {
    final box = Hive.box<Daily>('dailyBox');
    state = box.values.toList();
  }

  void _save() {
    final box = Hive.box<Daily>('dailyBox');
    box.clear();
    for (final daily in state) {
      box.put(daily.id, daily);
    }
  }

  void addDaily(String title) {
    final newDaily = Daily(id: DateTime.now().toString(), title: title);
    state = [...state, newDaily];
    _save();
  }

  void completeDaily(String id) {
    state = [
      for (final daily in state)
        if (daily.id == id && !daily.wasCompletedToday)
          _buildCompletedDaily(daily)
        else
          daily,
    ];
    _save();

    final completed = state.firstWhere((d) => d.id == id);

    // Apply class multiplier
    final player = ref.read(playerProvider);
    final multiplier = player.dailyMultiplier;
    final baseXp = dailyBaseXp + (completed.streak > 1 ? streakBonusXp : 0);
    final totalXp = (baseXp * multiplier).round();

    ref.read(playerProvider.notifier).addXp(totalXp);
    ref.read(playerProvider.notifier).addGold(dailyGold);
    ref
        .read(analyticsProvider.notifier)
        .recordDailyCompleted(totalXp, completed.streak);
  }

  void resetDailies() {
    final player = ref.read(playerProvider.notifier);

    for (final daily in state) {
      if (!daily.wasCompletedToday && !daily.wasCompletedYesterday) {
        player.takeDamage(10);
      }
    }

    state = [for (final daily in state) daily.copyWith(completedToday: false)];
    _save();
  }

  Daily _buildCompletedDaily(Daily daily) {
    final newStreak = daily.wasCompletedYesterday ? daily.streak + 1 : 1;

    return daily.copyWith(
      completedToday: true,
      streak: newStreak,
      lastCompletedDate: DateTime.now(),
    );
  }
}

final dailyProvider = StateNotifierProvider<DailyNotifier, List<Daily>>((ref) {
  return DailyNotifier(ref);
});
