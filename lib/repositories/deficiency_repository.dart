import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../main.dart';
import '../models/deficiency.dart';

/// Провайдер для получения доступа к репозиторию из UI
final deficiencyRepositoryProvider = Provider<DeficiencyRepository>((ref) {
  return DeficiencyRepository();
});

class DeficiencyRepository {
  // Получаем ссылку на наш "ящик" с несоответствиями
  Box<Deficiency> get _box => Hive.box<Deficiency>(deficienciesBoxName);

  /// Получить все несоответствия
  List<Deficiency> getAll() {
    return _box.values.toList();
  }

  /// Получить одно несоответствие по ключу
  Deficiency? getById(dynamic key) {
    return _box.get(key);
  }

  /// Добавить новое несоответствие
  Future<void> add(Deficiency deficiency) async {
    await _box.add(deficiency);
  }

  /// Обновить существующее несоответствие
  Future<void> update(dynamic key, Deficiency deficiency) async {
    await _box.put(key, deficiency);
  }

  /// Удалить несоответствие (вместе с привязанным фото!)
  Future<void> delete(dynamic key) async {
    final deficiency = _box.get(key);
    
    // Умная очистка: сначала физически удаляем фото с устройства
    if (deficiency != null && deficiency.photoPath != null && deficiency.photoPath!.isNotEmpty) {
      try {
        final file = File(deficiency.photoPath!);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        // Ошибка удаления файла не должна крашить приложение
        debugPrint('Ошибка при удалении фото несоответствия: $e');
      }
    }

    // Затем удаляем саму запись из базы данных
    await _box.delete(key);
  }
}