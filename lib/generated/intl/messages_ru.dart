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

  static String m4(count) => "Завершенные Проверки (${count})";

  static String m5(date) => "Завершено: ${date}";

  static String m6(error) =>
      "Критическая ошибка при создании проверки: ${error}";

  static String m7(checklistName) =>
      "Вы уверены, что хотите удалить проверку:\n\"${checklistName}\"?";

  static String m8(error) => "Ошибка загрузки шаблонов: ${error}";

  static String m9(name) => "Генерация PDF для \"${name}\"...";

  static String m10(name) => "Проверяющий: ${name}";

  static String m11(name) => "Порт: ${name}";

  static String m12(date) => "Начато: ${date}";

  static String m13(version) => "Версия: ${version}";

  static String m14(name) => "Судно: ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "captain": m0,
        "captainNameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "Имя капитана не может быть пустым"),
        "captainNameForCheck": MessageLookupByLibrary.simpleMessage(
            "Имя Капитана (на эту проверку)"),
        "checkDeleted":
            MessageLookupByLibrary.simpleMessage("Проверка удалена"),
        "checkDetailsFor": m1,
        "checkReportSubject": m2,
        "checksInProgress": m3,
        "completedChecks": m4,
        "completedOn": m5,
        "completedOnUnknownDate":
            MessageLookupByLibrary.simpleMessage("Завершено: Дата не указана"),
        "confirmDeletion":
            MessageLookupByLibrary.simpleMessage("Подтвердите Удаление"),
        "createPdfReport":
            MessageLookupByLibrary.simpleMessage("Создать PDF отчет"),
        "criticalErrorCreatingCheck": m6,
        "dashboard": MessageLookupByLibrary.simpleMessage("Дашборд"),
        "deleteButton": MessageLookupByLibrary.simpleMessage("УДАЛИТЬ"),
        "deleteCheck": MessageLookupByLibrary.simpleMessage("Удалить проверку"),
        "deleteChecklistConfirmation": m7,
        "deleteWord": MessageLookupByLibrary.simpleMessage("Delete"),
        "enterDeleteToConfirm": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите слово \'Delete\' для подтверждения:"),
        "enterOrConfirmCaptainName": MessageLookupByLibrary.simpleMessage(
            "Введите или подтвердите имя капитана"),
        "enterOrConfirmVesselName": MessageLookupByLibrary.simpleMessage(
            "Введите или подтвердите название судна"),
        "enterPort": MessageLookupByLibrary.simpleMessage("Введите порт"),
        "errorDeleting":
            MessageLookupByLibrary.simpleMessage("Ошибка удаления"),
        "errorLoadingData":
            MessageLookupByLibrary.simpleMessage("Ошибка загрузки данных"),
        "errorLoadingTemplates": m8,
        "generatingPdfFor": m9,
        "inspector": m10,
        "instanceNotFound": MessageLookupByLibrary.simpleMessage(
            "Экземпляр проверки не найден"),
        "noActiveChecks":
            MessageLookupByLibrary.simpleMessage("Нет активных проверок"),
        "noCompletedChecks":
            MessageLookupByLibrary.simpleMessage("Нет завершенных проверок"),
        "openDeficiencies":
            MessageLookupByLibrary.simpleMessage("Открытые Несоответствия"),
        "pdfError": MessageLookupByLibrary.simpleMessage("Ошибка PDF"),
        "port": m11,
        "portCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("Порт не может быть пустым"),
        "portOfCheck": MessageLookupByLibrary.simpleMessage("Порт Проверки"),
        "profileSettings":
            MessageLookupByLibrary.simpleMessage("Настройки профиля"),
        "report": MessageLookupByLibrary.simpleMessage("Отчет"),
        "selectCheckTemplate":
            MessageLookupByLibrary.simpleMessage("Выбор шаблона проверки"),
        "startCheck": MessageLookupByLibrary.simpleMessage("Начать Проверку"),
        "startNewCheck":
            MessageLookupByLibrary.simpleMessage("Начать Новую Проверку"),
        "startedOn": m12,
        "templateNotFound":
            MessageLookupByLibrary.simpleMessage("Шаблон не найден"),
        "templatesNotFound": MessageLookupByLibrary.simpleMessage(
            "Шаблоны не найдены. Заполните базу данных."),
        "unknownTemplate":
            MessageLookupByLibrary.simpleMessage("Неизвестный шаблон"),
        "unnamedCheck": MessageLookupByLibrary.simpleMessage("Без имени"),
        "user": MessageLookupByLibrary.simpleMessage("Пользователь"),
        "version": m13,
        "vessel": m14,
        "vesselName": MessageLookupByLibrary.simpleMessage("Название Судна"),
        "vesselNameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
            "Название судна не может быть пустым")
      };
}
