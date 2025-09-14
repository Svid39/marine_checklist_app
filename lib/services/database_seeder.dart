import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import '../data/predefined_templates.dart';
import '../main.dart';
import '../models/checklist_template.dart';

/// Утилитарный класс для первоначального заполнения базы данных.
///
/// Отвечает за добавление предустановленных данных (например, шаблонов чек-листов)
/// при самом первом запуске приложения, чтобы у пользователя был начальный контент.
class DatabaseSeeder {
  /// Проверяет, пуст ли "ящик" с шаблонами, и если да, то заполняет его
  /// предустановленными шаблонами из [allPredefinedTemplates].
  ///
  /// Эта операция выполняется только один раз за всю жизнь приложения на устройстве,
  /// что предотвращает дублирование данных при последующих запусках.
  Future<void> seedInitialTemplates() async {
    try {
      final templatesBox = Hive.box<ChecklistTemplate>(templatesBoxName);

      if (templatesBox.isEmpty) {
        for (int i = 0; i < allPredefinedTemplates.length; i++) {
          final template = allPredefinedTemplates[i];
          // Используем индекс в качестве простого уникального ключа.
          await templatesBox.put(i, template);
        }
      }
    } catch (e) {
      // В релизной версии здесь могла бы быть логика для записи ошибки
      // в сервис аналитики (например, Firebase Crashlytics).
      // В данном случае просто перехватываем ошибку, чтобы не "уронить" приложение.
      if (kDebugMode) {
        print('Ошибка при добавлении начальных шаблонов: $e');
      }
    }
  }
}