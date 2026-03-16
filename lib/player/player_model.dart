import '../core/xp_system.dart';

class PlayerModel {
  final int xp;
  final int level;
  final int gold;
  final int health;

  const PlayerModel({
    this.xp = 0,
    this.level = 1,
    this.gold = 0,
    this.health = 100,
  });

  /// How much XP is needed to reach next level.
  int get xpToNextLevel => XpSystem.xpRequiredForLevel(level);

  /// Progress as a value between 0.0 and 1.0 (useful for progress bars).
  double get xpProgress => (xp / xpToNextLevel).clamp(0.0, 1.0);

  PlayerModel copyWith({int? xp, int? level, int? gold, int? health}) {
    return PlayerModel(
      xp: xp ?? this.xp,
      level: level ?? this.level,
      gold: gold ?? this.gold,
      health: health ?? this.health,
    );
  }
}
