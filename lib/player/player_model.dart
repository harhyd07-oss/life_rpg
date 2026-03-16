import 'package:hive/hive.dart';
import '../core/xp_system.dart';

part 'player_model.g.dart';

@HiveType(typeId: 0)
class PlayerModel extends HiveObject {
  @HiveField(0)
  final int xp;

  @HiveField(1)
  final int level;

  @HiveField(2)
  final int gold;

  @HiveField(3)
  final int health;

  PlayerModel({this.xp = 0, this.level = 1, this.gold = 0, this.health = 100});

  int get xpToNextLevel => XpSystem.xpRequiredForLevel(level);
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
