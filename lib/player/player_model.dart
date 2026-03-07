class Player {
  int xp;
  int level;
  int gold;
  int health;

  Player({
    required this.xp,
    required this.level,
    required this.gold,
    required this.health,
  });

  factory Player.initial() {
    return Player(xp: 0, level: 1, gold: 0, health: 50);
  }
}
