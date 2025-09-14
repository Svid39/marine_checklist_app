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
import 'app_settings_screen.dart';
import 'checklist_execution_screen.dart';
import 'deficiency_list_screen.dart';
import 'template_selection_screen.dart';

/// Главный экран приложения (Дашборд).
///
/// Отображает списки проверок (в процессе и завершенных),
/// счетчик открытых несоответствий и предоставляет навигацию
/// к основным функциям приложения.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  /// Профиль текущего пользователя для отображения в AppBar.
  UserProfile? _userProfile;
  /// Карта шаблонов для быстрого доступа к имени шаблона по его ключу.
  Map<dynamic, ChecklistTemplate> _templateMap = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  /// Загружает из Hive данные, которые не требуют постоянного обновления:
  /// профиль пользователя и карту шаблонов.
  Future<void> _loadInitialData() async {
    try {
      final profileBox = Hive.box<UserProfile>(userProfileBoxName);
      final templatesBox = Hive.box<ChecklistTemplate>(templatesBoxName);
      if (mounted) {
        setState(() {
          _userProfile = profileBox.get(1);
          _templateMap = templatesBox.toMap();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).errorLoadingData),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Осуществляет переход на экран выполнения/просмотра проверки.
  void _navigateToExecution(dynamic instanceKey, String? templateName) {
    if (instanceKey == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChecklistExecutionScreen(
          instanceKey: instanceKey,
          checklistName: templateName ?? S.of(context).unnamedCheck,
        ),
      ),
    );
  }

  /// Показывает диалог с подтверждением перед удалением проверки.
  Future<void> _showDeleteConfirmationDialog(
    dynamic instanceKey,
    String? checklistName,
  ) async {
    if (!mounted) return;

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
              Text(
                S.of(context).deleteChecklistConfirmation(
                      checklistName ?? S.of(context).unnamedCheck,
                    ),
              ),
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

    // Безопасное освобождение ресурсов после закрытия диалога.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      confirmController.removeListener(confirmationListener);
      confirmController.dispose();
      deleteEnabled.dispose();
    });

    if (confirmed == true && mounted) {
      await _deleteChecklistInstance(instanceKey);
    }
  }

  /// Удаляет экземпляр проверки из Hive.
  Future<void> _deleteChecklistInstance(dynamic instanceKey) async {
    try {
      final instancesBox = Hive.box<ChecklistInstance>(instancesBoxName);
      await instancesBox.delete(instanceKey);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).checkDeleted),
          backgroundColor: Colors.orange,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).errorDeleting),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Запускает генерацию и отправку PDF-отчета для указанной проверки.
  Future<void> _generateAndShareChecklistPdf(
    dynamic instanceKey,
    String? checklistName,
  ) async {
    if (!mounted) return;

    // TODO: Здесь рекомендуется использовать улучшенный индикатор загрузки,
    // который мы обсуждали.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(S.of(context)
            .generatingPdfFor(checklistName ?? S.of(context).report)),
      ),
    );

    try {
      final instance =
          Hive.box<ChecklistInstance>(instancesBoxName).get(instanceKey);
      if (instance == null) throw Exception(S.of(context).instanceNotFound);

      final template = _templateMap[instance.templateId];
      if (template == null) throw Exception(S.of(context).templateNotFound);

      final pdfBytes = await PdfGeneratorService().generateChecklistInstancePdf(
        instance,
        template,
        _userProfile,
      );

      final tempDir = await getTemporaryDirectory();
      final safeName =
          checklistName?.replaceAll(RegExp(r'[^\w\s]+'), '').replaceAll(' ', '_') ??
              'report';
      final filePath = '${tempDir.path}/${safeName}_$instanceKey.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      List<String> photoPaths = [];
      for (var response in instance.responses) {
        if (response.photoPath != null && response.photoPath!.isNotEmpty) {
          if (await File(response.photoPath!).exists()) {
            photoPaths.add(response.photoPath!);
          }
        }
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      
      final filesToShare = [XFile(filePath), ...photoPaths.map((p) => XFile(p))];
      final shareParams = ShareParams(
        text: S.of(context).checkReportSubject(template.name),
        files: filesToShare,
      );
      await SharePlus.instance.share(shareParams);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).pdfError),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final instancesBox = Hive.box<ChecklistInstance>(instancesBoxName);
    final deficienciesBox = Hive.box<Deficiency>(deficienciesBoxName);

    return Scaffold(
      appBar: AppBar(
        title: Text(_userProfile?.position ?? S.of(context).dashboard),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(_userProfile?.name ?? S.of(context).user),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: S.of(context).profileSettings,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const AppSettingsScreen(isFirstRun: false),
                ),
              );
              // Обновляем данные профиля после возвращения с экрана настроек.
              _loadInitialData();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // --- Кнопка создания новой проверки ---
            ElevatedButton.icon(
              icon: const Icon(Icons.add_circle_outline),
              label: Text(S.of(context).startNewCheck),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TemplateSelectionScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 16),

            // --- Реактивные списки ---
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: instancesBox.listenable(),
                builder: (context, Box<ChecklistInstance> instances, _) {
                  return ValueListenableBuilder(
                    valueListenable: deficienciesBox.listenable(),
                    builder: (context, Box<Deficiency> deficiencies, _) {
                      // Логика фильтрации и подсчета вынесена для ясности.
                      final inProgress = instances.values
                          .where((i) => i.status == ChecklistInstanceStatus.inProgress)
                          .toList();
                      final completed = instances.values
                          .where((i) => i.status == ChecklistInstanceStatus.completed)
                          .toList();
                      final openDeficienciesCount = deficiencies.values
                          .where((d) => d.status != DeficiencyStatus.closed)
                          .length;

                      return ListView(
                        children: [
                          _buildDeficienciesTile(openDeficienciesCount),
                          const Divider(),
                          const SizedBox(height: 16),
                          _buildInstanceList(
                            title: S.of(context).checksInProgress(inProgress.length),
                            instances: inProgress,
                            isCompletedList: false,
                          ),
                          const SizedBox(height: 24),
                          _buildInstanceList(
                            title: S.of(context).completedChecks(completed.length),
                            instances: completed,
                            isCompletedList: true,
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Строит плитку для отображения счетчика и навигации к несоответствиям.
  Widget _buildDeficienciesTile(int count) {
    return ListTile(
      leading: const Icon(Icons.warning_amber_rounded, color: Colors.orangeAccent),
      title: Text(S.of(context).openDeficiencies,
          style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: count > 0 ? Colors.redAccent : Colors.blueGrey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$count',
          style: const TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DeficiencyListScreen()),
        );
      },
    );
  }
  
  /// Строит секцию списка проверок (в процессе или завершенных).
  Widget _buildInstanceList({
    required String title,
    required List<ChecklistInstance> instances,
    required bool isCompletedList,
  }) {
    // Helper для форматирования даты, чтобы не передавать context глубоко.
    String formatDate(DateTime dt) {
        return DateFormat.yMd(Localizations.localeOf(context).languageCode).format(dt);
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        const Divider(),
        if (instances.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(isCompletedList
                  ? S.of(context).noCompletedChecks
                  : S.of(context).noActiveChecks),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true, // Важно для ListView внутри другого ListView
            physics: const NeverScrollableScrollPhysics(), // и отключения его скролла
            itemCount: instances.length,
            itemBuilder: (context, index) {
              final instance = instances[index];
              final template = _templateMap[instance.templateId];
              return ListTile(
                title: Text(template?.name ?? S.of(context).unknownTemplate),
                subtitle: _buildSubtitle(instance, formatDate),
                onTap: () => _navigateToExecution(instance.key, template?.name),
                trailing: _buildTrailingButtons(instance, template?.name, isCompletedList),
              );
            },
          ),
      ],
    );
  }

  /// Строит подзаголовок для плитки проверки.
  Widget _buildSubtitle(ChecklistInstance instance, String Function(DateTime) formatDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(instance.completionDate != null
            ? S.of(context).completedOn(formatDate(instance.completionDate!))
            : S.of(context).startedOn(formatDate(instance.date))),
        if (instance.shipName != null && instance.shipName!.isNotEmpty)
          Text(S.of(context).vessel(instance.shipName!),
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        if (instance.port != null && instance.port!.isNotEmpty)
          Text(S.of(context).port(instance.port!),
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
  
  /// Строит кнопки действий (PDF, Удалить) для плитки проверки.
  Widget _buildTrailingButtons(ChecklistInstance instance, String? templateName, bool isCompleted) {
    // Общие свойства для компактных иконок
    const iconSize = 20.0;
    const padding = EdgeInsets.zero;
    const visualDensity = VisualDensity.compact;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isCompleted) // Кнопка PDF только для завершенных
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            iconSize: iconSize,
            padding: padding,
            visualDensity: visualDensity,
            tooltip: S.of(context).createPdfReport,
            onPressed: () => _generateAndShareChecklistPdf(instance.key, templateName),
          ),
        IconButton(
          icon: Icon(Icons.delete_outline, color: Colors.red.withAlpha(179)),
          iconSize: iconSize,
          padding: padding,
          visualDensity: visualDensity,
          tooltip: S.of(context).deleteCheck,
          onPressed: () => _showDeleteConfirmationDialog(instance.key, templateName),
        ),
      ],
    );
  }
}
