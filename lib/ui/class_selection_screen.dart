import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/app_theme.dart';
import '../player/player_provider.dart';
import 'main_screen.dart';

class ClassSelectionScreen extends ConsumerStatefulWidget {
  final bool isFirstTime;

  const ClassSelectionScreen({super.key, this.isFirstTime = true});

  @override
  ConsumerState<ClassSelectionScreen> createState() =>
      _ClassSelectionScreenState();
}

class _ClassSelectionScreenState extends ConsumerState<ClassSelectionScreen> {
  int _warrior = 0;
  int _mage = 0;
  int _rogue = 0;

  static const int _totalPool = 10;

  int get _spent => _warrior + _mage + _rogue;
  int get _remaining => _totalPool - _spent;

  @override
  void initState() {
    super.initState();
    // Pre-fill current allocation when changing
    final player = ref.read(playerProvider);
    if (player.hasConfiguredAffinities) {
      _warrior = player.warriorPoints;
      _mage = player.magePoints;
      _rogue = player.roguePoints;
    }
  }

  void _adjust(String cls, int delta) {
    setState(() {
      switch (cls) {
        case 'warrior':
          final next = (_warrior + delta).clamp(0, 10);
          if (delta > 0 && _remaining <= 0) return;
          _warrior = next;
        case 'mage':
          final next = (_mage + delta).clamp(0, 10);
          if (delta > 0 && _remaining <= 0) return;
          _mage = next;
        case 'rogue':
          final next = (_rogue + delta).clamp(0, 10);
          if (delta > 0 && _remaining <= 0) return;
          _rogue = next;
      }
    });
  }

  void _confirm() {
    if (_spent != _totalPool) return;
    ref
        .read(playerProvider.notifier)
        .setAffinityPoints(warrior: _warrior, mage: _mage, rogue: _rogue);
    if (widget.isFirstTime) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    final ready = _spent == _totalPool;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isFirstTime ? 'Choose Your Affinities' : 'Change Affinities',
        ),
        centerTitle: true,
        automaticallyImplyLeading: !widget.isFirstTime,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isFirstTime
                  ? 'Distribute 10 affinity points across your three paths.\nEach point grants +5% XP for that task type.'
                  : 'Redistribute your 10 affinity points.',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),

            const SizedBox(height: 16),

            // ── Remaining points pill ──────────────────────
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: ready
                      ? primaryColor.withValues(alpha: 0.15)
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: ready
                        ? primaryColor
                        : Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  ready
                      ? '✓ All 10 points assigned'
                      : '$_remaining point${_remaining == 1 ? '' : 's'} remaining',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ready
                        ? primaryColor
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Affinity cards ─────────────────────────────
            _AffinityCard(
              emoji: '⚔️',
              label: 'Warrior',
              sublabel: 'Habits',
              description: 'Each point = +5% XP from Habits',
              color: Colors.orange,
              points: _warrior,
              remaining: _remaining,
              onAdjust: (d) => _adjust('warrior', d),
            ),
            const SizedBox(height: 12),
            _AffinityCard(
              emoji: '🔮',
              label: 'Mage',
              sublabel: 'Dailies',
              description: 'Each point = +5% XP from Dailies',
              color: Colors.blue,
              points: _mage,
              remaining: _remaining,
              onAdjust: (d) => _adjust('mage', d),
            ),
            const SizedBox(height: 12),
            _AffinityCard(
              emoji: '🗡️',
              label: 'Rogue',
              sublabel: 'To-Dos',
              description: 'Each point = +5% XP from To-Dos',
              color: Colors.purple,
              points: _rogue,
              remaining: _remaining,
              onAdjust: (d) => _adjust('rogue', d),
            ),

            const Spacer(),

            // ── Confirm button ─────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ready ? _confirm : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: primaryColor,
                  foregroundColor: isDark
                      ? AppTheme.darkBackground
                      : AppTheme.lightCard,
                  disabledBackgroundColor: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.12),
                ),
                child: Text(
                  widget.isFirstTime ? 'Begin Your Journey' : 'Confirm Changes',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ── Affinity Card ────────────────────────────────────────────
class _AffinityCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String sublabel;
  final String description;
  final Color color;
  final int points;
  final int remaining;
  final void Function(int delta) onAdjust;

  const _AffinityCard({
    required this.emoji,
    required this.label,
    required this.sublabel,
    required this.description,
    required this.color,
    required this.points,
    required this.remaining,
    required this.onAdjust,
  });

  @override
  Widget build(BuildContext context) {
    final bonus = points * 5;
    final canAdd = remaining > 0;
    final canRemove = points > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: points > 0
            ? color.withValues(alpha: 0.1)
            : Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: points > 0
              ? color
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
          width: points > 0 ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: color.withValues(alpha: 0.4)),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 12),

          // Labels + progress bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: points > 0 ? color : null,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        sublabel,
                        style: TextStyle(
                          fontSize: 10,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 6),
                // Point pip track
                Row(
                  children: List.generate(10, (i) {
                    final filled = i < points;
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        height: 6,
                        decoration: BoxDecoration(
                          color: filled ? color : color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Controls
          Column(
            children: [
              Text(
                '+$bonus%',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: points > 0
                      ? color
                      : Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _PipButton(
                    icon: Icons.remove,
                    enabled: canRemove,
                    color: color,
                    onTap: () => onAdjust(-1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '$points',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _PipButton(
                    icon: Icons.add,
                    enabled: canAdd,
                    color: color,
                    onTap: () => onAdjust(1),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Pip Button ───────────────────────────────────────────────
class _PipButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final Color color;
  final VoidCallback onTap;

  const _PipButton({
    required this.icon,
    required this.enabled,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: enabled
              ? color.withValues(alpha: 0.15)
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.05),
          shape: BoxShape.circle,
          border: Border.all(
            color: enabled
                ? color.withValues(alpha: 0.5)
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: enabled
              ? color
              : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.25),
        ),
      ),
    );
  }
}
