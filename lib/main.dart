import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'player/player_model.dart';
import 'tasks/models/habit_model.dart';
import 'tasks/models/daily_model.dart';
import 'tasks/models/todo_model.dart';
import 'ui/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(PlayerModelAdapter());
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(DailyAdapter());
  Hive.registerAdapter(TodoAdapter());

  // Open boxes
  await Hive.openBox<PlayerModel>('playerBox');
  await Hive.openBox<Habit>('habitBox');
  await Hive.openBox<Daily>('dailyBox');
  await Hive.openBox<Todo>('todoBox');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life RPG',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
