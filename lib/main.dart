import 'package:flutter/material.dart';

void main() {
  runApp(const LifeRPGApp());
}

class LifeRPGApp extends StatelessWidget {
  const LifeRPGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Life RPG",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: Center(child: Text("Life RPG", style: TextStyle(fontSize: 30))),
      ),
    );
  }
}
