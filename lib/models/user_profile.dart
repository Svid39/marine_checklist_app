import 'package:hive/hive.dart';

part 'user_profile.g.dart';

/// Модель для хранения данных профиля пользователя и общих настроек приложения.
///
/// Хранится в Hive в "ящике" [userProfileBoxName] под единственным ключом `1`.
/// Наследует [HiveObject] для удобного доступа к ключу и ящику.
@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  /// Имя пользователя (например, инспектора), используется в отчетах.
  @HiveField(0)
  String? name;

  /// Должность пользователя, используется в отчетах.
  @HiveField(1)
  String? position;

  /// Название судна по умолчанию для предзаполнения в новых проверках.
  @HiveField(2)
  String? shipName;

  /// Имя капитана по умолчанию для предзаполнения в новых проверках.
  @HiveField(3)
  String? captainName;

  /// Код выбранного пользователем языка (например, 'en' или 'ru').
  ///
  /// Используется для сохранения языковых предпочтений между сессиями.
  @HiveField(4)
  String? languageCode;

  /// Создает экземпляр профиля пользователя.
  UserProfile({
    this.name,
    this.position,
    this.shipName,
    this.captainName,
    this.languageCode,
  });
}
