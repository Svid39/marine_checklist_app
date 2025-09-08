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

  static String m1(name) => "Отчет о проверке: ${name}";

  static String m2(count) => "Проверки в Процессе (${count})";

  static String m3(count) => "Завершенные Проверки (${count})";

  static String m4(date) => "Завершено: ${date}";

  static String m5(checklistName) =>
      "Вы уверены, что хотите удалить проверку:\n\"${checklistName}\"?";

  static String m6(name) => "Генерация PDF для \"${name}\"...";

  static String m7(name) => "Проверяющий: ${name}";

  static String m8(name) => "Порт: ${name}";

  static String m9(date) => "Начато: ${date}";

  static String m10(name) => "Судно: ${name}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "captain": m0,
        "checkDeleted":
            MessageLookupByLibrary.simpleMessage("Проверка удалена"),
        "checkReportSubject": m1,
        "checksInProgress": m2,
        "completedChecks": m3,
        "completedOn": m4,
        "completedOnUnknownDate":
            MessageLookupByLibrary.simpleMessage("Завершено: Дата не указана"),
        "confirmDeletion":
            MessageLookupByLibrary.simpleMessage("Подтвердите Удаление"),
        "createPdfReport":
            MessageLookupByLibrary.simpleMessage("Создать PDF отчет"),
        "dashboard": MessageLookupByLibrary.simpleMessage("Дашборд"),
        "deleteButton": MessageLookupByLibrary.simpleMessage("УДАЛИТЬ"),
        "deleteCheck": MessageLookupByLibrary.simpleMessage("Удалить проверку"),
        "deleteChecklistConfirmation": m5,
        "deleteWord": MessageLookupByLibrary.simpleMessage("Delete"),
        "enterDeleteToConfirm": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите слово \'Delete\' для подтверждения:"),
        "errorDeleting":
            MessageLookupByLibrary.simpleMessage("Ошибка удаления"),
        "errorLoadingData":
            MessageLookupByLibrary.simpleMessage("Ошибка загрузки данных"),
        "generatingPdfFor": m6,
        "inspector": m7,
        "instanceNotFound": MessageLookupByLibrary.simpleMessage(
            "Экземпляр проверки не найден"),
        "noActiveChecks":
            MessageLookupByLibrary.simpleMessage("Нет активных проверок"),
        "noCompletedChecks":
            MessageLookupByLibrary.simpleMessage("Нет завершенных проверок"),
        "openDeficiencies":
            MessageLookupByLibrary.simpleMessage("Открытые Несоответствия"),
        "pdfError": MessageLookupByLibrary.simpleMessage("Ошибка PDF"),
        "port": m8,
        "profileSettings":
            MessageLookupByLibrary.simpleMessage("Настройки профиля"),
        "report": MessageLookupByLibrary.simpleMessage("Отчет"),
        "startNewCheck":
            MessageLookupByLibrary.simpleMessage("Начать Новую Проверку"),
        "startedOn": m9,
        "templateNotFound":
            MessageLookupByLibrary.simpleMessage("Шаблон не найден"),
        "unknownTemplate":
            MessageLookupByLibrary.simpleMessage("Неизвестный шаблон"),
        "unnamedCheck": MessageLookupByLibrary.simpleMessage("Без имени"),
        "user": MessageLookupByLibrary.simpleMessage("Пользователь"),
        "vessel": m10
      };
}
