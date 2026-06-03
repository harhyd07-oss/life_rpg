import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../player/player_provider.dart';
import '../core/analytics_provider.dart';
import '../tasks/providers/habit_provider.dart';
import '../tasks/providers/daily_provider.dart';
import '../tasks/providers/todo_provider.dart';
import 'recommendation_engine.dart';

class RecommendationState {
  final List<String> recommendations;
  final bool isLoading;
  final bool hasError;

  const RecommendationState({
    this.recommendations = const [],
    this.isLoading = false,
    this.hasError = false,
  });

  RecommendationState copyWith({
    List<String>? recommendations,
    bool? isLoading,
    bool? hasError,
  }) {
    return RecommendationState(
      recommendations: recommendations ?? this.recommendations,
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
    );
  }
}

class RecommendationNotifier extends StateNotifier<RecommendationState> {
  RecommendationNotifier(this.ref) : super(const RecommendationState());

  final Ref ref;

  Future<void> fetchRecommendations() async {
    state = state.copyWith(isLoading: true, hasError: false);

    final player = ref.read(playerProvider);
    final analytics = ref.read(analyticsProvider);
    final habits = ref.read(habitProvider);
    final dailies = ref.read(dailyProvider);
    final todos = ref.read(todoProvider);

    final habitsToday = habits.where((h) => h.completed).length;
    final dailiestoday = dailies.where((d) => d.wasCompletedToday).length;
    final todosToday = todos.length;

    try {
      final recommendations = await RecommendationEngine.getRecommendations(
        player: player,
        analytics: analytics,
        habitsCompletedToday: habitsToday,
        dailiesCompletedToday: dailiestoday,
        todosCompletedToday: todosToday,
      );

      state = state.copyWith(
        recommendations: recommendations,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, hasError: true);
    }
  }
}

final recommendationProvider =
    StateNotifierProvider<RecommendationNotifier, RecommendationState>((ref) {
      return RecommendationNotifier(ref);
    });
