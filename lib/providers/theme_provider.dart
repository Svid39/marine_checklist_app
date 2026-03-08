import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart';
import '../models/user_profile.dart';
import '../theme/app_themes.dart';

/// Провайдер, за которым будет следить наш интерфейс
final themeProvider = NotifierProvider<ThemeNotifier, AppThemeMode>(() {
  return ThemeNotifier();
});

class ThemeNotifier extends Notifier<AppThemeMode> {
  @override
  AppThemeMode build() {
    // 1. При запуске читаем профиль из Hive
    final profileBox = Hive.box<UserProfile>(userProfileBoxName);
    final profile = profileBox.get(1);

    // 2. Если тема уже была сохранена, восстанавливаем её
    if (profile != null && profile.themePreference != null) {
      return AppThemeMode.values.firstWhere(
        (e) => e.name == profile.themePreference,
        orElse: () => AppThemeMode.standard,
      );
    }
    // По умолчанию возвращаем стандартную "машинную" тему
    return AppThemeMode.standard;
  }

  /// Метод для переключения темы пользователем
  void setTheme(AppThemeMode mode) async {
    state = mode; // Мгновенно обновляем UI

    // Сохраняем выбор в базу данных
    final profileBox = Hive.box<UserProfile>(userProfileBoxName);
    var profile = profileBox.get(1);
    if (profile != null) {
      profile.themePreference = mode.name;
      await profile.save();
    }
  }
}