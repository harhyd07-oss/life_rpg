enum CharacterClass { warrior, mage, rogue }

extension CharacterClassExtension on CharacterClass {
  String get displayName {
    switch (this) {
      case CharacterClass.warrior:
        return 'Warrior';
      case CharacterClass.mage:
        return 'Mage';
      case CharacterClass.rogue:
        return 'Rogue';
    }
  }

  String get emoji {
    switch (this) {
      case CharacterClass.warrior:
        return '⚔️';
      case CharacterClass.mage:
        return '🔮';
      case CharacterClass.rogue:
        return '🗡️';
    }
  }

  String get description {
    switch (this) {
      case CharacterClass.warrior:
        return 'Discipline and strength. Each affinity point gives +5% XP from Habits.';
      case CharacterClass.mage:
        return 'Knowledge and growth. Each affinity point gives +5% XP from Dailies.';
      case CharacterClass.rogue:
        return 'Precision and focus. Each affinity point gives +5% XP from To-Dos.';
    }
  }

  /// Returns the XP multiplier for this class given how many affinity points
  /// are assigned to it. 0 pts = 1.0x, 10 pts = 1.5x, linear in between.
  double multiplierForPoints(int points) {
    final clamped = points.clamp(0, 10);
    return 1.0 + (clamped / 10) * 0.5;
  }

  /// Convenience: bonus percentage string for UI display
  String bonusDescriptionForPoints(int points) {
    final percent = (points * 5).clamp(0, 50);
    switch (this) {
      case CharacterClass.warrior:
        return '+$percent% XP from Habits';
      case CharacterClass.mage:
        return '+$percent% XP from Dailies';
      case CharacterClass.rogue:
        return '+$percent% XP from To-Dos';
    }
  }
}
