import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/character_class.dart';
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
  CharacterClass? _selected;

  @override
  void initState() {
    super.initState();
    // Pre-select current class if changing
    final player = ref.read(playerProvider);
    if (player.hasSelectedClass) {
      _selected = player.characterClass;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark ? AppTheme.darkPrimary : AppTheme.lightPrimary;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isFirstTime ? 'Choose Your Class' : 'Change Class'),
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
                  ? 'Your class determines your XP bonus.\nChoose wisely, Shadow Monarch.'
                  : 'Select a new class to change your XP bonus.',
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),

            // Class cards
            ...CharacterClass.values.map(
              (cls) => _ClassCard(
                characterClass: cls,
                isSelected: _selected == cls,
                onTap: () => setState(() => _selected = cls),
              ),
            ),

            const Spacer(),

            // Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selected == null ? null : _confirmSelection,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: primaryColor,
                  foregroundColor: isDark
                      ? AppTheme.darkBackground
                      : AppTheme.lightCard,
                ),
                child: Text(
                  widget.isFirstTime ? 'Begin Your Journey' : 'Confirm Change',
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

  void _confirmSelection() {
    if (_selected == null) return;
    ref.read(playerProvider.notifier).setCharacterClass(_selected!);

    if (widget.isFirstTime) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const MainScreen()));
    } else {
      Navigator.of(context).pop();
    }
  }
}

// ── Class Card ──────────────────────────────────────────────
class _ClassCard extends StatelessWidget {
  final CharacterClass characterClass;
  final bool isSelected;
  final VoidCallback onTap;

  const _ClassCard({
    required this.characterClass,
    required this.isSelected,
    required this.onTap,
  });

  Color get _classColor {
    switch (characterClass) {
      case CharacterClass.warrior:
        return Colors.orange;
      case CharacterClass.mage:
        return Colors.blue;
      case CharacterClass.rogue:
        return Colors.purple;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? _classColor.withValues(alpha: 0.15)
              : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? _classColor
                : Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Class icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _classColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: _classColor.withValues(alpha: 0.4)),
              ),
              child: Center(
                child: Text(
                  characterClass.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Class info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    characterClass.displayName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? _classColor : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    characterClass.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: _classColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _classColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      characterClass.bonusDescription,
                      style: TextStyle(
                        fontSize: 11,
                        color: _classColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Selected indicator
            if (isSelected)
              Icon(Icons.check_circle, color: _classColor, size: 24),
          ],
        ),
      ),
    );
  }
}
