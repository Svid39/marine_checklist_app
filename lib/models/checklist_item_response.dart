import 'package:hive/hive.dart'; // Импорт Hive
import 'enums.dart';

part 'checklist_item_response.g.dart'; // Оставляем для Hive

@HiveType(typeId: 4) // Уникальный ID=4
class ChecklistItemResponse { // НЕ наследуем HiveObject, т.к. будет внутри ChecklistInstance

  @HiveField(0) // Номер поля 0
  late int itemId; // Связь с ChecklistItem.order

  @HiveField(1) // Номер поля 1
  ItemResponseStatus? status; // Статус OK/NotOK/NA (Hive сохранит индекс enum'а)

  @HiveField(2) // Номер поля 2
  String? textValue; // Текстовый ответ

  @HiveField(3) // Номер поля 3
  double? numberValue; // Числовой ответ

  @HiveField(4) // Номер поля 4
  String? photoPath; // Локальный путь к фото

  @HiveField(5) // Номер поля 5
  String? comment; // Комментарий

  // Конструктор оставляем как есть
  ChecklistItemResponse({
    this.itemId = 0,
    this.status,
    this.textValue,
    this.numberValue,
    this.photoPath,
    this.comment,
  });
}
