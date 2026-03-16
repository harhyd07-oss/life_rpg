import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'player_model.dart';
import '../core/xp_system.dart';
import '../core/level_system.dart';
import '../core/economy_system.dart';

class PlayerNotifier extends StateNotifier<PlayerModel> {
  PlayerNotifier() : super(const PlayerModel());

  /// Call this when a task is completed.
  /// Handles XP gain, level-up check, gold reward, and health restore.
  void addXp(int amount) {
    int newXp = state.xp + amount;
    int newLevel = state.level;
    int newGold = state.gold;
    int newHealth = state.health;

    // Loop handles multiple level-ups in one XP gain (edge case).
    while (XpSystem.shouldLevelUp(newXp, newLevel)) {
      newXp = LevelSystem.carryOverXp(newXp, newLevel);
      newLevel = LevelSystem.applyLevelUp(newLevel);
      newGold = EconomySystem.addLevelUpGold(newGold);
      newHealth = LevelSystem.applyHealthRestore(newHealth);
    }

    state = state.copyWith(
      xp: newXp,
      level: newLevel,
      gold: newGold,
      health: newHealth,
    );
  }

  /// Call this when a task grants gold directly.
  void addGold(int amount) {
    state = state.copyWith(gold: state.gold + amount);
  }

  /// Call this to reduce player health (e.g. missed dailies).
  void takeDamage(int amount) {
    final newHealth = (state.health - amount).clamp(0, 100);
    state = state.copyWith(health: newHealth);
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, PlayerModel>((
  ref,
) {
  return PlayerNotifier();
});
