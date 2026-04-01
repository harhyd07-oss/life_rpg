import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'player/player_model.dart';
import 'tasks/models/habit_model.dart';
import 'tasks/models/daily_model.dart';
import 'tasks/models/todo_model.dart';
import 'rewards/reward_model.dart';
import 'core/analytics_model.dart';
import 'core/app_theme.dart';
import 'core/theme_provider.dart';
import 'ui/main_screen.dart';
import 'ui/class_selection_screen.dart';
import 'player/player_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(PlayerModelAdapter());
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(DailyAdapter());
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(RewardAdapter());
  Hive.registerAdapter(AnalyticsModelAdapter());

  await Hive.openBox<PlayerModel>('playerBox');
  await Hive.openBox<Habit>('habitBox');
  await Hive.openBox<Daily>('dailyBox');
  await Hive.openBox<Todo>('todoBox');
  await Hive.openBox<Reward>('rewardBox');
  await Hive.openBox<AnalyticsModel>('analyticsBox');
  await Hive.openBox('settingsBox');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final player = ref.watch(playerProvider);

    return MaterialApp(
      title: 'Life RPG',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: player.hasConfiguredAffinities
          ? const MainScreen()
          : const ClassSelectionScreen(isFirstTime: true),
    );
  }
}
