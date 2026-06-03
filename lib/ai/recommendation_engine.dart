import 'dart:convert';
import 'package:http/http.dart' as http;
import '../player/player_model.dart';
import '../core/analytics_model.dart';

class RecommendationEngine {
  static const String _apiUrl = 'https://api.anthropic.com/v1/messages';
  static const String _model = 'claude-sonnet-4-20250514';

  /// Generates personalized recommendations based on player data.
  /// Returns a list of recommendation strings.
  static Future<List<String>> getRecommendations({
    required PlayerModel player,
    required AnalyticsModel analytics,
    required int habitsCompletedToday,
    required int dailiesCompletedToday,
    required int todosCompletedToday,
  }) async {
    final prompt = _buildPrompt(
      player: player,
      analytics: analytics,
      habitsCompletedToday: habitsCompletedToday,
      dailiesCompletedToday: dailiesCompletedToday,
      todosCompletedToday: todosCompletedToday,
    );

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': _model,
          'max_tokens': 500,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['content'][0]['text'] as String;
        return _parseRecommendations(text);
      } else {
        return _fallbackRecommendations(
          player: player,
          analytics: analytics,
          habitsToday: habitsCompletedToday,
          dailiestoday: dailiesCompletedToday,
          todosToday: todosCompletedToday,
        );
      }
    } catch (e) {
      return _fallbackRecommendations(
        player: player,
        analytics: analytics,
        habitsToday: habitsCompletedToday,
        dailiestoday: dailiesCompletedToday,
        todosToday: todosCompletedToday,
      );
    }
  }

  static String _buildPrompt({
    required PlayerModel player,
    required AnalyticsModel analytics,
    required int habitsCompletedToday,
    required int dailiesCompletedToday,
    required int todosCompletedToday,
  }) {
    return '''
You are an AI coach for a gamified productivity app called Life RPG.
The player has the following stats:

PLAYER STATS:
- Level: ${player.level}
- XP: ${player.xp} / ${player.xpToNextLevel}
- Health: ${player.health} / 100
- Gold: ${player.gold}

AFFINITY POINTS (out of 10):
- Warrior (Habits): ${player.warriorPoints} pts → +${player.warriorPoints * 5}% XP from habits
- Mage (Dailies): ${player.magePoints} pts → +${player.magePoints * 5}% XP from dailies
- Rogue (To-Dos): ${player.roguePoints} pts → +${player.roguePoints * 5}% XP from todos

TODAY'S ACTIVITY:
- Habits completed: $habitsCompletedToday
- Dailies completed: $dailiesCompletedToday
- To-Dos completed: $todosCompletedToday

ALL TIME STATS:
- Total habits completed: ${analytics.totalHabitsCompleted}
- Total dailies completed: ${analytics.totalDailiesCompleted}
- Total todos completed: ${analytics.totalTodosCompleted}
- Total XP earned: ${analytics.totalXpEarned}
- Best streak: ${analytics.bestStreak} days

Based on this data, give exactly 3 short personalized recommendations to help this player improve.
Each recommendation must:
- Be 1-2 sentences maximum
- Be specific to their stats
- Be motivating and actionable
- Reference their affinity specialization where relevant

Respond ONLY with a JSON array of 3 strings. No preamble, no explanation.
Example format:
["recommendation 1", "recommendation 2", "recommendation 3"]
''';
  }

  static List<String> _parseRecommendations(String text) {
    try {
      final clean = text.trim();
      final parsed = jsonDecode(clean) as List;
      return parsed.cast<String>();
    } catch (e) {
      // If parsing fails return split by newline
      return text
          .split('\n')
          .where((l) => l.trim().isNotEmpty)
          .take(3)
          .toList();
    }
  }

  /// Local fallback recommendations when API is unavailable
  static List<String> _fallbackRecommendations({
    required PlayerModel player,
    required AnalyticsModel analytics,
    required int habitsToday,
    required int dailiestoday,
    required int todosToday,
  }) {
    final recommendations = <String>[];

    // Health check
    if (player.health < 50) {
      recommendations.add(
        'Your health is critically low at ${player.health} HP. Complete your dailies today to avoid further damage.',
      );
    } else if (player.health < 75) {
      recommendations.add(
        'Your health is at ${player.health} HP. Stay consistent with dailies to keep it up.',
      );
    }

    // XP close to level up
    final xpNeeded = player.xpToNextLevel - player.xp;
    if (xpNeeded <= 50) {
      recommendations.add(
        'You are only $xpNeeded XP away from Level ${player.level + 1}. Push through!',
      );
    }

    // Affinity specific
    if (player.warriorPoints >= 6 && habitsToday == 0) {
      recommendations.add(
        'Your Warrior affinity is strong but no habits completed today. Each habit gives you +${player.warriorPoints * 5}% bonus XP.',
      );
    } else if (player.magePoints >= 6 && dailiestoday == 0) {
      recommendations.add(
        'Your Mage affinity is strong but no dailies completed today. Each daily gives you +${player.magePoints * 5}% bonus XP.',
      );
    } else if (player.roguePoints >= 6 && todosToday == 0) {
      recommendations.add(
        'Your Rogue affinity is strong but no todos completed today. Each todo gives you +${player.roguePoints * 5}% bonus XP.',
      );
    }

    // Best streak motivation
    if (analytics.bestStreak > 0) {
      recommendations.add(
        'Your best streak is ${analytics.bestStreak} days. Keep your dailies going to beat it!',
      );
    }

    // General fallback if not enough
    if (recommendations.length < 3) {
      recommendations.add(
        'Complete tasks daily to build momentum and level up faster.',
      );
    }

    return recommendations.take(3).toList();
  }
}
