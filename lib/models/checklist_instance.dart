import 'package:hive/hive.dart';
import 'checklist_item_response.dart';
import 'enums.dart';

part 'checklist_instance.g.dart';

/// Представляет собой конкретный, заполняемый экземпляр чек-листа.
///
/// Если [ChecklistTemplate] — это пустой бланк, то `ChecklistInstance` — это
/// тот же бланк, который пользователь взял, заполнил метаданными (судно, дата)
/// и начал отвечать на вопросы. Каждый объект этого класса хранится как
/// отдельная запись в "ящике" [instancesBoxName].
@HiveType(typeId: 3)
class ChecklistInstance extends HiveObject {
  /// ID шаблона ([ChecklistTemplate]), на основе которого создан этот экземпляр.
  ///
  /// Это поле связывает динамические данные (ответы пользователя) со статической
  /// структурой (шаблоном).
  @HiveField(0)
  int templateId;

  /// Название судна, для которого проводится проверка.
  @HiveField(1)
  String? shipName;

  /// Дата и время создания (начала) проверки.
  @HiveField(2)
  DateTime date;

  /// Текущий статус проверки (например, "в процессе" или "завершена").
  /// См. перечисление [ChecklistInstanceStatus].
  @HiveField(3)
  ChecklistInstanceStatus status;

  /// Список ответов пользователя ([ChecklistItemResponse]) на пункты чек-листа.
  ///
  /// Это основное поле, хранящее пользовательский ввод.
  @HiveField(4)
  List<ChecklistItemResponse> responses;

  /// Необязательная дата и время, когда проверка была помечена как завершенная.
  @HiveField(5)
  DateTime? completionDate;

  /// Порт, в котором проводится проверка.
  @HiveField(6)
  String? port;

  /// Имя капитана на момент проведения проверки.
  @HiveField(7)
  String? captainNameOnCheck;

  /// Имя проверяющего (обычно берется из [UserProfile]).
  @HiveField(8)
  String? inspectorName;

  /// Создает новый экземпляр проверки.
  ChecklistInstance({
    required this.templateId,
    required this.date,
    this.shipName,
    this.status = ChecklistInstanceStatus.inProgress,
    this.responses = const [],
    this.completionDate,
    this.port,
    this.captainNameOnCheck,
    this.inspectorName,
  });
}