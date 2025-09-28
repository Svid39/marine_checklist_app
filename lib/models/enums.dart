import 'package:hive/hive.dart';

part 'enums.g.dart';

/// Определяет общий статус выполнения экземпляра чек-листа [ChecklistInstance].
@HiveType(typeId: 6)
enum ChecklistInstanceStatus {
  /// Проверка начата, но еще не завершена.
  @HiveField(0)
  inProgress,

  /// Все пункты проверки пройдены, и проверка завершена.
  @HiveField(1)
  completed,
}

/// Определяет тип виджета, который будет использоваться для ответа на пункт [ChecklistItem].
@HiveType(typeId: 7)
enum ResponseType {
  /// Ответ с помощью кнопок "OK" / "Не OK" / "Не применимо".
  @HiveField(0)
  okNotOkNA,

  /// Ответ в виде текстового поля.
  @HiveField(1)
  text,

  /// Ответ в виде числового поля.
  @HiveField(2)
  number,
}

/// Определяет конкретный ответ пользователя на пункт типа [ResponseType.okNotOkNA].
@HiveType(typeId: 8)
enum ItemResponseStatus {
  /// Ответ "OK" (В порядке).
  @HiveField(0)
  ok,

  /// Ответ "Не OK" (Не в порядке), что может повлечь создание [Deficiency].
  @HiveField(1)
  notOk,

  /// Ответ "N/A" (Не применимо).
  @HiveField(2)
  na,
}

/// Определяет статус жизненного цикла для несоответствия [Deficiency].
@HiveType(typeId: 9)
enum DeficiencyStatus {
  /// Несоответствие зафиксировано, работа не начата.
  @HiveField(0)
  open,

  /// Ведется работа по устранению несоответствия.
  @HiveField(1)
  inProgress,

  /// Несоответствие устранено и закрыто.
  @HiveField(2)
  closed,
}

// --- НОВЫЙ КОД ---
/// Определяет статус синхронизации объекта с облаком.
@HiveType(typeId: 10) // Уникальный ID = 10
enum SyncStatus {
  /// Объект синхронизирован с сервером.
  @HiveField(0)
  synced,

  /// Объект был создан локально и требует выгрузки на сервер.
  @HiveField(1)
  needsCreate,

  /// Объект был изменен локально и требует обновления на сервере.
  @HiveField(2)
  needsUpdate,
}
// --- КОНЕЦ НОВОГО КОДА ---