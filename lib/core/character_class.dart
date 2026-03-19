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
        return 'Masters of discipline and physical strength. Gain +50% XP from Habits.';
      case CharacterClass.mage:
        return 'Seekers of knowledge and mental growth. Gain +50% XP from Dailies.';
      case CharacterClass.rogue:
        return 'Experts of consistency and precision. Gain +50% XP from To-Dos.';
    }
  }

  String get bonusDescription {
    switch (this) {
      case CharacterClass.warrior:
        return '+50% XP from Habits';
      case CharacterClass.mage:
        return '+50% XP from Dailies';
      case CharacterClass.rogue:
        return '+50% XP from To-Dos';
    }
  }

  /// XP multiplier for habits
  double get habitMultiplier => this == CharacterClass.warrior ? 1.5 : 1.0;

  /// XP multiplier for dailies
  double get dailyMultiplier => this == CharacterClass.mage ? 1.5 : 1.0;

  /// XP multiplier for todos
  double get todoMultiplier => this == CharacterClass.rogue ? 1.5 : 1.0;
}
