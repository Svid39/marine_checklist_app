import 'package:hive/hive.dart'; // Импорт Hive
import 'checklist_item.dart'; // Импортируем адаптированный ChecklistItem

part 'checklist_template.g.dart'; // Оставляем для Hive

@HiveType(typeId: 1) // Уникальный ID=1
class ChecklistTemplate extends HiveObject { // Наследуем HiveObject

  @HiveField(0) // Номер поля 0
  late String name;

  @HiveField(1) // Номер поля 1
  String? description;

  @HiveField(2) // Номер поля 2
  late int version;

  @HiveField(3) // Номер поля 3
  late List<ChecklistItem> items; // Список адаптированных ChecklistItem

  ChecklistTemplate({
    this.name = '',
    this.description,
    this.version = 1,
    this.items = const [],
  });
}