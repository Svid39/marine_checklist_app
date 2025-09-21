import 'dart:convert';
import 'dart:io';

// Импортируем ваши шаблоны из старого файла
import 'package:marine_checklist_app/data/predefined_templates.dart';
import 'package:marine_checklist_app/models/checklist_template.dart';

void main() async {
  final outputDir = Directory('assets/checklists');
  if (!await outputDir.exists()) {
    await outputDir.create(recursive: true);
  }

  for (final ChecklistTemplate template in allPredefinedTemplates) {
    final jsonMap = template.toJson();
    final jsonString = JsonEncoder.withIndent('  ').convert(jsonMap);
    final fileName = _sanitizeForFilename(template.name);
    final file = File('${outputDir.path}/$fileName.json');
    await file.writeAsString(jsonString);
    stdout.writeln('✅ Создан файл: ${file.path}');
  }

  stdout.writeln('\n🎉 Конвертация завершена!');
}

String _sanitizeForFilename(String input) {
  return input
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), '_')
      .replaceAll(RegExp(r'[^\w-]'), '');
}