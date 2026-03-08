import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/dashboard_screen.dart';

void main() {
  runApp(const ProviderScope(child: LifeRPGApp()));
}

class LifeRPGApp extends StatelessWidget {
  const LifeRPGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Life RPG",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const DashboardScreen(),
    );
  }
}
