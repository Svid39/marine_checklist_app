// ignore_for_file: avoid_print

import 'dart:io';
// запуск script: dart run gather_code.dart
void main() async {
  // Название итогового файла
  final outputFile = File('project_for_ai.txt');
  final sink = outputFile.openWrite();

  // Что собираем: корневые файлы и папки
  final filesToInclude = ['pubspec.yaml'];
  final directoriesToScan = ['lib'];

  print('Начинаю сборку кода...');
  sink.writeln('=== ИСХОДНЫЙ КОД ПРОЕКТА ===\n');

  // 1. Добавляем одиночные файлы (например, pubspec.yaml)
  for (final fileName in filesToInclude) {
    final file = File(fileName);
    if (await file.exists()) {
      sink.writeln('--- Файл: $fileName ---');
      sink.writeln(await file.readAsString());
      sink.writeln('\n');
      print('Добавлен: $fileName');
    }
  }

  // 2. Сканируем папку lib на наличие .dart файлов
  for (final dirName in directoriesToScan) {
    final dir = Directory(dirName);
    if (await dir.exists()) {
      await for (final entity in dir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.dart')) {
          // Исключаем сгенерированные файлы (если они есть), чтобы не тратить лимиты текста
          if (entity.path.endsWith('.g.dart') || entity.path.endsWith('.freezed.dart')) {
            continue;
          }
          
          sink.writeln('--- Файл: ${entity.path} ---');
          sink.writeln(await entity.readAsString());
          sink.writeln('\n');
          print('Добавлен: ${entity.path}');
        }
      }
    } else {
      print('Папка $dirName не найдена.');
    }
  }

  await sink.close();
  print('\nГотово! Код собран в файл: ${outputFile.path}');
}