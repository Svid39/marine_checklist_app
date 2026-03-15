import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../main.dart';
import '../models/checklist_template.dart';

/// Утилитарный класс для первоначального заполнения базы данных из JSON-файлов.
///
/// Отвечает за считывание предустановленных чек-листов из ассетов приложения
/// и сохранение их в локальную базу данных Hive при первом запуске.
class DatabaseSeeder {
  /// Проверяет, пуст ли ящик с шаблонами, и если да, то заполняет его
  /// данными из всех .json файлов, найденных в `assets/checklists/`.
  Future<void> seedInitialTemplates() async {
    try {
      final templatesBox = Hive.box<ChecklistTemplate>(templatesBoxName);

      // Заполняем базу только если она абсолютно пуста.
      if (templatesBox.isEmpty) {
        // 1. Используем современный и безопасный метод загрузки манифеста (работает и в Debug, и в Release)
        final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);

        // 2. Получаем список всех путей и фильтруем только нужные JSON-файлы
        final checklistPaths = manifest.listAssets()
            .where((String key) => key.startsWith('assets/checklists/') && key.endsWith('.json'))
            .toList();

        int keyCounter = 0;
        for (final path in checklistPaths) {
          // 3. Читаем каждый JSON-файл как строку.
          final jsonString = await rootBundle.loadString(path);
          final Map<String, dynamic> jsonMap = json.decode(jsonString);

          // 4. Используем наш конструктор .fromJson для создания Dart-объекта.
          final template = ChecklistTemplate.fromJson(jsonMap);

          // 5. Сохраняем готовый объект в Hive с уникальным ключом.
          await templatesBox.put(keyCounter++, template);
        }
      }
    } catch (e) {
      // В случае ошибки выводим ее в консоль только в режиме отладки.
      if (kDebugMode) {
        print('Ошибка при заполнении базы данных из JSON-файлов: $e');
      }
    }
  }
}