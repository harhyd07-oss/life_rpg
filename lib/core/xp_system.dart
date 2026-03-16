class XpSystem {
  /// Returns the XP required to level up from [currentLevel].
  /// Formula scales progressively so higher levels require more XP.
  static int xpRequiredForLevel(int currentLevel) {
    return 100 * currentLevel;
  }

  /// Returns remaining XP needed to level up.
  static int xpToNextLevel(int currentXp, int currentLevel) {
    return xpRequiredForLevel(currentLevel) - currentXp;
  }

  /// Checks if the player qualifies for a level-up.
  static bool shouldLevelUp(int currentXp, int currentLevel) {
    return currentXp >= xpRequiredForLevel(currentLevel);
  }
}
