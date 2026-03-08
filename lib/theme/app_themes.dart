import 'package:flutter/material.dart';

class AppThemes {
  // 1. Морская Светлая (для палубы / солнца)
  static final ThemeData marineLight = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF005C97), // Глубокий океанский синий
      brightness: Brightness.light,
      primary: const Color(0xFF005C97),
      secondary: const Color(0xFF00B4DB),
      surface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF005C97),
      foregroundColor: Colors.white,
    ),
    useMaterial3: true,
  );

  // 2. Морская Стандартная (для машинного отделения)
  static final ThemeData marineStandard = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF455A64), // Стальной серо-синий (Blue Grey)
      brightness: Brightness.light,
      primary: const Color(0xFF455A64),
      secondary: const Color(0xFF78909C),
      surface: const Color(0xFFECEFF1), // Чуть сероватый фон для снижения контраста
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF455A64),
      foregroundColor: Colors.white,
    ),
    useMaterial3: true,
  );

  // 3. Морская Темная (Night Mode / мостик)
  static final ThemeData marineDark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0D47A1),
      brightness: Brightness.dark,
      surface: const Color(0xFF121212), // Почти черный для OLED экранов
      primary: const Color(0xFF64B5F6), // Светло-синий для акцентов в темноте
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white70,
    ),
    useMaterial3: true,
  );
}

/// Enum для удобного переключения тем
enum AppThemeMode {
  light,
  standard,
  dark
}