class EconomySystem {
  /// Base gold earned per task completion.
  static const int baseTaskGold = 10;

  /// Gold rewarded on level-up.
  static const int levelUpGoldReward = 50;

  /// Calculates total gold after completing a task.
  static int addTaskGold(int currentGold) {
    return currentGold + baseTaskGold;
  }

  /// Calculates total gold after leveling up.
  static int addLevelUpGold(int currentGold) {
    return currentGold + levelUpGoldReward;
  }
}
