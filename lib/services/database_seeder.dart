import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';

import '../main.dart';
import '../models/checklist_template.dart';

import 'package:flutter/foundation.dart';

/// Утилитарный класс для первоначального заполнения базы данных из JSON-файлов.
class DatabaseSeeder {
  /// Проверяет, пуст ли ящик с шаблонами, и если да, то заполняет его
  /// данными из всех .json файлов, найденных в `assets/checklists/`.
  Future<void> seedInitialTemplates() async {
    try {
      final templatesBox = Hive.box<ChecklistTemplate>(templatesBoxName);

      // Заполняем базу только если она абсолютно пуста.
      if (templatesBox.isEmpty) {
        // 1. Загружаем специальный файл-манифест, который содержит список всех ассетов в приложении.
        final manifestContent =
            await rootBundle.loadString('AssetManifest.json');
        final Map<String, dynamic> manifestMap = json.decode(manifestContent);

        // 2. Находим в этом списке все пути к файлам, которые лежат в нашей папке с чек-листами.
        final checklistPaths = manifestMap.keys
            .where((String key) => key.contains('assets/checklists/'))
            .toList();

        int keyCounter = 0;
        for (final path in checklistPaths) {
          // 3. Читаем каждый JSON-файл как строку.
          final jsonString = await rootBundle.loadString(path);
          final Map<String, dynamic> jsonMap = json.decode(jsonString);

          // 4. Используем наш новый конструктор .fromJson для создания Dart-объекта.
          final template = ChecklistTemplate.fromJson(jsonMap);

          // 5. Сохраняем готовый объект в Hive.
          await templatesBox.put(keyCounter++, template);
        }
      }
    } catch (e) {
      // В случае ошибки выводим ее в консоль.
      if (kDebugMode) {
        print('Ошибка при заполнении базы данных из JSON-файлов: $e');
      }
    }
  }
}
