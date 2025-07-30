// Файл: lib/services/database_seeder.dart

import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart'; // для print() в режиме debug

// Импортируем модели и константы имен ящиков
import '../models/checklist_template.dart';
import '../main.dart'; // Импортируем main.dart, чтобы получить доступ к именам ящиков
// Импортируем файл с данными шаблонов
import '../data/predefined_templates.dart';

class DatabaseSeeder {

  // Асинхронный метод для добавления начальных шаблонов
  Future<void> seedInitialTemplates() async {
    try {
      // Получаем доступ к ящику шаблонов
      final templatesBox = Hive.box<ChecklistTemplate>(templatesBoxName);

      // Проверяем, пуст ли ящик
      if (templatesBox.isEmpty) {
        debugPrint('База данных: Ящик шаблонов пуст. Добавляем предустановленные шаблоны...');

        // Проходим по списку всех предустановленных шаблонов
        for (int i = 0; i < allPredefinedTemplates.length; i++) {
          final template = allPredefinedTemplates[i];
          // Используем индекс как простой уникальный ключ для Hive
          // В реальном приложении ключ может быть другим (например, ID из бэкенда)
          await templatesBox.put(i, template);
          debugPrint('База данных: Шаблон "${template.name}" добавлен с ключом $i.');
        }

        debugPrint('База данных: Предустановленные шаблоны добавлены.');
      } else {
        debugPrint('База данных: Ящик с шаблонами уже содержит данные. Начальное добавление не требуется.');
      }
    } catch (e) {
      // Обработка возможных ошибок при работе с Hive
      debugPrint('База данных: Ошибка при добавлении начальных шаблонов: $e');
      // Здесь можно добавить более сложную логику обработки ошибок
    }
  }

  // Сюда можно добавить другие методы для наполнения базы, если нужно
  // Future<void> seedUserProfileIfEmpty() async { ... }
}