import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/analytics_provider.dart';
import '../player/player_provider.dart';
import '../core/app_theme.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analytics = ref.watch(analyticsProvider);
    final player = ref.watch(playerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;
    final secondaryColor = isDark
        ? AppTheme.darkSecondary
        : AppTheme.lightSecondary;
    final goldColor = isDark ? AppTheme.darkGold : AppTheme.lightGold;

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Total Tasks Card ──────────────────────────
            _SectionTitle(title: 'Overview', color: primaryColor),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Total Tasks',
                    value: '${analytics.totalTasksCompleted}',
                    icon: Icons.task_alt,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Total XP',
                    value: '${analytics.totalXpEarned}',
                    icon: Icons.star,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Best Streak',
                    value: '${analytics.bestStreak} days',
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Current Level',
                    value: '${player.level}',
                    icon: Icons.shield,
                    color: goldColor,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Task Breakdown ────────────────────────────
            _SectionTitle(title: 'Task Breakdown', color: primaryColor),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _BreakdownRow(
                      label: 'Habits',
                      count: analytics.totalHabitsCompleted,
                      total: analytics.totalTasksCompleted,
                      color: primaryColor,
                      icon: Icons.repeat,
                    ),
                    const SizedBox(height: 12),
                    _BreakdownRow(
                      label: 'Dailies',
                      count: analytics.totalDailiesCompleted,
                      total: analytics.totalTasksCompleted,
                      color: secondaryColor,
                      icon: Icons.calendar_today,
                    ),
                    const SizedBox(height: 12),
                    _BreakdownRow(
                      label: 'To-Dos',
                      count: analytics.totalTodosCompleted,
                      total: analytics.totalTasksCompleted,
                      color: goldColor,
                      icon: Icons.check_box_outline_blank,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── XP Progress ───────────────────────────────
            _SectionTitle(title: 'XP Progress', color: primaryColor),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Level ${player.level}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        Text(
                          '${player.xp} / ${player.xpToNextLevel} XP',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: player.xpProgress,
                        minHeight: 16,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${((player.xpProgress) * 100).toStringAsFixed(1)}% to next level',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Activity This Week ────────────────────────
            _SectionTitle(title: 'Activity This Week', color: primaryColor),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _WeeklyActivity(
                  dailyCompletions: analytics.dailyCompletions,
                  primaryColor: primaryColor,
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ── Section Title ───────────────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String title;
  final Color color;

  const _SectionTitle({required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: 1.2,
      ),
    );
  }
}

// ── Stat Card ───────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Breakdown Row ───────────────────────────────────────────
class _BreakdownRow extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;
  final IconData icon;

  const _BreakdownRow({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : count / total;

    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(label, style: const TextStyle(fontSize: 13)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ── Weekly Activity ─────────────────────────────────────────
class _WeeklyActivity extends StatelessWidget {
  final Map<String, int> dailyCompletions;
  final Color primaryColor;

  const _WeeklyActivity({
    required this.dailyCompletions,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = List.generate(7, (i) {
      final date = now.subtract(Duration(days: 6 - i));
      final key = '${date.year}-${date.month}-${date.day}';
      final count = dailyCompletions[key] ?? 0;
      return _DayData(date: date, count: count);
    });

    final maxCount = days.map((d) => d.count).reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        SizedBox(
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: days.map((day) {
              final barHeight = maxCount == 0
                  ? 4.0
                  : (day.count / maxCount * 60).clamp(4.0, 60.0);

              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (day.count > 0)
                    Text(
                      '${day.count}',
                      style: TextStyle(
                        fontSize: 10,
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  const SizedBox(height: 2),
                  Container(
                    width: 28,
                    height: barHeight,
                    decoration: BoxDecoration(
                      color: day.count > 0
                          ? primaryColor
                          : primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: days.map((day) {
            final isToday =
                day.date.day == now.day &&
                day.date.month == now.month &&
                day.date.year == now.year;
            return Text(
              _dayLabel(day.date.weekday),
              style: TextStyle(
                fontSize: 11,
                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                color: isToday
                    ? primaryColor
                    : Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _dayLabel(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }
}

class _DayData {
  final DateTime date;
  final int count;
  _DayData({required this.date, required this.count});
}
