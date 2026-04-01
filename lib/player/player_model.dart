import 'package:hive/hive.dart';
import '../core/xp_system.dart';
import '../core/character_class.dart';

part 'player_model.g.dart';

@HiveType(typeId: 0)
class PlayerModel {
  @HiveField(0)
  final int xp;

  @HiveField(1)
  final int level;

  @HiveField(2)
  final int gold;

  @HiveField(3)
  final int health;

  // Field 4 kept for Hive backward compatibility — no longer used in logic
  @HiveField(4)
  final int legacyClassIndex;

  @HiveField(5)
  final int warriorPoints;

  @HiveField(6)
  final int magePoints;

  @HiveField(7)
  final int roguePoints;

  PlayerModel({
    this.xp = 0,
    this.level = 1,
    this.gold = 0,
    this.health = 100,
    this.legacyClassIndex = -1,
    this.warriorPoints = 0,
    this.magePoints = 0,
    this.roguePoints = 0,
  });

  /// Total points spent — must always equal exactly 10 when setup is complete
  int get totalPoints => warriorPoints + magePoints + roguePoints;

  /// True once the player has distributed all 10 points
  bool get hasConfiguredAffinities => totalPoints == 10;

  /// Alias used by main.dart and selection screen
  bool get hasSelectedClass => hasConfiguredAffinities;

  /// XP multipliers per task type
  double get habitMultiplier =>
      CharacterClass.warrior.multiplierForPoints(warriorPoints);

  double get dailyMultiplier =>
      CharacterClass.mage.multiplierForPoints(magePoints);

  double get todoMultiplier =>
      CharacterClass.rogue.multiplierForPoints(roguePoints);

  int get xpToNextLevel => XpSystem.xpRequiredForLevel(level);
  double get xpProgress => (xp / xpToNextLevel).clamp(0.0, 1.0);

  PlayerModel copyWith({
    int? xp,
    int? level,
    int? gold,
    int? health,
    int? legacyClassIndex,
    int? warriorPoints,
    int? magePoints,
    int? roguePoints,
  }) {
    return PlayerModel(
      xp: xp ?? this.xp,
      level: level ?? this.level,
      gold: gold ?? this.gold,
      health: health ?? this.health,
      legacyClassIndex: legacyClassIndex ?? this.legacyClassIndex,
      warriorPoints: warriorPoints ?? this.warriorPoints,
      magePoints: magePoints ?? this.magePoints,
      roguePoints: roguePoints ?? this.roguePoints,
    );
  }
}
