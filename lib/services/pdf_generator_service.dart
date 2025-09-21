import 'dart:typed_data';


import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import '../models/checklist_instance.dart';
import '../models/checklist_template.dart';
import '../models/deficiency.dart';
import '../models/enums.dart';
import '../models/user_profile.dart';
import '../models/checklist_item_response.dart';

/// Сервис, отвечающий за создание PDF-документов.
///
/// Инкапсулирует всю логику работы с пакетом `pdf`, предоставляя два основных
/// метода для генерации отчетов: по проверке и по несоответствиям.
class PdfGeneratorService {
  /// Генерирует PDF-отчет для одного конкретного экземпляра чек-листа.
  ///
  /// Собирает всю информацию о проверке, включая ответы на каждый пункт,
  /// и форматирует ее в виде таблицы.
  Future<Uint8List> generateChecklistInstancePdf(
    ChecklistInstance instance,
    ChecklistTemplate template,
    UserProfile? userProfile,
  ) async {
    // Загрузка шрифта, поддерживающего кириллицу, из ассетов.
    final fontData = await rootBundle.load("assets/fonts/DejaVuSans.ttf");
    final ttfFont = pw.Font.ttf(fontData);
    final pdfTheme = pw.ThemeData.withFont(base: ttfFont, bold: ttfFont);

    final pdf = pw.Document(theme: pdfTheme);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildPageHeader(context, template.name),
        footer: (context) => _buildPageFooter(context),
        build: (context) => [
          _buildChecklistReportHeader(instance, template, userProfile),
          pw.SizedBox(height: 20),
          _buildItemsTable(instance, template),
        ],
      ),
    );

    return pdf.save();
  }

  /// Генерирует сводный PDF-отчет по всем несоответствиям для указанного судна.
  Future<Uint8List> generateShipDeficiencyReportPdf(
    String targetShipName,
    List<Deficiency> deficienciesForShip,
    UserProfile? userProfile,
    Map<dynamic, ChecklistInstance> instancesMap,
    Map<dynamic, ChecklistTemplate> templatesMap,
  ) async {
    final fontData = await rootBundle.load("assets/fonts/DejaVuSans.ttf");
    final ttfFont = pw.Font.ttf(fontData);
    final pdfTheme = pw.ThemeData.withFont(base: ttfFont, bold: ttfFont);

    final pdf = pw.Document(theme: pdfTheme);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _buildPageHeader(context, 'Non-Conformity Report - Vessel: $targetShipName'),
        footer: (context) => _buildPageFooter(context),
        build: (pageContext) => [
          _buildDeficiencyReportHeader(targetShipName, userProfile),
          pw.SizedBox(height: 20),
          _buildDeficienciesTable(deficienciesForShip, instancesMap, templatesMap),
        ],
      ),
    );
    return pdf.save();
  }

  // --- Вспомогательные методы для построения частей PDF ---

  /// Строит верхний колонтитул для страниц (кроме первой).
  pw.Widget _buildPageHeader(pw.Context context, String title) {
    if (context.pageNumber == 1) {
      return pw.SizedBox(); // На первой странице колонтитул не нужен
    }
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
      child: pw.Text(
        title,
        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.grey),
      ),
    );
  }

  /// Строит нижний колонтитул с номерами страниц.
  pw.Widget _buildPageFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
      child: pw.Text(
        'Page. ${context.pageNumber} of ${context.pagesCount}',
        style: pw.Theme.of(context).defaultTextStyle.copyWith(color: PdfColors.grey),
      ),
    );
  }

  /// Строит "шапку" для отчета по конкретной проверке.
  pw.Widget _buildChecklistReportHeader(
    ChecklistInstance instance,
    ChecklistTemplate template,
    UserProfile? userProfile,
  ) {
    String formatDate(DateTime? dt) {
      if (dt == null) return 'N/A';
      return DateFormat('dd.MM.yyyy').format(dt);
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(template.name, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Vessel: ${instance.shipName ?? 'N/A'}'),
                pw.Text('Port: ${instance.port ?? 'N/A'}'),
                pw.Text('Inspector: ${instance.inspectorName ?? userProfile?.name ?? 'N/A'}'),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Captain: ${instance.captainNameOnCheck ?? 'N/A'}'),
                pw.Text('Start date: ${formatDate(instance.date)}'),
                pw.Text('Completion date: ${formatDate(instance.completionDate)}'),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(),
      ],
    );
  }

  /// Строит "шапку" для сводного отчета по несоответствиям.
  pw.Widget _buildDeficiencyReportHeader(
    String targetShipName,
    UserProfile? userProfile,
  ) {
    String formatDate(DateTime? dt) {
      if (dt == null) return 'N/A';
      return DateFormat('dd.MM.yyyy').format(dt);
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Non-Conformity Report', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
        pw.Text('Vessel: $targetShipName', style: pw.TextStyle(fontSize: 16)),
        pw.SizedBox(height: 5),
        pw.Text('Inspector: ${userProfile?.name ?? 'N/A'}', style: const pw.TextStyle(fontSize: 12)),
        pw.Text('Date: ${formatDate(DateTime.now())}', style: const pw.TextStyle(fontSize: 12)),
        pw.SizedBox(height: 10),
        pw.Divider(),
      ],
    );
  }

  /// Строит таблицу с пунктами чек-листа и ответами на них.
  pw.Widget _buildItemsTable(
    ChecklistInstance instance,
    ChecklistTemplate template,
  ) {
    final headers = ['№', 'Item', 'Status', 'Comment', 'Photo'];

    final data = template.items.map((item) {
      final response = instance.responses.firstWhere(
        (r) => r.itemId == item.order,
        orElse: () => ChecklistItemResponse(itemId: item.order),
      );
      return [
        item.order.toString(),
        '${item.section != null ? "[${item.section}] " : ""}${item.text}${item.details != null ? "\nDetails: ${item.details}" : ""}',
        _getItemResponseStatusName(response.status),
        response.comment ?? '',
        (response.photoPath != null && response.photoPath!.isNotEmpty) ? 'Yes' : 'No',
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
        4: pw.Alignment.center,
      },
      columnWidths: {
        0: const pw.FlexColumnWidth(0.5),
        1: const pw.FlexColumnWidth(4.5),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(2.5),
        4: const pw.FlexColumnWidth(0.5),
      },
    );
  }

  /// Строит таблицу со списком несоответствий.
  pw.Widget _buildDeficienciesTable(
    List<Deficiency> deficiencies,
    Map<dynamic, ChecklistInstance> instancesMap,
    Map<dynamic, ChecklistTemplate> templatesMap,
  ) {
    final headers = ['№', 'Description', 'Status', 'Responsible', 'Date', 'Sourse', 'Photo'];
    int counter = 0;
    final data = deficiencies.map((def) {
      counter++;
      final instance = instancesMap[def.instanceId];
      final template = instance != null ? templatesMap[instance.templateId] : null;

      String sourceInfo;
      if (instance != null && template != null) {
        sourceInfo = '${template.name} (п. ${def.checklistItemId ?? 'N/A'}) от ${DateFormat('dd.MM.yy').format(instance.date)}';
      } else {
        sourceInfo = 'Manual Entry';
      }

      return [
        counter.toString(),
        def.description,
        _getDeficiencyStatusName(def.status),
        def.assignedTo ?? 'N/A',
        def.dueDate != null ? DateFormat('dd.MM.yyyy').format(def.dueDate!) : 'N/A',
        sourceInfo,
        (def.photoPath != null && def.photoPath!.isNotEmpty) ? 'Yes' : 'No',
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey600, width: 0.5),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 9),
      cellStyle: const pw.TextStyle(fontSize: 8),
      cellAlignment: pw.Alignment.centerLeft,
      cellAlignments: {
        0: pw.Alignment.centerRight,
        2: pw.Alignment.center,
        4: pw.Alignment.center,
        6: pw.Alignment.center,
      },
      columnWidths: {
        0: const pw.FlexColumnWidth(0.4),
        1: const pw.FlexColumnWidth(2.0),
        2: const pw.FlexColumnWidth(0.8),
        3: const pw.FlexColumnWidth(1.0),
        4: const pw.FlexColumnWidth(0.8),
        5: const pw.FlexColumnWidth(1.5),
        6: const pw.FlexColumnWidth(0.5),
      },
    );
  }

  /// Вспомогательная функция для преобразования статуса несоответствия в строку.
  String _getDeficiencyStatusName(DeficiencyStatus status) {
    switch (status) {
      case DeficiencyStatus.open:
        return 'Open';
      case DeficiencyStatus.inProgress:
        return 'In Progress';
      case DeficiencyStatus.closed:
        return 'Closed';
    }
  }

  /// Вспомогательная функция для преобразования статуса ответа на пункт в строку.
  String _getItemResponseStatusName(ItemResponseStatus? status) {
    if (status == null) return 'N/A';
    switch (status) {
      case ItemResponseStatus.ok:
        return 'OK';
      case ItemResponseStatus.notOk:
        return 'Not OK';
      case ItemResponseStatus.na:
        return 'N/A';
    }
  }
}
