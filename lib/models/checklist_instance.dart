// Файл: lib/models/checklist_instance.dart

import 'package:hive/hive.dart';
import 'checklist_item_response.dart'; // Убедитесь, что этот файл существует и модель ChecklistItemResponse определена корректно
import 'enums.dart'; // Убедитесь, что этот файл существует и Enum'ы определены корректно

part 'checklist_instance.g.dart'; // Для генерации Hive

@HiveType(typeId: 3) // Убедитесь, что typeId = 3 уникален среди всех @HiveType
class ChecklistInstance extends HiveObject {

  @HiveField(0)
  late int templateId;

  @HiveField(1)
  String? shipName;

  @HiveField(2)
  late DateTime date; // Дата начала

  @HiveField(3)
  late ChecklistInstanceStatus status;

  @HiveField(4)
  late List<ChecklistItemResponse> responses; // Список ответов на пункты

  @HiveField(5)
  DateTime? completionDate; // Дата завершения (необязательное)

  @HiveField(6)
  String? port; // Порт проведения проверки

  @HiveField(7)
  String? captainNameOnCheck; // Имя капитана на момент проверки

  @HiveField(8)
  String? inspectorName; // Имя проверяющего

  ChecklistInstance({
    required this.templateId,
    this.shipName,
    required this.date,
    this.status = ChecklistInstanceStatus.inProgress,
    this.responses = const [], // Инициализируем пустым списком
    this.completionDate,
    this.port,
    this.captainNameOnCheck,
    this.inspectorName,
  });
}