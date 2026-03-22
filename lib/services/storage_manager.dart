import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Менеджер файловой системы приложения.
///
/// Отвечает за генерацию и создание изолированных директорий для базы данных
/// и проверок (отчетов, фотографий).
class StorageManager {
  // Синглтон
  StorageManager._privateConstructor();
  static final StorageManager instance = StorageManager._privateConstructor();

  String? _documentsPath;

  /// Инициализирует менеджер, кэшируя путь к корневой папке документов.
  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _documentsPath = dir.path;
  }

  /// Корневой путь документов приложения.
  String get rootPath {
    if (_documentsPath == null) {
      throw Exception('StorageManager не инициализирован. Вызовите init() перед использованием.');
    }
    return _documentsPath!;
  }

  /// Возвращает путь к папке базы данных Hive и создает её, если она не существует.
  Future<String> getDatabaseDirectory() async {
    final path = '$rootPath/database';
    await Directory(path).create(recursive: true);
    return path;
  }

  /// Возвращает путь к главной папке конкретной проверки и создает её.
  Future<String> getChecklistDirectory(int checklistInstanceId) async {
    final path = '$rootPath/reports/checklist_$checklistInstanceId';
    await Directory(path).create(recursive: true);
    return path;
  }

  /// Возвращает путь к папке с фотографиями конкретной проверки и создает её.
  Future<String> getChecklistPhotosDirectory(int checklistInstanceId) async {
    final path = await getChecklistDirectory(checklistInstanceId);
    final photosPath = '$path/photos';
    await Directory(photosPath).create(recursive: true);
    return photosPath;
  }

  /// Очищает все файлы проверки (Garbage Collector).
  Future<void> deleteChecklistDirectory(int checklistInstanceId) async {
    final path = '$rootPath/reports/checklist_$checklistInstanceId';
    final directory = Directory(path);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  }

  /// Конвертирует абсолютный путь (из кэша/галереи) в локальный путь папки проверки 
  /// и КОПИРУЕТ файл туда. Возвращает только имя файла (относительный путь).
  Future<String> saveChecklistPhoto(int checklistInstanceId, String sourceFilePath) async {
    final sourceFile = File(sourceFilePath);
    if (!await sourceFile.exists()) {
      throw Exception('Исходный файл фотографии не найден: $sourceFilePath');
    }

    final String fileName = sourceFilePath.split(Platform.pathSeparator).last;
    final String targetDir = await getChecklistPhotosDirectory(checklistInstanceId);
    final String targetFilePath = '$targetDir/$fileName';

    await sourceFile.copy(targetFilePath);
    return fileName; // Сохраняем в БД только имя файла
  }

  /// Восстанавливает абсолютный путь к фото по его имени и ID проверки.
  Future<String?> getAbsolutePhotoPath(int checklistInstanceId, String? fileName) async {
    if (fileName == null || fileName.isEmpty) return null;
    final photosDir = await getChecklistPhotosDirectory(checklistInstanceId);
    return '$photosDir/$fileName';
  }
}
