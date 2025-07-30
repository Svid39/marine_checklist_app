 import 'package:hive/hive.dart'; // Импорт Hive
import 'enums.dart';

part 'deficiency.g.dart'; // Оставляем для Hive

@HiveType(typeId: 5) // Уникальный ID=5
class Deficiency extends HiveObject { // Наследуем HiveObject

  // @Id() - Убираем Isar ID
  // @Index() - Убираем Isar Index

  @HiveField(0) // Номер поля 0
  late String description; // Описание

  @HiveField(1) // Номер поля 1
  int? instanceId; // ID связанного ChecklistInstance (необязательно)

  @HiveField(2) // Номер поля 2
  int? checklistItemId; // ID связанного пункта (необязательно)

  @HiveField(3) // Номер поля 3
  late DeficiencyStatus status; // Статус несоответствия

  @HiveField(4) // Номер поля 4
  String? assignedTo; // Кому поручено

  @HiveField(5) // Номер поля 5
  DateTime? dueDate; // Срок устранения

  @HiveField(6) // Номер поля 6
  String? correctiveActions; // Что сделано

  @HiveField(7) // Номер поля 7
  DateTime? resolutionDate; // Дата устранения

  @HiveField(8) // Номер поля 8
  String? photoPath; // Путь к фото

  // Конструктор оставляем как есть
  Deficiency({
    this.description = '',
    this.instanceId,
    this.checklistItemId,
    this.status = DeficiencyStatus.open,
    this.assignedTo,
    this.dueDate,
    this.correctiveActions,
    this.resolutionDate,
    this.photoPath,
  });
}