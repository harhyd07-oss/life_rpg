import 'package:flutter/material.dart';

class AppTheme {
  // ── Dark Theme Colors (Shadow Monarch) ──────────────────
  static const Color darkBackground = Color(0xFF0A0A0F);
  static const Color darkSurface = Color(0xFF0F0F1A);
  static const Color darkCard = Color(0xFF12121F);
  static const Color darkPrimary = Color(0xFF00D4FF);
  static const Color darkSecondary = Color(0xFF7B2FFF);
  static const Color darkAccent = Color(0xFFE0E8FF);
  static const Color darkGold = Color(0xFFFFB830);
  static const Color darkTextPrimary = Color(0xFFE0E8FF);
  static const Color darkTextSecondary = Color(0xFF6B7FA3);
  static const Color darkXpBar = Color(0xFF00D4FF);
  static const Color darkHpBar = Color(0xFF7B2FFF);

  // ── Light Theme Colors (Monarch's Ascension) ────────────
  static const Color lightBackground = Color(0xFFF0F4FF);
  static const Color lightSurface = Color(0xFFE8EEFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFF1A3FBF);
  static const Color lightSecondary = Color(0xFF5B1FBF);
  static const Color lightAccent = Color(0xFFC8860A);
  static const Color lightGold = Color(0xFFC8860A);
  static const Color lightTextPrimary = Color(0xFF0A0F2E);
  static const Color lightTextSecondary = Color(0xFF3D5080);
  static const Color lightXpBar = Color(0xFF1A3FBF);
  static const Color lightHpBar = Color(0xFF5B1FBF);

  // ── Dark Theme ───────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        surface: darkSurface,
        primary: darkPrimary,
        secondary: darkSecondary,
        onPrimary: darkBackground,
        onSecondary: darkBackground,
        onSurface: darkTextPrimary,
      ),
      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: darkPrimary.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: darkPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: darkPrimary,
        unselectedLabelColor: darkTextSecondary,
        indicatorColor: darkPrimary,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        indicatorColor: darkPrimary.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: darkPrimary);
          }
          return const IconThemeData(color: darkTextSecondary);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: darkPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            );
          }
          return const TextStyle(color: darkTextSecondary, fontSize: 12);
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkPrimary,
        foregroundColor: darkBackground,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: darkTextPrimary),
        bodyMedium: TextStyle(color: darkTextPrimary),
        bodySmall: TextStyle(color: darkTextSecondary),
        titleLarge: TextStyle(color: darkTextPrimary),
        titleMedium: TextStyle(color: darkTextPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        hintStyle: const TextStyle(color: darkTextSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkPrimary.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkPrimary.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: darkPrimary.withValues(alpha: 0.3)),
        ),
      ),
    );
  }

  // ── Light Theme ──────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: const ColorScheme.light(
        surface: lightSurface,
        primary: lightPrimary,
        secondary: lightSecondary,
        onPrimary: lightCard,
        onSecondary: lightCard,
        onSurface: lightTextPrimary,
      ),
      cardTheme: CardThemeData(
        color: lightCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: lightPrimary.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightSurface,
        foregroundColor: lightTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: lightPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      tabBarTheme: const TabBarThemeData(
        labelColor: lightPrimary,
        unselectedLabelColor: lightTextSecondary,
        indicatorColor: lightPrimary,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightSurface,
        indicatorColor: lightPrimary.withValues(alpha: 0.15),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: lightPrimary);
          }
          return const IconThemeData(color: lightTextSecondary);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: lightPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            );
          }
          return const TextStyle(color: lightTextSecondary, fontSize: 12);
        }),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: lightPrimary,
        foregroundColor: lightCard,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: lightTextPrimary),
        bodyMedium: TextStyle(color: lightTextPrimary),
        bodySmall: TextStyle(color: lightTextSecondary),
        titleLarge: TextStyle(color: lightTextPrimary),
        titleMedium: TextStyle(color: lightTextPrimary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        hintStyle: const TextStyle(color: lightTextSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightPrimary.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightPrimary.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: lightPrimary, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: lightCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: lightCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: lightPrimary.withValues(alpha: 0.2)),
        ),
      ),
    );
  }
}
