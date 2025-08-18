// checklist_item.dart
// marine_checklist_app/lib/models/checklist_item.dart
import 'package:hive/hive.dart'; // Импорт Hive
import 'enums.dart';

part 'checklist_item.g.dart'; // Оставляем для Hive

@HiveType(typeId: 2) // Уникальный ID=2
class ChecklistItem {

  @HiveField(0) // Номер поля 0
  late String text;

  @HiveField(1) // Номер поля 1
  String? details;

  @HiveField(2) // Номер поля 2
  late int order;

  @HiveField(3) // Номер поля 3
  late ResponseType responseType;

  @HiveField(4) // Номер поля 4
  String? regulationRef;

  @HiveField(5) // Номер поля 4
  String? section;

  ChecklistItem({
    this.text = '',
    this.details,
    this.order = 0,
    this.responseType = ResponseType.okNotOkNA,
    this.regulationRef,
    this.section
  });
}