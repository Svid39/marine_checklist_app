import 'package:hive/hive.dart';
import 'enums.dart';

part 'checklist_item_response.g.dart';

/// Хранит ответ пользователя на один конкретный пункт ([ChecklistItem]) чек-листа.
///
/// Объекты этого класса не хранятся в собственном "ящике" Hive, а являются
/// частью списка `responses` внутри объекта [ChecklistInstance].
@HiveType(typeId: 4)
class ChecklistItemResponse {
  /// ID пункта ([ChecklistItem.order]), к которому относится этот ответ.
  ///
  /// Это поле связывает ответ с его вопросом в шаблоне.
  @HiveField(0)
  int itemId;

  /// Ответ-статус для пунктов типа [ResponseType.okNotOkNA].
  ///
  /// Может быть `null`, если ответ другого типа (текст, число).
  @HiveField(1)
  ItemResponseStatus? status;

  /// Текстовый ответ для пунктов типа [ResponseType.text].
  @HiveField(2)
  String? textValue;

  /// Числовой ответ для пунктов типа [ResponseType.number].
  @HiveField(3)
  double? numberValue;

  /// Локальный путь к файлу фотографии, прикрепленной к этому ответу.
  @HiveField(4)
  String? photoPath;

  /// Дополнительный текстовый комментарий пользователя к этому ответу.
  @HiveField(5)
  String? comment;

  /// Создает новый экземпляр ответа на пункт чек-листа.
  ChecklistItemResponse({
    this.itemId = 0,
    this.status,
    this.textValue,
    this.numberValue,
    this.photoPath,
    this.comment,
  });
}