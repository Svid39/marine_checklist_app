// Файл: lib/models/enums.dart

import 'package:hive/hive.dart'; // <-- Добавляем импорт Hive

part 'enums.g.dart'; // <-- Добавляем строку part

@HiveType(typeId: 6) // <-- Добавляем HiveType с уникальным ID=6
enum ChecklistInstanceStatus {
  @HiveField(0) // <-- Добавляем HiveField для значений
  inProgress,
  @HiveField(1)
  completed,
}

@HiveType(typeId: 7) // <-- Добавляем HiveType с уникальным ID=7
enum ResponseType {
  @HiveField(0)
  okNotOkNA,
  @HiveField(1)
  text,
  @HiveField(2)
  number,
}

@HiveType(typeId: 8) // <-- Добавляем HiveType с уникальным ID=8
enum ItemResponseStatus {
  @HiveField(0)
  ok,
  @HiveField(1)
  notOk,
  @HiveField(2)
  na,
}

@HiveType(typeId: 9) // <-- Добавляем HiveType с уникальным ID=9
enum DeficiencyStatus {
  @HiveField(0)
  open,
  @HiveField(1)
  inProgress,
  @HiveField(2)
  closed,
}