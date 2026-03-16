import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../player/player_provider.dart';
import '../models/daily_model.dart';

class DailyNotifier extends StateNotifier<List<Daily>> {
  DailyNotifier(this.ref) : super([]);

  final Ref ref;

  /// XP rewarded per daily completion.
  static const int dailyXp = 30;

  /// Bonus XP for maintaining a streak.
  static const int streakBonusXp = 10;

  /// Gold rewarded per daily completion.
  static const int dailyGold = 15;

  void addDaily(String title) {
    final newDaily = Daily(id: DateTime.now().toString(), title: title);
    state = [...state, newDaily];
  }

  void completeDaily(String id) {
    final player = ref.read(playerProvider.notifier);

    state = [
      for (final daily in state)
        if (daily.id == id && !daily.wasCompletedToday)
          _buildCompletedDaily(daily)
        else
          daily,
    ];

    // Find the updated daily to calculate streak bonus
    final completed = state.firstWhere((d) => d.id == id);
    final totalXp = dailyXp + (completed.streak > 1 ? streakBonusXp : 0);

    player.addXp(totalXp);
    player.addGold(dailyGold);
  }

  /// Resets all dailies at the start of a new day.
  /// Call this when the app is opened each day.
  void resetDailies() {
    final player = ref.read(playerProvider.notifier);

    for (final daily in state) {
      // If daily was not completed yesterday or today, streak resets
      if (!daily.wasCompletedToday && !daily.wasCompletedYesterday) {
        if (daily.streak > 0) {
          // Penalise player for missing a daily
          player.takeDamage(10);
        }
      }
    }

    // Reset completedToday for all dailies
    state = [for (final daily in state) daily.copyWith(completedToday: false)];
  }

  /// Builds the updated daily after completion with streak logic.
  Daily _buildCompletedDaily(Daily daily) {
    final newStreak = daily.wasCompletedYesterday
        ? daily.streak +
              1 // Streak continues
        : 1; // Streak resets to 1

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
