import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../rewards/reward_provider.dart';
import '../player/player_provider.dart';
import '../core/app_theme.dart';

class RewardScreen extends ConsumerWidget {
  const RewardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewards = ref.watch(rewardProvider);
    final player = ref.watch(playerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    final goldColor = isDark ? AppTheme.darkGold : AppTheme.lightGold;

    return Scaffold(
      appBar: AppBar(title: const Text('Reward Shop'), centerTitle: true),
      body: Column(
        children: [
          // ── Gold Balance Banner ───────────────────────
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: goldColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: goldColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Icon(Icons.monetization_on, color: goldColor, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Your Gold',
                  style: TextStyle(fontSize: 16, color: goldColor),
                ),
                const Spacer(),
                Text(
                  '${player.gold}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: goldColor,
                  ),
                ),
              ],
            ),
          ),

          // ── Rewards List ──────────────────────────────
          Expanded(
            child: rewards.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          size: 64,
                          color: primaryColor.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No rewards yet.\nTap + to add a reward.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: rewards.length,
                    itemBuilder: (context, index) {
                      final reward = rewards[index];
                      final canAfford = player.gold >= reward.goldCost;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(
                            color: canAfford
                                ? goldColor.withValues(alpha: 0.4)
                                : Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.1),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: goldColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: goldColor.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Icon(
                              Icons.card_giftcard,
                              color: canAfford
                                  ? goldColor
                                  : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.3),
                              size: 24,
                            ),
                          ),
                          title: Text(
                            reward.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: canAfford
                                  ? null
                                  : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                            ),
                          ),
                          subtitle: Row(
                            children: [
                              Icon(
                                Icons.monetization_on,
                                size: 14,
                                color: canAfford ? goldColor : Colors.redAccent,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${reward.goldCost} Gold',
                                style: TextStyle(
                                  color: canAfford
                                      ? goldColor
                                      : Colors.redAccent,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (!canAfford) ...[
                                const SizedBox(width: 6),
                                const Text(
                                  '— Not enough gold',
                                  style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Redeem button — always has onPressed
                              // canAfford check happens inside
                              GestureDetector(
                                onTap: () => _redeemReward(
                                  context,
                                  ref,
                                  reward.id,
                                  reward.title,
                                  reward.goldCost,
                                  canAfford,
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: canAfford
                                        ? Colors.green
                                        : Colors.redAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    canAfford ? 'Redeem' : 'Need Gold',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              // Delete button
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                  size: 20,
                                ),
                                onPressed: () => ref
                                    .read(rewardProvider.notifier)
                                    .deleteReward(reward.id),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddRewardDialog(context, ref),
        icon: Icon(
          Icons.add,
          color: isDark ? AppTheme.darkBackground : AppTheme.lightCard,
        ),
        label: Text(
          'Add Reward',
          style: TextStyle(
            color: isDark ? AppTheme.darkBackground : AppTheme.lightCard,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
      ),
    );
  }

  void _redeemReward(
    BuildContext context,
    WidgetRef ref,
    String id,
    String title,
    int goldCost,
    bool canAfford,
  ) {
    if (!canAfford) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.cancel, color: Colors.redAccent),
              SizedBox(width: 8),
              Text(
                'Not enough gold!',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade800,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    ref.read(rewardProvider.notifier).redeemReward(id);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Redeemed "$title" for $goldCost gold!',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddRewardDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final goldController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Reward'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Reward name (e.g. Watch a movie)',
              ),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: goldController,
              decoration: const InputDecoration(
                hintText: 'Gold cost (e.g. 50)',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              final gold = int.tryParse(goldController.text.trim());
              if (title.isNotEmpty && gold != null && gold > 0) {
                ref.read(rewardProvider.notifier).addReward(title, gold);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
