import 'package:hive/hive.dart';
import 'enums.dart';

part 'deficiency.g.dart';

/// Представляет собой одно "несоответствие" — проблему или замечание,
/// выявленное в ходе проверки или созданное вручную.
///
/// Каждый объект этого класса хранится как отдельная запись в "ящике"
/// [deficienciesBoxName].
@HiveType(typeId: 5)
class Deficiency extends HiveObject {
  /// Текстовое описание сути несоответствия.
  @HiveField(0)
  String description;

  /// ID связанного экземпляра проверки [ChecklistInstance].
  ///
  /// Может быть `null`, если несоответствие было создано вручную,
  /// а не из конкретного пункта чек-листа.
  @HiveField(1)
  int? instanceId;

  /// ID связанного пункта проверки [ChecklistItem.order].
  ///
  /// Может быть `null`, если несоответствие было создано вручную.
  @HiveField(2)
  int? checklistItemId;

  /// Текущий статус жизненного цикла несоответствия (Открыто, В работе, Закрыто).
  /// См. перечисление [DeficiencyStatus].
  @HiveField(3)
  DeficiencyStatus status;

  /// Имя или должность ответственного за устранение.
  @HiveField(4)
  String? assignedTo;

  /// Установленный срок, к которому несоответствие должно быть устранено.
  @HiveField(5)
  DateTime? dueDate;

  /// Описание предпринятых действий для устранения проблемы.
  @HiveField(6)
  String? correctiveActions;

  /// Фактическая дата, когда несоответствие было устранено.
  @HiveField(7)
  DateTime? resolutionDate;

  /// Локальный путь к файлу фотографии, документирующей несоответствие.
  @HiveField(8)
  String? photoPath;

  /// Создает новый экземпляр несоответствия.
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