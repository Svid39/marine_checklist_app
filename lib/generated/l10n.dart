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

  /// `Ошибка загрузки шаблонов: {error}`
  String errorLoadingTemplates(Object error) {
    return Intl.message(
      'Ошибка загрузки шаблонов: $error',
      name: 'errorLoadingTemplates',
      desc: '',
      args: [error],
    );
  }

  /// `Детали проверки для "{templateName}"`
  String checkDetailsFor(Object templateName) {
    return Intl.message(
      'Детали проверки для "$templateName"',
      name: 'checkDetailsFor',
      desc: '',
      args: [templateName],
    );
  }

  /// `Название Судна`
  String get vesselName {
    return Intl.message(
      'Название Судна',
      name: 'vesselName',
      desc: '',
      args: [],
    );
  }

  /// `Введите или подтвердите название судна`
  String get enterOrConfirmVesselName {
    return Intl.message(
      'Введите или подтвердите название судна',
      name: 'enterOrConfirmVesselName',
      desc: '',
      args: [],
    );
  }

  /// `Название судна не может быть пустым`
  String get vesselNameCannotBeEmpty {
    return Intl.message(
      'Название судна не может быть пустым',
      name: 'vesselNameCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Порт Проверки`
  String get portOfCheck {
    return Intl.message(
      'Порт Проверки',
      name: 'portOfCheck',
      desc: '',
      args: [],
    );
  }

  /// `Введите порт`
  String get enterPort {
    return Intl.message(
      'Введите порт',
      name: 'enterPort',
      desc: '',
      args: [],
    );
  }

  /// `Порт не может быть пустым`
  String get portCannotBeEmpty {
    return Intl.message(
      'Порт не может быть пустым',
      name: 'portCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Имя Капитана (на эту проверку)`
  String get captainNameForCheck {
    return Intl.message(
      'Имя Капитана (на эту проверку)',
      name: 'captainNameForCheck',
      desc: '',
      args: [],
    );
  }

  /// `Введите или подтвердите имя капитана`
  String get enterOrConfirmCaptainName {
    return Intl.message(
      'Введите или подтвердите имя капитана',
      name: 'enterOrConfirmCaptainName',
      desc: '',
      args: [],
    );
  }

  /// `Имя капитана не может быть пустым`
  String get captainNameCannotBeEmpty {
    return Intl.message(
      'Имя капитана не может быть пустым',
      name: 'captainNameCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Начать Проверку`
  String get startCheck {
    return Intl.message(
      'Начать Проверку',
      name: 'startCheck',
      desc: '',
      args: [],
    );
  }

  /// `Критическая ошибка при создании проверки: {error}`
  String criticalErrorCreatingCheck(Object error) {
    return Intl.message(
      'Критическая ошибка при создании проверки: $error',
      name: 'criticalErrorCreatingCheck',
      desc: '',
      args: [error],
    );
  }

  /// `Выбор шаблона проверки`
  String get selectCheckTemplate {
    return Intl.message(
      'Выбор шаблона проверки',
      name: 'selectCheckTemplate',
      desc: '',
      args: [],
    );
  }

  /// `Шаблоны не найдены. Заполните базу данных.`
  String get templatesNotFound {
    return Intl.message(
      'Шаблоны не найдены. Заполните базу данных.',
      name: 'templatesNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Версия: {version}`
  String version(Object version) {
    return Intl.message(
      'Версия: $version',
      name: 'version',
      desc: '',
      args: [version],
    );
  }

  /// `Экземпляр с ключом {key} не найден!`
  String instanceNotFoundForKey(Object key) {
    return Intl.message(
      'Экземпляр с ключом $key не найден!',
      name: 'instanceNotFoundForKey',
      desc: '',
      args: [key],
    );
  }

  /// `Шаблон с ключом {key} не найден!`
  String templateNotFoundForKey(Object key) {
    return Intl.message(
      'Шаблон с ключом $key не найден!',
      name: 'templateNotFoundForKey',
      desc: '',
      args: [key],
    );
  }

  /// `Ошибка загрузки данных проверки: {error}`
  String errorLoadingCheckData(Object error) {
    return Intl.message(
      'Ошибка загрузки данных проверки: $error',
      name: 'errorLoadingCheckData',
      desc: '',
      args: [error],
    );
  }

  /// `Прочие пункты`
  String get otherItems {
    return Intl.message(
      'Прочие пункты',
      name: 'otherItems',
      desc: '',
      args: [],
    );
  }

  /// `Редактировать комментарий`
  String get editComment {
    return Intl.message(
      'Редактировать комментарий',
      name: 'editComment',
      desc: '',
      args: [],
    );
  }

  /// `Добавить комментарий`
  String get addComment {
    return Intl.message(
      'Добавить комментарий',
      name: 'addComment',
      desc: '',
      args: [],
    );
  }

  /// `Фото: Управление`
  String get managePhoto {
    return Intl.message(
      'Фото: Управление',
      name: 'managePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Добавить фото`
  String get addPhoto {
    return Intl.message(
      'Добавить фото',
      name: 'addPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка удаления старого файла пункта`
  String get errorDeletingPhoto {
    return Intl.message(
      'Ошибка удаления старого файла пункта',
      name: 'errorDeletingPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Камера`
  String get camera {
    return Intl.message(
      'Камера',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Галерея`
  String get gallery {
    return Intl.message(
      'Галерея',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Для добавления фото требуется разрешение на доступ к "{permissionName}".`
  String permissionRequiredFor(Object permissionName) {
    return Intl.message(
      'Для добавления фото требуется разрешение на доступ к "$permissionName".',
      name: 'permissionRequiredFor',
      desc: '',
      args: [permissionName],
    );
  }

  /// ` Пожалуйста, включите разрешение в настройках приложения.`
  String get permissionPermanentlyDenied {
    return Intl.message(
      ' Пожалуйста, включите разрешение в настройках приложения.',
      name: 'permissionPermanentlyDenied',
      desc: '',
      args: [],
    );
  }

  /// `Обработка фото...`
  String get processingPhoto {
    return Intl.message(
      'Обработка фото...',
      name: 'processingPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Фото добавлено/обновлено`
  String get photoAddedOrUpdated {
    return Intl.message(
      'Фото добавлено/обновлено',
      name: 'photoAddedOrUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось обработать фото`
  String get failedToProcessPhoto {
    return Intl.message(
      'Не удалось обработать фото',
      name: 'failedToProcessPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка фото: {error}`
  String photoError(Object error) {
    return Intl.message(
      'Ошибка фото: $error',
      name: 'photoError',
      desc: '',
      args: [error],
    );
  }

  /// `Комментарий к п. {itemOrder}`
  String commentToItem(Object itemOrder) {
    return Intl.message(
      'Комментарий к п. $itemOrder',
      name: 'commentToItem',
      desc: '',
      args: [itemOrder],
    );
  }

  /// `Введите комментарий...`
  String get enterComment {
    return Intl.message(
      'Введите комментарий...',
      name: 'enterComment',
      desc: '',
      args: [],
    );
  }

  /// `Сохранить`
  String get save {
    return Intl.message(
      'Сохранить',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка сохранения!`
  String get errorSaving {
    return Intl.message(
      'Ошибка сохранения!',
      name: 'errorSaving',
      desc: '',
      args: [],
    );
  }

  /// `Проверка завершена`
  String get checkCompleted {
    return Intl.message(
      'Проверка завершена',
      name: 'checkCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Завершить проверку`
  String get completeCheck {
    return Intl.message(
      'Завершить проверку',
      name: 'completeCheck',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось загрузить данные проверки.`
  String get failedToLoadCheckData {
    return Intl.message(
      'Не удалось загрузить данные проверки.',
      name: 'failedToLoadCheckData',
      desc: '',
      args: [],
    );
  }

  /// `ОК`
  String get ok {
    return Intl.message(
      'ОК',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Не ОК`
  String get notOk {
    return Intl.message(
      'Не ОК',
      name: 'notOk',
      desc: '',
      args: [],
    );
  }

  /// `N/A`
  String get na {
    return Intl.message(
      'N/A',
      name: 'na',
      desc: '',
      args: [],
    );
  }

  /// `Создать Несоответствие?`
  String get createDeficiency {
    return Intl.message(
      'Создать Несоответствие?',
      name: 'createDeficiency',
      desc: '',
      args: [],
    );
  }

  /// `Пункт {itemOrder}: {itemText} отмечен как "Не ОК".`
  String itemMarkedAsNotOk(Object itemOrder, Object itemText) {
    return Intl.message(
      'Пункт $itemOrder: $itemText отмечен как "Не ОК".',
      name: 'itemMarkedAsNotOk',
      desc: '',
      args: [itemOrder, itemText],
    );
  }

  /// `Позже`
  String get later {
    return Intl.message(
      'Позже',
      name: 'later',
      desc: '',
      args: [],
    );
  }

  /// `Создать`
  String get create {
    return Intl.message(
      'Создать',
      name: 'create',
      desc: '',
      args: [],
    );
  }

  /// `Закрыть`
  String get close {
    return Intl.message(
      'Закрыть',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Удалить`
  String get delete {
    return Intl.message(
      'Удалить',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Заменить фото`
  String get replacePhoto {
    return Intl.message(
      'Заменить фото',
      name: 'replacePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Список Несоответствий`
  String get deficiencyList {
    return Intl.message(
      'Список Несоответствий',
      name: 'deficiencyList',
      desc: '',
      args: [],
    );
  }

  /// `PDF отчет по несоответствиям текущего судна`
  String get pdfReportForDeficienciesTooltip {
    return Intl.message(
      'PDF отчет по несоответствиям текущего судна',
      name: 'pdfReportForDeficienciesTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Несоответствие удалено`
  String get deficiencyDeleted {
    return Intl.message(
      'Несоответствие удалено',
      name: 'deficiencyDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка удаления несоответствия`
  String get errorDeletingDeficiency {
    return Intl.message(
      'Ошибка удаления несоответствия',
      name: 'errorDeletingDeficiency',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка: Не все ящики Hive открыты.`
  String get errorHiveBoxesNotOpen {
    return Intl.message(
      'Ошибка: Не все ящики Hive открыты.',
      name: 'errorHiveBoxesNotOpen',
      desc: '',
      args: [],
    );
  }

  /// `Название судна не указано в профиле!`
  String get vesselNameNotInProfile {
    return Intl.message(
      'Название судна не указано в профиле!',
      name: 'vesselNameNotInProfile',
      desc: '',
      args: [],
    );
  }

  /// `Генерация PDF отчета для судна "{vesselName}"...`
  String generatingPdfReportForVessel(Object vesselName) {
    return Intl.message(
      'Генерация PDF отчета для судна "$vesselName"...',
      name: 'generatingPdfReportForVessel',
      desc: '',
      args: [vesselName],
    );
  }

  /// `Не найдено несоответствий для судна "{vesselName}"`
  String noDeficienciesFoundForVessel(Object vesselName) {
    return Intl.message(
      'Не найдено несоответствий для судна "$vesselName"',
      name: 'noDeficienciesFoundForVessel',
      desc: '',
      args: [vesselName],
    );
  }

  /// `Отчет о несоответствиях для судна: {vesselName}`
  String deficiencyReportForVessel(Object vesselName) {
    return Intl.message(
      'Отчет о несоответствиях для судна: $vesselName',
      name: 'deficiencyReportForVessel',
      desc: '',
      args: [vesselName],
    );
  }

  /// `Открыто`
  String get statusOpen {
    return Intl.message(
      'Открыто',
      name: 'statusOpen',
      desc: '',
      args: [],
    );
  }

  /// `В работе`
  String get statusInProgress {
    return Intl.message(
      'В работе',
      name: 'statusInProgress',
      desc: '',
      args: [],
    );
  }

  /// `Закрыто`
  String get statusClosed {
    return Intl.message(
      'Закрыто',
      name: 'statusClosed',
      desc: '',
      args: [],
    );
  }

  /// `Все`
  String get filterAll {
    return Intl.message(
      'Все',
      name: 'filterAll',
      desc: '',
      args: [],
    );
  }

  /// `Нет зарегистрированных несоответствий.`
  String get noDeficienciesRegistered {
    return Intl.message(
      'Нет зарегистрированных несоответствий.',
      name: 'noDeficienciesRegistered',
      desc: '',
      args: [],
    );
  }

  /// `Статус: {status}`
  String statusLabel(Object status) {
    return Intl.message(
      'Статус: $status',
      name: 'statusLabel',
      desc: '',
      args: [status],
    );
  }

  /// ` - Срок: {date}`
  String dueDateLabel(Object date) {
    return Intl.message(
      ' - Срок: $date',
      name: 'dueDateLabel',
      desc: '',
      args: [date],
    );
  }

  /// `Удалить несоответствие`
  String get deleteDeficiency {
    return Intl.message(
      'Удалить несоответствие',
      name: 'deleteDeficiency',
      desc: '',
      args: [],
    );
  }

  /// `Добавить Несоответствие`
  String get addDeficiency {
    return Intl.message(
      'Добавить Несоответствие',
      name: 'addDeficiency',
      desc: '',
      args: [],
    );
  }

  /// `Без описания`
  String get noDescription {
    return Intl.message(
      'Без описания',
      name: 'noDescription',
      desc: '',
      args: [],
    );
  }

  /// `Вы уверены, что хотите удалить несоответствие:\n"{description}"?\n\nЭто действие необратимо!`
  String deleteDeficiencyConfirmation(Object description) {
    return Intl.message(
      'Вы уверены, что хотите удалить несоответствие:\n"$description"?\n\nЭто действие необратимо!',
      name: 'deleteDeficiencyConfirmation',
      desc: '',
      args: [description],
    );
  }

  /// `Несоответствие с ключом {key} не найдено!`
  String deficiencyNotFound(Object key) {
    return Intl.message(
      'Несоответствие с ключом $key не найдено!',
      name: 'deficiencyNotFound',
      desc: '',
      args: [key],
    );
  }

  /// `Ошибка загрузки данных несоответствия`
  String get errorLoadingDeficiency {
    return Intl.message(
      'Ошибка загрузки данных несоответствия',
      name: 'errorLoadingDeficiency',
      desc: '',
      args: [],
    );
  }

  /// `Несоответствие сохранено`
  String get deficiencySaved {
    return Intl.message(
      'Несоответствие сохранено',
      name: 'deficiencySaved',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка сохранения несоответствия`
  String get errorSavingDeficiency {
    return Intl.message(
      'Ошибка сохранения несоответствия',
      name: 'errorSavingDeficiency',
      desc: '',
      args: [],
    );
  }

  /// `Пожалуйста, исправьте ошибки в форме.`
  String get pleaseFixErrorsInForm {
    return Intl.message(
      'Пожалуйста, исправьте ошибки в форме.',
      name: 'pleaseFixErrorsInForm',
      desc: '',
      args: [],
    );
  }

  /// `Новое Несоответствие`
  String get newDeficiency {
    return Intl.message(
      'Новое Несоответствие',
      name: 'newDeficiency',
      desc: '',
      args: [],
    );
  }

  /// `Детали Несоответствия`
  String get deficiencyDetails {
    return Intl.message(
      'Детали Несоответствия',
      name: 'deficiencyDetails',
      desc: '',
      args: [],
    );
  }

  /// `Описание Несоответствия:`
  String get deficiencyDescription {
    return Intl.message(
      'Описание Несоответствия:',
      name: 'deficiencyDescription',
      desc: '',
      args: [],
    );
  }

  /// `Опишите проблему...`
  String get describeTheProblem {
    return Intl.message(
      'Опишите проблему...',
      name: 'describeTheProblem',
      desc: '',
      args: [],
    );
  }

  /// `Статус:`
  String get status {
    return Intl.message(
      'Статус:',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Кому Поручено:`
  String get assignedTo {
    return Intl.message(
      'Кому Поручено:',
      name: 'assignedTo',
      desc: '',
      args: [],
    );
  }

  /// `Имя или должность...`
  String get nameOrPosition {
    return Intl.message(
      'Имя или должность...',
      name: 'nameOrPosition',
      desc: '',
      args: [],
    );
  }

  /// `Срок Устранения:`
  String get dueDate {
    return Intl.message(
      'Срок Устранения:',
      name: 'dueDate',
      desc: '',
      args: [],
    );
  }

  /// `Не установлен`
  String get notSet {
    return Intl.message(
      'Не установлен',
      name: 'notSet',
      desc: '',
      args: [],
    );
  }

  /// `Выбрать дату срока`
  String get selectDueDate {
    return Intl.message(
      'Выбрать дату срока',
      name: 'selectDueDate',
      desc: '',
      args: [],
    );
  }

  /// `Корректирующие Действия:`
  String get correctiveActions {
    return Intl.message(
      'Корректирующие Действия:',
      name: 'correctiveActions',
      desc: '',
      args: [],
    );
  }

  /// `Опишите, что было сделано...`
  String get describeWhatWasDone {
    return Intl.message(
      'Опишите, что было сделано...',
      name: 'describeWhatWasDone',
      desc: '',
      args: [],
    );
  }

  /// `Дата Устранения:`
  String get resolutionDate {
    return Intl.message(
      'Дата Устранения:',
      name: 'resolutionDate',
      desc: '',
      args: [],
    );
  }

  /// `Не установлена`
  String get notSetFeminine {
    return Intl.message(
      'Не установлена',
      name: 'notSetFeminine',
      desc: '',
      args: [],
    );
  }

  /// `Выбрать дату устранения`
  String get selectResolutionDate {
    return Intl.message(
      'Выбрать дату устранения',
      name: 'selectResolutionDate',
      desc: '',
      args: [],
    );
  }

  /// `Фото Несоответствия:`
  String get deficiencyPhoto {
    return Intl.message(
      'Фото Несоответствия:',
      name: 'deficiencyPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Просмотреть/Заменить Фото`
  String get viewOrReplacePhoto {
    return Intl.message(
      'Просмотреть/Заменить Фото',
      name: 'viewOrReplacePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Добавить Фото`
  String get addDeficiencyPhoto {
    return Intl.message(
      'Добавить Фото',
      name: 'addDeficiencyPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Фото удалено`
  String get photoDeleted {
    return Intl.message(
      'Фото удалено',
      name: 'photoDeleted',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка удаления файла`
  String get errorDeletingFile {
    return Intl.message(
      'Ошибка удаления файла',
      name: 'errorDeletingFile',
      desc: '',
      args: [],
    );
  }

  /// `Требуется разрешение для доступа к {permissionName}`
  String permissionRequired(Object permissionName) {
    return Intl.message(
      'Требуется разрешение для доступа к $permissionName',
      name: 'permissionRequired',
      desc: '',
      args: [permissionName],
    );
  }

  /// `Настройки сохранены!`
  String get settingsSaved {
    return Intl.message(
      'Настройки сохранены!',
      name: 'settingsSaved',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка сохранения профиля: {error}`
  String errorSavingProfile(Object error) {
    return Intl.message(
      'Ошибка сохранения профиля: $error',
      name: 'errorSavingProfile',
      desc: '',
      args: [error],
    );
  }

  /// `Настройка Профиля`
  String get profileSetup {
    return Intl.message(
      'Настройка Профиля',
      name: 'profileSetup',
      desc: '',
      args: [],
    );
  }

  /// `Настройки Приложения`
  String get appSettings {
    return Intl.message(
      'Настройки Приложения',
      name: 'appSettings',
      desc: '',
      args: [],
    );
  }

  /// `Ваше Имя:`
  String get yourName {
    return Intl.message(
      'Ваше Имя:',
      name: 'yourName',
      desc: '',
      args: [],
    );
  }

  /// `Например, Иван Иванов`
  String get yourNameHint {
    return Intl.message(
      'Например, Иван Иванов',
      name: 'yourNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Имя не может быть пустым`
  String get nameCannotBeEmpty {
    return Intl.message(
      'Имя не может быть пустым',
      name: 'nameCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Ваша Должность:`
  String get yourPosition {
    return Intl.message(
      'Ваша Должность:',
      name: 'yourPosition',
      desc: '',
      args: [],
    );
  }

  /// `Например, 2й Механик`
  String get yourPositionHint {
    return Intl.message(
      'Например, 2й Механик',
      name: 'yourPositionHint',
      desc: '',
      args: [],
    );
  }

  /// `Должность не может быть пустой`
  String get positionCannotBeEmpty {
    return Intl.message(
      'Должность не может быть пустой',
      name: 'positionCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Название Судна (по умолчанию):`
  String get defaultVesselName {
    return Intl.message(
      'Название Судна (по умолчанию):',
      name: 'defaultVesselName',
      desc: '',
      args: [],
    );
  }

  /// `Например, MV Example`
  String get defaultVesselNameHint {
    return Intl.message(
      'Например, MV Example',
      name: 'defaultVesselNameHint',
      desc: '',
      args: [],
    );
  }

  /// `Имя Капитана (для отчетов):`
  String get captainNameForReports {
    return Intl.message(
      'Имя Капитана (для отчетов):',
      name: 'captainNameForReports',
      desc: '',
      args: [],
    );
  }

  /// `Например, Петр Петров`
  String get captainNameHint {
    return Intl.message(
      'Например, Петр Петров',
      name: 'captainNameHint',
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
