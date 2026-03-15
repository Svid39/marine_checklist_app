import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart';
import '../models/checklist_instance.dart';

/// Провайдер для доступа к репозиторию чек-листов
final checklistRepositoryProvider = Provider<ChecklistRepository>((ref) {
  return ChecklistRepository();
});

class ChecklistRepository {
  // Получаем доступ к ящику с сохраненными чек-листами
  Box<ChecklistInstance> get _box => Hive.box<ChecklistInstance>(instancesBoxName);

  /// Получить все сохраненные чек-листы (сортировка по дате по убыванию)
  List<ChecklistInstance> getAllInstances() {
    final instances = _box.values.toList();
    instances.sort((a, b) => b.date.compareTo(a.date)); // Замени date на свое поле
    return instances;
  }

  /// Получить один чек-лист по ключу
  ChecklistInstance? getInstanceById(dynamic key) {
    return _box.get(key);
  }

  /// Сохранить или обновить чек-лист
  Future<void> saveInstance(ChecklistInstance instance) async {
    if (instance.isInBox) {
      await instance.save();
    } else {
      await _box.add(instance);
    }
  }

  /// Удалить чек-лист
  Future<void> deleteInstance(dynamic key) async {
    await _box.delete(key);
    // Примечание: Если в будущем чек-листы будут обрастать своими отдельными 
    // файлами (например, подписями), логику очистки файлов мы добавим прямо сюда.
  }
}