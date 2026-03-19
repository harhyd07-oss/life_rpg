import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'player_model.dart';
import '../core/xp_system.dart';
import '../core/level_system.dart';
import '../core/economy_system.dart';
import '../core/character_class.dart';

class PlayerNotifier extends StateNotifier<PlayerModel> {
  PlayerNotifier() : super(PlayerModel()) {
    Future.microtask(() => _loadFromHive());
  }

  void _loadFromHive() {
    final box = Hive.box<PlayerModel>('playerBox');
    final saved = box.get('player');
    if (saved != null) state = saved;
  }

  void _save() {
    final box = Hive.box<PlayerModel>('playerBox');
    box.put('player', state);
  }

  void setCharacterClass(CharacterClass characterClass) {
    state = state.copyWith(characterClassIndex: characterClass.index);
    _save();
  }

  void addXp(int amount) {
    int newXp = state.xp + amount;
    int newLevel = state.level;
    int newGold = state.gold;
    int newHealth = state.health;

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
    _save();
  }

  void addGold(int amount) {
    state = state.copyWith(gold: state.gold + amount);
    _save();
  }

  void spendGold(int amount) {
    final newGold = (state.gold - amount).clamp(0, 999999);
    state = state.copyWith(gold: newGold);
    _save();
  }

  void takeDamage(int amount) {
    final newHealth = (state.health - amount).clamp(0, 100);
    state = state.copyWith(health: newHealth);
    _save();
  }
}

final playerProvider = StateNotifierProvider<PlayerNotifier, PlayerModel>((
  ref,
) {
  return PlayerNotifier();
});
