import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/reset_service.dart';
import 'tasks_screen.dart';
import 'profile_screen.dart';
import 'reward_screen.dart';
import 'package:hive/hive.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    TasksScreen(),
    ProfileScreen(),
    RewardScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Check and reset dailies on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ResetService.checkAndReset(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.store_outlined),
            selectedIcon: Icon(Icons.store),
            label: 'Rewards',
          ),
        ],
      ),
      // Add this temporarily to test reset
      // Remove after testing
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final box = Hive.box('settingsBox');
          // Set last reset to yesterday to simulate a new day
          final yesterday = DateTime.now().subtract(const Duration(days: 1));
          box.put('lastResetDate', yesterday.toIso8601String());
          ResetService.checkAndReset(ref);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Daily reset triggered!')),
          );
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
