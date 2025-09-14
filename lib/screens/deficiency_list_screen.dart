import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:marine_checklist_app/generated/l10n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../main.dart';
import '../models/checklist_instance.dart';
import '../models/checklist_template.dart';
import '../models/deficiency.dart';
import '../models/enums.dart';
import '../models/user_profile.dart';
import '../services/pdf_generator_service.dart';
import 'deficiency_detail_screen.dart';

/// Экран для отображения, фильтрации и управления списком всех несоответствий.
class DeficiencyListScreen extends StatefulWidget {
  const DeficiencyListScreen({super.key});

  @override
  State<DeficiencyListScreen> createState() => _DeficiencyListScreenState();
}

class _DeficiencyListScreenState extends State<DeficiencyListScreen> {
  /// Текущий выбранный статус для фильтрации списка. `null` означает "Все".
  DeficiencyStatus? _selectedFilterStatus;

  /// Показывает диалог с подтверждением перед удалением несоответствия.
  Future<void> _showDeleteConfirmationDialog(
    dynamic deficiencyKey,
    String? deficiencyDescription,
  ) async {
    // Этот метод теперь использует context класса, а не переданный.
    final confirmController = TextEditingController();
    final deleteEnabled = ValueNotifier<bool>(false);

    void confirmationListener() {
      deleteEnabled.value =
          confirmController.text.trim() == S.of(context).deleteWord;
    }
    confirmController.addListener(confirmationListener);

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).confirmDeletion),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(S.of(context).deleteDeficiencyConfirmation(
                  deficiencyDescription ?? S.of(context).noDescription)),
              const SizedBox(height: 15),
              Text(
                S.of(context).enterDeleteToConfirm,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 5),
              ValueListenableBuilder<bool>(
                valueListenable: deleteEnabled,
                builder: (context, isEnabled, child) {
                  return TextField(
                    controller: confirmController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: S.of(context).deleteWord,
                      isDense: true,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    onChanged: (_) => confirmationListener(),
                  );
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () => Navigator.pop(dialogContext, false),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: deleteEnabled,
              builder: (context, isEnabled, child) {
                return TextButton(
                  onPressed:
                      isEnabled ? () => Navigator.pop(dialogContext, true) : null,
                  style: TextButton.styleFrom(
                    foregroundColor: isEnabled ? Colors.red : Colors.grey,
                  ),
                  child: Text(S.of(context).deleteButton),
                );
              },
            ),
          ],
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      confirmController.removeListener(confirmationListener);
      confirmController.dispose();
      deleteEnabled.dispose();
    });

    if (confirmed == true && mounted) {
      await _deleteDeficiency(deficiencyKey);
    }
  }

  /// Удаляет указанное несоответствие из базы данных Hive.
  Future<void> _deleteDeficiency(dynamic deficiencyKey) async {
    try {
      final deficienciesBox = Hive.box<Deficiency>(deficienciesBoxName);
      await deficienciesBox.delete(deficiencyKey);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).deficiencyDeleted),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).errorDeletingDeficiency),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Генерирует и предлагает поделиться PDF-отчетом по всем несоответствиям
  /// для судна, указанного в профиле пользователя.
  Future<void> _generateAndShareDeficiencyReport() async {
    if (!mounted) return;

    // TODO: Здесь рекомендуется использовать улучшенный индикатор загрузки.
    final profileBox = Hive.box<UserProfile>(userProfileBoxName);
    final userProfile = profileBox.get(1);
    final String? targetShipName = userProfile?.shipName;

    if (targetShipName == null || targetShipName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).vesselNameNotInProfile), backgroundColor: Colors.orange),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).generatingPdfReportForVessel(targetShipName))),
    );

    try {
      final instancesBox = Hive.box<ChecklistInstance>(instancesBoxName);
      final templatesBox = Hive.box<ChecklistTemplate>(templatesBoxName);
      final deficienciesBox = Hive.box<Deficiency>(deficienciesBoxName);

      final allInstancesMap = instancesBox.toMap();
      final allTemplatesMap = templatesBox.toMap();

      final deficienciesForShip = deficienciesBox.values.where((deficiency) {
        if (deficiency.instanceId == null) return false;
        final instance = allInstancesMap[deficiency.instanceId];
        return instance != null && instance.shipName == targetShipName;
      }).toList();

      if (deficienciesForShip.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).noDeficienciesFoundForVessel(targetShipName)), backgroundColor: Colors.orange),
        );
        return;
      }

      deficienciesForShip.sort((a, b) {
        int statusCompare = a.status.index.compareTo(b.status.index);
        if (statusCompare != 0) return statusCompare;
        return (a.dueDate ?? DateTime(0)).compareTo(b.dueDate ?? DateTime(0));
      });

      final pdfBytes = await PdfGeneratorService().generateShipDeficiencyReportPdf(
          targetShipName, deficienciesForShip, userProfile, allInstancesMap, allTemplatesMap,
      );
      
      if (!mounted) return;
      
      final tempDir = await getTemporaryDirectory();
      final safeShipName = targetShipName.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '_');
      final filePath = '${tempDir.path}/deficiency_report_${safeShipName}_${DateTime.now().toIso8601String().split('T').first}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      if (!mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      
      final shareParams = ShareParams(
        text: S.of(context).deficiencyReportForVessel(targetShipName),
        files: [XFile(filePath)],
      );
      await SharePlus.instance.share(shareParams);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).pdfError), backgroundColor: Colors.red),
      );
    }
  }

  /// Преобразует статус [DeficiencyStatus] в локализованную строку.
  String _getDeficiencyStatusName(DeficiencyStatus status) {
    switch (status) {
      case DeficiencyStatus.open:
        return S.of(context).statusOpen;
      case DeficiencyStatus.inProgress:
        return S.of(context).statusInProgress;
      case DeficiencyStatus.closed:
        return S.of(context).statusClosed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deficienciesBox = Hive.box<Deficiency>(deficienciesBoxName);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).deficiencyList),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: S.of(context).pdfReportForDeficienciesTooltip,
            onPressed: _generateAndShareDeficiencyReport,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilter(),
          const Divider(height: 1),
          _buildContent(deficienciesBox),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DeficiencyDetailScreen(),
            ),
          );
        },
        tooltip: S.of(context).addDeficiency,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Строит виджет [SegmentedButton] для фильтрации списка.
  Widget _buildFilter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SegmentedButton<DeficiencyStatus?>(
        segments: <ButtonSegment<DeficiencyStatus?>>[
          ButtonSegment<DeficiencyStatus?>(
            value: null,
            label: Text(S.of(context).filterAll),
            icon: const Icon(Icons.list_alt_rounded),
          ),
          ...DeficiencyStatus.values.map(
            (status) => ButtonSegment<DeficiencyStatus?>(
              value: status,
              label: Text(_getDeficiencyStatusName(status)),
            ),
          ),
        ],
        selected: <DeficiencyStatus?>{_selectedFilterStatus},
        onSelectionChanged: (Set<DeficiencyStatus?> newSelection) {
          setState(() {
            _selectedFilterStatus = newSelection.first;
          });
        },
      ),
    );
  }

  /// Строит основное содержимое экрана: список несоответствий.
  Widget _buildContent(Box<Deficiency> deficienciesBox) {
    return Expanded(
      child: ValueListenableBuilder(
        valueListenable: deficienciesBox.listenable(),
        builder: (context, Box<Deficiency> box, _) {
          final deficienciesList = box.values
              .where((def) => _selectedFilterStatus == null || def.status == _selectedFilterStatus)
              .toList();

          if (deficienciesList.isEmpty) {
            return Center(
              child: Text(S.of(context).noDeficienciesRegistered),
            );
          }

          return ListView.builder(
            itemCount: deficienciesList.length,
            itemBuilder: (context, index) {
              final deficiency = deficienciesList[index];
              return _buildDeficiencyListItem(deficiency);
            },
          );
        },
      ),
    );
  }

  /// Строит одну плитку [ListTile] для отображения несоответствия.
  Widget _buildDeficiencyListItem(Deficiency deficiency) {
    final statusStyle = _getStatusStyle(deficiency.status, deficiency.dueDate);
    String formatDate(DateTime dt) {
        return DateFormat.yMd(Localizations.localeOf(context).languageCode).format(dt);
    }
    
    return ListTile(
      leading: Icon(statusStyle['icon'], color: statusStyle['color'], size: 28),
      title: Text(deficiency.description, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(fontSize: 12),
          children: <TextSpan>[
            TextSpan(
              text: S.of(context).statusLabel(_getDeficiencyStatusName(deficiency.status)),
              style: TextStyle(color: statusStyle['color'], fontWeight: statusStyle['fontWeight']),
            ),
            if (deficiency.dueDate != null)
              TextSpan(
                text: S.of(context).dueDateLabel(formatDate(deficiency.dueDate!)),
                style: TextStyle(color: statusStyle['isOverdue'] ? Colors.red : null, fontWeight: statusStyle['isOverdue'] ? FontWeight.bold : FontWeight.normal),
              ),
          ],
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_outline, color: Colors.red.withAlpha(196)),
        tooltip: S.of(context).deleteDeficiency,
        onPressed: () => _showDeleteConfirmationDialog(deficiency.key, deficiency.description),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeficiencyDetailScreen(deficiencyKey: deficiency.key),
          ),
        );
      },
    );
  }

  /// Возвращает Map со стилями (иконка, цвет, шрифт) в зависимости от статуса несоответствия.
  Map<String, dynamic> _getStatusStyle(DeficiencyStatus status, DateTime? dueDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    bool isOverdue = false;
    if (dueDate != null && status != DeficiencyStatus.closed) {
      final normalizedDueDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
      isOverdue = normalizedDueDate.isBefore(today);
    }

    if (status == DeficiencyStatus.closed) {
      return {'color': Colors.green, 'icon': Icons.check_circle_outline, 'fontWeight': FontWeight.normal, 'isOverdue': false};
    }
    if (isOverdue) {
      return {'color': Colors.red, 'icon': Icons.error_outline, 'fontWeight': FontWeight.bold, 'isOverdue': true};
    }
    if (status == DeficiencyStatus.open) {
      return {'color': Colors.orangeAccent, 'icon': Icons.warning_amber_rounded, 'fontWeight': FontWeight.normal, 'isOverdue': false};
    }
    // if (status == DeficiencyStatus.inProgress)
    return {'color': Colors.blueAccent, 'icon': Icons.hourglass_empty_rounded, 'fontWeight': FontWeight.normal, 'isOverdue': false};
  }
}