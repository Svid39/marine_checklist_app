// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(name) => "Капитан: ${name}";

  static String m1(templateName) => "Детали проверки для \"${templateName}\"";

  static String m2(name) => "Отчет о проверке: ${name}";

  static String m3(count) => "Проверки в Процессе (${count})";

  static String m4(itemOrder) => "Комментарий к п. ${itemOrder}";

  static String m5(count) => "Завершенные Проверки (${count})";

  static String m6(date) => "Завершено: ${date}";

  static String m7(error) =>
      "Критическая ошибка при создании проверки: ${error}";

  static String m8(key) => "Несоответствие с ключом ${key} не найдено!";

  static String m9(vesselName) =>
      "Отчет о несоответствиях для судна: ${vesselName}";

  static String m10(checklistName) =>
      "Вы уверены, что хотите удалить проверку:\n\"${checklistName}\"?";

  static String m11(description) =>
      "Вы уверены, что хотите удалить несоответствие:\n\"${description}\"?\n\nЭто действие необратимо!";

  static String m12(date) => " - Срок: ${date}";

  static String m13(error) => "Ошибка загрузки данных проверки: ${error}";

  static String m14(error) => "Ошибка загрузки шаблонов: ${error}";

  static String m15(error) => "Ошибка сохранения профиля: ${error}";

  static String m16(name) => "Генерация PDF для \"${name}\"...";

  static String m17(vesselName) =>
      "Генерация PDF отчета для судна \"${vesselName}\"...";

  static String m18(name) => "Проверяющий: ${name}";

  static String m19(key) => "Экземпляр с ключом ${key} не найден!";

  static String m20(itemOrder, itemText) =>
      "Пункт ${itemOrder}: ${itemText} отмечен как \"Не ОК\".";

  static String m21(vesselName) =>
      "Не найдено несоответствий для судна \"${vesselName}\"";

  static String m22(permissionName) =>
      "Требуется разрешение для доступа к ${permissionName}";

  static String m23(permissionName) =>
      "Для добавления фото требуется разрешение на доступ к \"${permissionName}\".";

  static String m24(error) => "Ошибка фото: ${error}";

  static String m25(name) => "Порт: ${name}";

  static String m26(date) => "Начато: ${date}";

  static String m27(status) => "Статус: ${status}";

  static String m28(key) => "Шаблон с ключом ${key} не найден!";

  static String m29(version) => "Версия: ${version}";

  static String m30(name) => "Судно: ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "addComment":
            MessageLookupByLibrary.simpleMessage("Добавить комментарий"),
        "addDeficiency":
            MessageLookupByLibrary.simpleMessage("Добавить Несоответствие"),
        "addDeficiencyPhoto":
            MessageLookupByLibrary.simpleMessage("Добавить Фото"),
        "addPhoto": MessageLookupByLibrary.simpleMessage("Добавить фото"),
        "appLanguage": MessageLookupByLibrary.simpleMessage("Язык приложения"),
        "appSettings":
            MessageLookupByLibrary.simpleMessage("Настройки Приложения"),
        "assignedTo": MessageLookupByLibrary.simpleMessage("Кому Поручено:"),
        "camera": MessageLookupByLibrary.simpleMessage("Камера"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "captain": m0,
        "captainNameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "Имя капитана не может быть пустым"),
        "captainNameForCheck": MessageLookupByLibrary.simpleMessage(
            "Имя Капитана (на эту проверку)"),
        "captainNameForReports":
            MessageLookupByLibrary.simpleMessage("Имя Капитана (для отчетов):"),
        "captainNameHint":
            MessageLookupByLibrary.simpleMessage("Например, Петр Петров"),
        "checkCompleted":
            MessageLookupByLibrary.simpleMessage("Проверка завершена"),
        "checkDeleted":
            MessageLookupByLibrary.simpleMessage("Проверка удалена"),
        "checkDetailsFor": m1,
        "checkReportSubject": m2,
        "checksInProgress": m3,
        "close": MessageLookupByLibrary.simpleMessage("Закрыть"),
        "commentToItem": m4,
        "completeCheck":
            MessageLookupByLibrary.simpleMessage("Завершить проверку"),
        "completedChecks": m5,
        "completedOn": m6,
        "completedOnUnknownDate":
            MessageLookupByLibrary.simpleMessage("Завершено: Дата не указана"),
        "confirmDeletion":
            MessageLookupByLibrary.simpleMessage("Подтвердите Удаление"),
        "correctiveActions":
            MessageLookupByLibrary.simpleMessage("Корректирующие Действия:"),
        "create": MessageLookupByLibrary.simpleMessage("Создать"),
        "createDeficiency":
            MessageLookupByLibrary.simpleMessage("Создать Несоответствие?"),
        "createPdfReport":
            MessageLookupByLibrary.simpleMessage("Создать PDF отчет"),
        "criticalErrorCreatingCheck": m7,
        "dashboard": MessageLookupByLibrary.simpleMessage("Дашборд"),
        "defaultVesselName": MessageLookupByLibrary.simpleMessage(
            "Название Судна (по умолчанию):"),
        "defaultVesselNameHint":
            MessageLookupByLibrary.simpleMessage("Например, MV Example"),
        "deficiencyDeleted":
            MessageLookupByLibrary.simpleMessage("Несоответствие удалено"),
        "deficiencyDescription":
            MessageLookupByLibrary.simpleMessage("Описание Несоответствия:"),
        "deficiencyDetails":
            MessageLookupByLibrary.simpleMessage("Детали Несоответствия"),
        "deficiencyList":
            MessageLookupByLibrary.simpleMessage("Список Несоответствий"),
        "deficiencyNotFound": m8,
        "deficiencyPhoto":
            MessageLookupByLibrary.simpleMessage("Фото Несоответствия:"),
        "deficiencyReportForVessel": m9,
        "deficiencySaved":
            MessageLookupByLibrary.simpleMessage("Несоответствие сохранено"),
        "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
        "deleteButton": MessageLookupByLibrary.simpleMessage("УДАЛИТЬ"),
        "deleteCheck": MessageLookupByLibrary.simpleMessage("Удалить проверку"),
        "deleteChecklistConfirmation": m10,
        "deleteDeficiency":
            MessageLookupByLibrary.simpleMessage("Удалить несоответствие"),
        "deleteDeficiencyConfirmation": m11,
        "deleteWord": MessageLookupByLibrary.simpleMessage("Delete"),
        "describeTheProblem":
            MessageLookupByLibrary.simpleMessage("Опишите проблему..."),
        "describeWhatWasDone": MessageLookupByLibrary.simpleMessage(
            "Опишите, что было сделано..."),
        "dueDate": MessageLookupByLibrary.simpleMessage("Срок Устранения:"),
        "dueDateLabel": m12,
        "editComment":
            MessageLookupByLibrary.simpleMessage("Редактировать комментарий"),
        "enterComment":
            MessageLookupByLibrary.simpleMessage("Введите комментарий..."),
        "enterDeleteToConfirm": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите слово \'Delete\' для подтверждения:"),
        "enterOrConfirmCaptainName": MessageLookupByLibrary.simpleMessage(
            "Введите или подтвердите имя капитана"),
        "enterOrConfirmVesselName": MessageLookupByLibrary.simpleMessage(
            "Введите или подтвердите название судна"),
        "enterPort": MessageLookupByLibrary.simpleMessage("Введите порт"),
        "errorDeleting":
            MessageLookupByLibrary.simpleMessage("Ошибка удаления"),
        "errorDeletingDeficiency": MessageLookupByLibrary.simpleMessage(
            "Ошибка удаления несоответствия"),
        "errorDeletingFile":
            MessageLookupByLibrary.simpleMessage("Ошибка удаления файла"),
        "errorDeletingPhoto": MessageLookupByLibrary.simpleMessage(
            "Ошибка удаления старого файла пункта"),
        "errorHiveBoxesNotOpen": MessageLookupByLibrary.simpleMessage(
            "Ошибка: Не все ящики Hive открыты."),
        "errorLoadingCheckData": m13,
        "errorLoadingData":
            MessageLookupByLibrary.simpleMessage("Ошибка загрузки данных"),
        "errorLoadingDeficiency": MessageLookupByLibrary.simpleMessage(
            "Ошибка загрузки данных несоответствия"),
        "errorLoadingTemplates": m14,
        "errorSaving":
            MessageLookupByLibrary.simpleMessage("Ошибка сохранения!"),
        "errorSavingDeficiency": MessageLookupByLibrary.simpleMessage(
            "Ошибка сохранения несоответствия"),
        "errorSavingProfile": m15,
        "failedToLoadCheckData": MessageLookupByLibrary.simpleMessage(
            "Не удалось загрузить данные проверки."),
        "failedToProcessPhoto":
            MessageLookupByLibrary.simpleMessage("Не удалось обработать фото"),
        "filterAll": MessageLookupByLibrary.simpleMessage("Все"),
        "gallery": MessageLookupByLibrary.simpleMessage("Галерея"),
        "generatingPdfFor": m16,
        "generatingPdfReportForVessel": m17,
        "inspector": m18,
        "instanceNotFound": MessageLookupByLibrary.simpleMessage(
            "Экземпляр проверки не найден"),
        "instanceNotFoundForKey": m19,
        "itemMarkedAsNotOk": m20,
        "later": MessageLookupByLibrary.simpleMessage("Позже"),
        "managePhoto": MessageLookupByLibrary.simpleMessage("Фото: Управление"),
        "na": MessageLookupByLibrary.simpleMessage("N/A"),
        "nameCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Имя не может быть пустым"),
        "nameOrPosition":
            MessageLookupByLibrary.simpleMessage("Имя или должность..."),
        "newDeficiency":
            MessageLookupByLibrary.simpleMessage("Новое Несоответствие"),
        "noActiveChecks":
            MessageLookupByLibrary.simpleMessage("Нет активных проверок"),
        "noCompletedChecks":
            MessageLookupByLibrary.simpleMessage("Нет завершенных проверок"),
        "noDeficienciesFoundForVessel": m21,
        "noDeficienciesRegistered": MessageLookupByLibrary.simpleMessage(
            "Нет зарегистрированных несоответствий."),
        "noDescription": MessageLookupByLibrary.simpleMessage("Без описания"),
        "notOk": MessageLookupByLibrary.simpleMessage("Не ОК"),
        "notSet": MessageLookupByLibrary.simpleMessage("Не установлен"),
        "notSetFeminine":
            MessageLookupByLibrary.simpleMessage("Не установлена"),
        "ok": MessageLookupByLibrary.simpleMessage("ОК"),
        "openDeficiencies":
            MessageLookupByLibrary.simpleMessage("Открытые Несоответствия"),
        "otherItems": MessageLookupByLibrary.simpleMessage("Прочие пункты"),
        "pdfError": MessageLookupByLibrary.simpleMessage("Ошибка PDF"),
        "pdfReportForDeficienciesTooltip": MessageLookupByLibrary.simpleMessage(
            "PDF отчет по несоответствиям текущего судна"),
        "permissionPermanentlyDenied": MessageLookupByLibrary.simpleMessage(
            " Пожалуйста, включите разрешение в настройках приложения."),
        "permissionRequired": m22,
        "permissionRequiredFor": m23,
        "photoAddedOrUpdated":
            MessageLookupByLibrary.simpleMessage("Фото добавлено/обновлено"),
        "photoDeleted": MessageLookupByLibrary.simpleMessage("Фото удалено"),
        "photoError": m24,
        "pleaseFixErrorsInForm": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, исправьте ошибки в форме."),
        "port": m25,
        "portCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Порт не может быть пустым"),
        "portOfCheck": MessageLookupByLibrary.simpleMessage("Порт Проверки"),
        "positionCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "Должность не может быть пустой"),
        "processingPhoto":
            MessageLookupByLibrary.simpleMessage("Обработка фото..."),
        "profileSettings":
            MessageLookupByLibrary.simpleMessage("Настройки профиля"),
        "profileSetup":
            MessageLookupByLibrary.simpleMessage("Настройка Профиля"),
        "replacePhoto": MessageLookupByLibrary.simpleMessage("Заменить фото"),
        "report": MessageLookupByLibrary.simpleMessage("Отчет"),
        "resolutionDate":
            MessageLookupByLibrary.simpleMessage("Дата Устранения:"),
        "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
        "selectCheckTemplate":
            MessageLookupByLibrary.simpleMessage("Выбор шаблона проверки"),
        "selectDueDate":
            MessageLookupByLibrary.simpleMessage("Выбрать дату срока"),
        "selectResolutionDate":
            MessageLookupByLibrary.simpleMessage("Выбрать дату устранения"),
        "settingsSaved":
            MessageLookupByLibrary.simpleMessage("Настройки сохранены!"),
        "startCheck": MessageLookupByLibrary.simpleMessage("Начать Проверку"),
        "startNewCheck":
            MessageLookupByLibrary.simpleMessage("Начать Новую Проверку"),
        "startedOn": m26,
        "status": MessageLookupByLibrary.simpleMessage("Статус:"),
        "statusClosed": MessageLookupByLibrary.simpleMessage("Закрыто"),
        "statusInProgress": MessageLookupByLibrary.simpleMessage("В работе"),
        "statusLabel": m27,
        "statusOpen": MessageLookupByLibrary.simpleMessage("Открыто"),
        "templateNotFound":
            MessageLookupByLibrary.simpleMessage("Шаблон не найден"),
        "templateNotFoundForKey": m28,
        "templatesNotFound": MessageLookupByLibrary.simpleMessage(
            "Шаблоны не найдены. Заполните базу данных."),
        "unknownTemplate":
            MessageLookupByLibrary.simpleMessage("Неизвестный шаблон"),
        "unnamedCheck": MessageLookupByLibrary.simpleMessage("Без имени"),
        "user": MessageLookupByLibrary.simpleMessage("Пользователь"),
        "version": m29,
        "vessel": m30,
        "vesselName": MessageLookupByLibrary.simpleMessage("Название Судна"),
        "vesselNameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "Название судна не может быть пустым"),
        "vesselNameNotInProfile": MessageLookupByLibrary.simpleMessage(
            "Название судна не указано в профиле!"),
        "viewOrReplacePhoto":
            MessageLookupByLibrary.simpleMessage("Просмотреть/Заменить Фото"),
        "yourName": MessageLookupByLibrary.simpleMessage("Ваше Имя:"),
        "yourNameHint":
            MessageLookupByLibrary.simpleMessage("Например, Иван Иванов"),
        "yourPosition": MessageLookupByLibrary.simpleMessage("Ваша Должность:"),
        "yourPositionHint":
            MessageLookupByLibrary.simpleMessage("Например, 2й Механик")
      };
}
