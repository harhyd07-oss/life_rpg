import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../tasks/providers/daily_provider.dart';

class ResetService {
  static const String _lastResetKey = 'lastResetDate';

  /// Call this every time the app starts.
  /// Checks if a new day has passed and resets dailies if needed.
  static void checkAndReset(WidgetRef ref) {
    final box = Hive.box('settingsBox');
    final lastResetRaw = box.get(_lastResetKey) as String?;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (lastResetRaw == null) {
      // First time app is opened — just save today
      box.put(_lastResetKey, today.toIso8601String());
      return;
    }

    final lastReset = DateTime.parse(lastResetRaw);
    final lastResetDay = DateTime(
      lastReset.year,
      lastReset.month,
      lastReset.day,
    );

    if (today.isAfter(lastResetDay)) {
      // A new day has passed — reset dailies
      ref.read(dailyProvider.notifier).resetDailies();
      box.put(_lastResetKey, today.toIso8601String());
    }
  }
}
