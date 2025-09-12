import 'package:hive/hive.dart'; // Импорт Hive

part 'user_profile.g.dart'; // Оставляем для Hive

@HiveType(typeId: 0) // Уникальный ID=0
class UserProfile extends HiveObject {
  @HiveField(0) // Номер поля 0
  String? name;

  @HiveField(1) // Номер поля 1
  String? position;

  @HiveField(2) // Номер поля 2
  String? shipName;

  @HiveField(3) // Номер поля 3
  String? captainName;

  @HiveField(4) // <-- НОВОЕ ПОЛЕ
  String? languageCode;

  UserProfile({
    this.name,
    this.position,
    this.shipName,
    this.captainName,
    this.languageCode,
  });
}
