// Файл: lib/services/pdf_generator_service.dart

import 'dart:typed_data'; // Для Uint8List
import 'package:pdf/widgets.dart'
    as pw; // Используем префикс pw для виджетов пакета pdf
import '../models/deficiency.dart';
import 'package:pdf/pdf.dart'; // Для PdfPageFormat
import '../models/checklist_instance.dart'; // Для ChecklistInstance
import '../models/checklist_template.dart'; // Для ChecklistTemplate
import '../models/checklist_item_response.dart'; // Для ChecklistItemResponse
import '../models/user_profile.dart'; // Для UserProfile
import '../models/enums.dart'; // Для ItemResponseStatus
import 'package:flutter/services.dart' show rootBundle;

class PdfGeneratorService {
  // Метод для генерации PDF из ChecklistInstance
  Future<Uint8List> generateChecklistInstancePdf(
    ChecklistInstance instance,
    ChecklistTemplate template,
    UserProfile? userProfile, // Профиль пользователя для имени проверяющего
  ) async {
    // --- НОВОЕ: Загрузка шрифта ---
    final fontData = await rootBundle.load(
      "assets/fonts/DejaVuSans.ttf",
    ); // Укажите ваш путь
    final ttfFont = pw.Font.ttf(fontData);
    final pdfTheme = pw.ThemeData.withFont(
      base: ttfFont,
      bold: ttfFont,
    ); // Используем один шрифт для простоты
    // ----------------------------

    final pdf = pw.Document(theme: pdfTheme); //

    // --- Здесь будет логика наполнения документа ---
    // 1. Добавление страницы (или нескольких)
    // 2. Формирование шапки отчета (информация о проверке)
    // 3. Формирование таблицы/списка с пунктами чек-листа и ответами
    // 4. (Опционально) Добавление колонтитулов (номера страниц)

    pdf.addPage(
      pw.MultiPage(
        // MultiPage для контента, который может не поместиться на одну страницу
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32), // Отступы на странице
        header: (pw.Context context) {
          // Опциональный заголовок для каждой страницы
          if (context.pageNumber == 1) {
            return pw.SizedBox(); // На первой странице заголовок может быть частью build
          }
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            child: pw.Text(
              template.name, // Название чек-листа в хедере
              style: pw.Theme.of(
                context,
              ).defaultTextStyle.copyWith(color: PdfColors.grey),
            ),
          );
        },
        footer: (pw.Context context) {
          // Опциональный подвал для каждой страницы (номер страницы)
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
              'Стр. ${context.pageNumber} из ${context.pagesCount}',
              style: pw.Theme.of(
                context,
              ).defaultTextStyle.copyWith(color: PdfColors.grey),
            ),
          );
        },
        build:
            (pw.Context context) => [
              // Список виджетов для этой страницы/страниц
              // --- ШАПКА ОТЧЕТА ---
              _buildHeader(context, instance, template, userProfile),
              pw.SizedBox(height: 20),

              // --- ПУНКТЫ ЧЕК-ЛИСТА ---
              _buildItemsTable(context, instance, template),
              // TODO: Можно добавить секцию для комментариев или фото (пока просто)
            ],
      ),
    );

    // Сохраняем PDF в виде байтов
    return pdf.save();
  }

  // --- Вспомогательные методы для построения частей PDF ---
  // Файл: lib/services/pdf_generator_service.dart
  // Внутри класса PdfGeneratorService

  // --- НОВЫЙ МЕТОД: Генерация PDF отчета по несоответствиям для судна ---
  Future<Uint8List> generateShipDeficiencyReportPdf(
    String targetShipName,
    List<Deficiency>
    deficienciesForShip, // Список уже отфильтрованных несоответствий
    UserProfile? userProfile,
    Map<dynamic, ChecklistInstance>
    instancesMap, // Карта всех экземпляров для поиска контекста
    Map<dynamic, ChecklistTemplate>
    templatesMap, // Карта всех шаблонов для поиска контекста
  ) async {
    final fontData = await rootBundle.load("assets/fonts/DejaVuSans.ttf");
    final ttfFont = pw.Font.ttf(fontData);
    final pdfTheme = pw.ThemeData.withFont(base: ttfFont, bold: ttfFont);

    final pdf = pw.Document(theme: pdfTheme);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (pw.Context context) {
          // Опциональный заголовок для каждой страницы
          // Если это первая страница, мы можем не показывать этот header,
          // так как основная шапка отчета (_buildDeficiencyReportHeader) будет в build.
          if (context.pageNumber == 1) {
            return pw.SizedBox(); // Пустой виджет для первой страницы
          }
          // Для последующих страниц можно добавить, например, название отчета или судна
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            child: pw.Text(
              'Отчет о Несоответствиях - Судно: $targetShipName', // Используем targetShipName
              style: pw.Theme.of(
                context,
              ).defaultTextStyle.copyWith(color: PdfColors.grey, fontSize: 9),
            ), // Уменьшим шрифт
          );
        },
        footer: (pw.Context context) {
          // Опциональный подвал для каждой страницы (номер страницы)
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text(
              'Стр. ${context.pageNumber} из ${context.pagesCount}',
              style: pw.Theme.of(
                context,
              ).defaultTextStyle.copyWith(color: PdfColors.grey),
            ),
          );
        },

        build:
            (pw.Context pageContext) => [
              _buildDeficiencyReportHeader(
                pageContext,
                targetShipName,
                userProfile,
              ),
              pw.SizedBox(height: 20),
              _buildDeficienciesTable(
                pageContext,
                deficienciesForShip,
                instancesMap,
                templatesMap,
              ),
            ],
      ),
    );
    return pdf.save();
  }
  // -------------------------------------------------------------------

  // --- НОВЫЙ ВСПОМОГАТЕЛЬНЫЙ МЕТОД: Шапка для отчета по несоответствиям ---
  pw.Widget _buildDeficiencyReportHeader(
    pw.Context context,
    String targetShipName,
    UserProfile? userProfile,
  ) {
    String formatDate(DateTime? dt) {
      // Можно вынести в общий helper
      if (dt == null) return 'N/A';
      return "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}";
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Отчет о Несоответствиях',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text('Судно: $targetShipName', style: pw.TextStyle(fontSize: 16)),
        pw.SizedBox(height: 5),
        pw.Text(
          'Проверяющий: ${userProfile?.name ?? 'N/A'}',
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.Text(
          'Дата отчета: ${formatDate(DateTime.now())}',
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.SizedBox(height: 10),
        pw.Divider(),
      ],
    );
  }
  // ----------------------------------------------------------------------

  // --- НОВЫЙ ВСПОМОГАТЕЛЬНЫЙ МЕТОД: Таблица несоответствий ---
  pw.Widget _buildDeficienciesTable(
    pw.Context context,
    List<Deficiency> deficiencies,
    Map<dynamic, ChecklistInstance> instancesMap,
    Map<dynamic, ChecklistTemplate> templatesMap,
  ) {
    final headers = [
      '№',
      'Описание',
      'Статус',
      'Срок',
      'Источник (Чек-лист)',
      'Фото',
    ];

    // Готовим данные для таблицы
    int counter = 0;
    final List<List<String>> data =
        deficiencies.map((def) {
          counter++;
          ChecklistInstance? instance = instancesMap[def.instanceId];
          ChecklistTemplate? template =
              instance != null ? templatesMap[instance.templateId] : null;

          String sourceInfo = 'N/A';
          if (instance != null && template != null) {
            sourceInfo =
                '${template.name} (п. ${def.checklistItemId ?? 'N/A'}) от ${instance.date.day}.${instance.date.month}.${instance.date.year}';
          } else if (instance != null) {
            sourceInfo =
                'Проверка от ${instance.date.day}.${instance.date.month}.${instance.date.year} (п. ${def.checklistItemId ?? 'N/A'})';
          } else if (def.checklistItemId != null) {
            // Если это несоответствие создано вручную, но как-то связан пункт
            sourceInfo = 'Пункт ID: ${def.checklistItemId}';
          } else {
            sourceInfo = 'Создано вручную';
          }

          return [
            counter.toString(),
            def.description,
            _getDeficiencyStatusName(
              def.status,
            ), // Используем тот же helper, что и в DeficiencyListScreen
            def.assignedTo ?? 'N/A',
            def.dueDate != null
                ? '${def.dueDate!.day}.${def.dueDate!.month}.${def.dueDate!.year}'
                : 'N/A',
            sourceInfo,
            (def.photoPath != null && def.photoPath!.isNotEmpty) ? 'Да' : 'Нет',
          ];
        }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
        fontSize: 9,
      ), // Уменьшил шрифт заголовков
      cellStyle: const pw.TextStyle(fontSize: 8), // Уменьшил шрифт ячеек
      cellAlignment: pw.Alignment.centerLeft,
      cellAlignments: {
        0: pw.Alignment.centerRight,
        2: pw.Alignment.center,
        5: pw.Alignment.center,
      },
      columnWidths: {
        // Примерная ширина колонок
        0: const pw.FlexColumnWidth(0.4), // №
        1: const pw.FlexColumnWidth(2.0), // Описание (уменьшили)
        2: const pw.FlexColumnWidth(0.8), // Статус
        3: const pw.FlexColumnWidth(1.0), // Ответственный (новая колонка)
        4: const pw.FlexColumnWidth(0.8), // Срок
        5: const pw.FlexColumnWidth(1.5), // Источник (уменьшили)
        6: const pw.FlexColumnWidth(0.5), // Фото
      },
    );
  }
  // ---------------------------------------------------------

  // Шапка отчета
  pw.Widget _buildHeader(
    pw.Context context,
    ChecklistInstance instance,
    ChecklistTemplate template,
    UserProfile? userProfile,
  ) {
    // Helper для форматирования даты
    String formatDate(DateTime? dt) {
      if (dt == null) return 'N/A';
      return "${dt.day.toString().padLeft(2, '0')}.${dt.month.toString().padLeft(2, '0')}.${dt.year}";
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          template.name,
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Судно: ${instance.shipName ?? 'N/A'}'),
                pw.Text('Порт: ${instance.port ?? 'N/A'}'),
                pw.Text(
                  'Проверяющий: ${instance.inspectorName ?? userProfile?.name ?? 'N/A'}',
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Капитан: ${instance.captainNameOnCheck ?? 'N/A'}'),
                pw.Text('Дата начала: ${formatDate(instance.date)}'),
                pw.Text(
                  'Дата завершения: ${formatDate(instance.completionDate)}',
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(),
      ],
    );
  }

  // Таблица с пунктами чек-листа
  pw.Widget _buildItemsTable(
    pw.Context context,
    ChecklistInstance instance,
    ChecklistTemplate template,
  ) {
    final headers = ['№', 'Пункт Проверки', 'Статус', 'Комментарий', 'Фото'];

    // Готовим данные для таблицы
    final List<List<String>> data =
        template.items.map((item) {
          final response = instance.responses.firstWhere(
            (r) => r.itemId == item.order,
            orElse:
                () => ChecklistItemResponse(
                  itemId: item.order,
                ), // Пустой ответ, если не найден
          );

          return [
            item.order.toString(),
            '${item.section != null ? "[${item.section}] " : ""}${item.text}${item.details != null ? "\nДетали: ${item.details}" : ""}', // Пункт + Детали
            _getItemResponseStatusName(response.status), // Статус
            response.comment ?? '', // Комментарий
            (response.photoPath != null && response.photoPath!.isNotEmpty)
                ? 'Да'
                : 'Нет', // Наличие фото
          ];
        }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 9),
      cellAlignment: pw.Alignment.centerLeft,
      cellAlignments: {
        0: pw.Alignment.centerRight,
        2: pw.Alignment.center,
      }, // Выравнивание для колонок
      columnWidths: {
        // Примерная ширина колонок
        0: const pw.FlexColumnWidth(0.5), // №
        1: const pw.FlexColumnWidth(4.5), // Пункт
        2: const pw.FlexColumnWidth(1), // Статус
        3: const pw.FlexColumnWidth(2.5), // Комментарий
        4: const pw.FlexColumnWidth(0.5), // Фото
      },
    );
  }

  // Убедитесь, что этот метод есть в PdfGeneratorService
  String _getDeficiencyStatusName(DeficiencyStatus status) {
    switch (status) {
      case DeficiencyStatus.open:
        return 'Открыто';
      case DeficiencyStatus.inProgress:
        return 'В работе';
      case DeficiencyStatus.closed:
        return 'Закрыто';
      // Нет default и нет return после switch, так как все значения enum покрыты.
    }
    // Никакого return здесь быть не должно, если switch исчерпывающий.
    // Если анализатор все еще требует return здесь, значит,
    // он не считает switch исчерпывающим (например, если enum был изменен,
    // а build_runner не был запущен, или если enum передается как nullable `DeficiencyStatus?`).
    // Но параметр у нас `DeficiencyStatus status` (не nullable).
  }

  // Вспомогательная функция для получения имени статуса пункта
  String _getItemResponseStatusName(ItemResponseStatus? status) {
    if (status == null) return 'N/A';
    switch (status) {
      case ItemResponseStatus.ok:
        return 'OK';
      case ItemResponseStatus.notOk:
        return 'Не ОК';
      case ItemResponseStatus.na:
        return 'N/A';
    }
  }
}
