// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Дашборд`
  String get dashboard {
    return Intl.message(
      'Дашборд',
      name: 'dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Пользователь`
  String get user {
    return Intl.message(
      'Пользователь',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `Настройки профиля`
  String get profileSettings {
    return Intl.message(
      'Настройки профиля',
      name: 'profileSettings',
      desc: '',
      args: [],
    );
  }

  /// `Начать Новую Проверку`
  String get startNewCheck {
    return Intl.message(
      'Начать Новую Проверку',
      name: 'startNewCheck',
      desc: '',
      args: [],
    );
  }

  /// `Открытые Несоответствия`
  String get openDeficiencies {
    return Intl.message(
      'Открытые Несоответствия',
      name: 'openDeficiencies',
      desc: '',
      args: [],
    );
  }

  /// `Проверки в Процессе ({count})`
  String checksInProgress(Object count) {
    return Intl.message(
      'Проверки в Процессе ($count)',
      name: 'checksInProgress',
      desc: '',
      args: [count],
    );
  }

  /// `Завершенные Проверки ({count})`
  String completedChecks(Object count) {
    return Intl.message(
      'Завершенные Проверки ($count)',
      name: 'completedChecks',
      desc: '',
      args: [count],
    );
  }

  /// `Нет активных проверок`
  String get noActiveChecks {
    return Intl.message(
      'Нет активных проверок',
      name: 'noActiveChecks',
      desc: '',
      args: [],
    );
  }

  /// `Нет завершенных проверок`
  String get noCompletedChecks {
    return Intl.message(
      'Нет завершенных проверок',
      name: 'noCompletedChecks',
      desc: '',
      args: [],
    );
  }

  /// `Неизвестный шаблон`
  String get unknownTemplate {
    return Intl.message(
      'Неизвестный шаблон',
      name: 'unknownTemplate',
      desc: '',
      args: [],
    );
  }

  /// `Начато: {date}`
  String startedOn(Object date) {
    return Intl.message(
      'Начато: $date',
      name: 'startedOn',
      desc: '',
      args: [date],
    );
  }

  /// `Завершено: {date}`
  String completedOn(Object date) {
    return Intl.message(
      'Завершено: $date',
      name: 'completedOn',
      desc: '',
      args: [date],
    );
  }

  /// `Завершено: Дата не указана`
  String get completedOnUnknownDate {
    return Intl.message(
      'Завершено: Дата не указана',
      name: 'completedOnUnknownDate',
      desc: '',
      args: [],
    );
  }

  /// `Судно: {name}`
  String vessel(Object name) {
    return Intl.message(
      'Судно: $name',
      name: 'vessel',
      desc: '',
      args: [name],
    );
  }

  /// `Порт: {name}`
  String port(Object name) {
    return Intl.message(
      'Порт: $name',
      name: 'port',
      desc: '',
      args: [name],
    );
  }

  /// `Капитан: {name}`
  String captain(Object name) {
    return Intl.message(
      'Капитан: $name',
      name: 'captain',
      desc: '',
      args: [name],
    );
  }

  /// `Проверяющий: {name}`
  String inspector(Object name) {
    return Intl.message(
      'Проверяющий: $name',
      name: 'inspector',
      desc: '',
      args: [name],
    );
  }

  /// `Удалить проверку`
  String get deleteCheck {
    return Intl.message(
      'Удалить проверку',
      name: 'deleteCheck',
      desc: '',
      args: [],
    );
  }

  /// `Создать PDF отчет`
  String get createPdfReport {
    return Intl.message(
      'Создать PDF отчет',
      name: 'createPdfReport',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка загрузки данных`
  String get errorLoadingData {
    return Intl.message(
      'Ошибка загрузки данных',
      name: 'errorLoadingData',
      desc: '',
      args: [],
    );
  }

  /// `Подтвердите Удаление`
  String get confirmDeletion {
    return Intl.message(
      'Подтвердите Удаление',
      name: 'confirmDeletion',
      desc: '',
      args: [],
    );
  }

  /// `Без имени`
  String get unnamedCheck {
    return Intl.message(
      'Без имени',
      name: 'unnamedCheck',
      desc: '',
      args: [],
    );
  }

  /// `Вы уверены, что хотите удалить проверку:\n"{checklistName}"?`
  String deleteChecklistConfirmation(Object checklistName) {
    return Intl.message(
      'Вы уверены, что хотите удалить проверку:\n"$checklistName"?',
      name: 'deleteChecklistConfirmation',
      desc: '',
      args: [checklistName],
    );
  }

  /// `Пожалуйста, введите слово 'Delete' для подтверждения:`
  String get enterDeleteToConfirm {
    return Intl.message(
      'Пожалуйста, введите слово \'Delete\' для подтверждения:',
      name: 'enterDeleteToConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get deleteWord {
    return Intl.message(
      'Delete',
      name: 'deleteWord',
      desc: '',
      args: [],
    );
  }

  /// `Отмена`
  String get cancel {
    return Intl.message(
      'Отмена',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `УДАЛИТЬ`
  String get deleteButton {
    return Intl.message(
      'УДАЛИТЬ',
      name: 'deleteButton',
      desc: '',
      args: [],
    );
  }

  /// `Проверка удалена`
  String get checkDeleted {
    return Intl.message(
      'Проверка удалена',
      name: 'checkDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка удаления`
  String get errorDeleting {
    return Intl.message(
      'Ошибка удаления',
      name: 'errorDeleting',
      desc: '',
      args: [],
    );
  }

  /// `Генерация PDF для "{name}"...`
  String generatingPdfFor(Object name) {
    return Intl.message(
      'Генерация PDF для "$name"...',
      name: 'generatingPdfFor',
      desc: '',
      args: [name],
    );
  }

  /// `Отчет`
  String get report {
    return Intl.message(
      'Отчет',
      name: 'report',
      desc: '',
      args: [],
    );
  }

  /// `Экземпляр проверки не найден`
  String get instanceNotFound {
    return Intl.message(
      'Экземпляр проверки не найден',
      name: 'instanceNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Шаблон не найден`
  String get templateNotFound {
    return Intl.message(
      'Шаблон не найден',
      name: 'templateNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Отчет о проверке: {name}`
  String checkReportSubject(Object name) {
    return Intl.message(
      'Отчет о проверке: $name',
      name: 'checkReportSubject',
      desc: '',
      args: [name],
    );
  }

  /// `Ошибка PDF`
  String get pdfError {
    return Intl.message(
      'Ошибка PDF',
      name: 'pdfError',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
