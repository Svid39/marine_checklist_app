import 'package:hive/hive.dart';
import 'enums.dart';

part 'checklist_item.g.dart';

/// Представляет собой один пункт (вопрос или утверждение) в рамках [ChecklistTemplate].
///
/// Этот класс не хранит ответ пользователя, а только определяет структуру самого пункта.
@HiveType(typeId: 2)
class ChecklistItem {
  /// Основной текст вопроса или пункта проверки.
  /// Например, "Проверить уровень масла в главном двигателе".
  @HiveField(0)
  String text;

  /// Необязательная дополнительная информация или уточнение к основному тексту.
  @HiveField(1)
  String? details;

  /// Порядковый номер пункта в списке. Используется для сортировки.
  @HiveField(2)
  int order;

  /// Определяет, какой тип ответа ожидается от пользователя (например, OK/Не ОК, текст).
  /// См. перечисление [ResponseType].
  @HiveField(3)
  ResponseType responseType;

  /// Необязательная ссылка на нормативный документ или правило (например, "SOLAS II-2/10.2").
  @HiveField(4)
  String? regulationRef;

  /// Название секции, к которой относится этот пункт.
  /// Используется для группировки пунктов в пользовательском интерфейсе.
  @HiveField(5) // Номер поля 5
  String? section;

  /// Создает новый экземпляр пункта чек-листа.
  ChecklistItem({
    this.text = '',
    this.details,
    this.order = 0,
    this.responseType = ResponseType.okNotOkNA,
    this.regulationRef,
    this.section,
  });

  /// Создает экземпляр [ChecklistItem] из JSON-формата version 1.1
  Map<String, dynamic> toJson() {
  return {
    'text': text,
    'details': details,
    'order': order,
    'responseType': responseType.name,
    'regulationRef': regulationRef,
    'section': section,
  };
}
}