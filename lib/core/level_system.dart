int xpForNextLevel(int level) {
  return level * level * 100;
}

bool shouldLevelUp(int currentXp, int level) {
  return currentXp >= xpForNextLevel(level);
}
