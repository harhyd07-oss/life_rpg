import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../player/player_provider.dart';
import 'reward_model.dart';

class RewardNotifier extends StateNotifier<List<Reward>> {
  RewardNotifier(this.ref) : super([]) {
    Future.microtask(() => _loadFromHive());
  }

  final Ref ref;

  void _loadFromHive() {
    final box = Hive.box<Reward>('rewardBox');
    state = box.values.toList();
  }

  void _save() {
    final box = Hive.box<Reward>('rewardBox');
    box.clear();
    for (final reward in state) {
      box.put(reward.id, reward);
    }
  }

  void addReward(String title, int goldCost) {
    final newReward = Reward(
      id: DateTime.now().toString(),
      title: title,
      goldCost: goldCost,
      createdAt: DateTime.now(),
    );
    state = [...state, newReward];
    _save();
  }

  void deleteReward(String id) {
    state = state.where((r) => r.id != id).toList();
    _save();
  }

  /// Returns true if redeem succeeded, false if not enough gold.
  bool redeemReward(String id) {
    final player = ref.read(playerProvider.notifier);
    final playerState = ref.read(playerProvider);
    final reward = state.firstWhere((r) => r.id == id);

    if (playerState.gold < reward.goldCost) {
      return false;
    }

    player.spendGold(reward.goldCost);
    return true;
  }
}

final rewardProvider = StateNotifierProvider<RewardNotifier, List<Reward>>((
  ref,
) {
  return RewardNotifier(ref);
});
