import 'package:hive/hive.dart';
import 'checklist_item.dart';

part 'checklist_template.g.dart';

/// Представляет собой неизменяемый шаблон (или "чертеж") для чек-листа.
///
/// Объекты этого класса определяют структуру, название и список всех пунктов,
/// которые будут использоваться для создания экземпляров проверок ([ChecklistInstance]).
@HiveType(typeId: 1)
class ChecklistTemplate extends HiveObject {
  /// Пользовательское название чек-листа.
  /// Например, "Проверка перед отходом".
  @HiveField(0)
  String name;

  /// Необязательное, более подробное описание назначения чек-листа.
  @HiveField(1)
  String? description;

  /// Версия шаблона. Может использоваться в будущем для миграции данных.
  @HiveField(2)
  int version;

  /// Список всех пунктов ([ChecklistItem]), входящих в этот шаблон.
  @HiveField(3)
  List<ChecklistItem> items;

  /// Создает новый экземпляр шаблона чек-листа.
  ChecklistTemplate({
    this.name = '',
    this.description,
    this.version = 1,
    this.items = const [],
  });

  /// Создает экземпляр [ChecklistTemplate] из JSON-формата version 1.1
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'version': version,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  // Внутри класса ChecklistTemplate

  /// Фабричный конструктор для создания [ChecklistTemplate] из JSON-карты.
  factory ChecklistTemplate.fromJson(Map<String, dynamic> json) {
    // Преобразуем список JSON-объектов в список объектов ChecklistItem
    var itemsList = json['items'] as List;
    List<ChecklistItem> items =
        itemsList.map((itemJson) => ChecklistItem.fromJson(itemJson)).toList();

    return ChecklistTemplate(
      name: json['name'] ?? '',
      version: json['version'] ?? 1,
      items: items,
      description: json['description'],
    );
  }
}
