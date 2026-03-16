class LevelSystem {
  /// Gold rewarded to the player on level-up.
  static const int goldRewardPerLevel = 50;

  /// Health restored to the player on level-up.
  static const int healthRestoredOnLevelUp = 20;

  /// Max health cap.
  static const int maxHealth = 100;

  /// Returns the new level after leveling up.
  static int applyLevelUp(int currentLevel) {
    return currentLevel + 1;
  }

  /// XP carries over after level-up.
  /// e.g. if you needed 100 XP and had 120, you carry over 20.
  static int carryOverXp(int currentXp, int currentLevel) {
    final required = 100 * currentLevel;
    return currentXp - required;
  }

  /// Calculates new health after level-up, capped at maxHealth.
  static int applyHealthRestore(int currentHealth) {
    return (currentHealth + healthRestoredOnLevelUp).clamp(0, maxHealth);
  }
}
