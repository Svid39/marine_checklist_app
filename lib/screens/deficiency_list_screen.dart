// Файл: lib/screens/deficiency_list_screen.dart

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:marine_checklist_app/generated/l10n.dart'; // <-- ИМПОРТ

import '../services/pdf_generator_service.dart';
import '../models/user_profile.dart';
import '../models/checklist_instance.dart';
import '../models/checklist_template.dart';
import '../main.dart';
import '../models/deficiency.dart';
import 'deficiency_detail_screen.dart';
import '../models/enums.dart';

class DeficiencyListScreen extends StatefulWidget {
  const DeficiencyListScreen({super.key});

  @override
  State<DeficiencyListScreen> createState() => _DeficiencyListScreenState();
}

class _DeficiencyListScreenState extends State<DeficiencyListScreen> {
  DeficiencyStatus? _selectedFilterStatus;

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    dynamic deficiencyKey,
    String? deficiencyDescription,
  ) async {
    final TextEditingController confirmController = TextEditingController();
    final ValueNotifier<bool> deleteEnabled = ValueNotifier<bool>(false);

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
                    onChanged: (_) {
                      confirmationListener();
                    },
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
                  onPressed: isEnabled
                      ? () => Navigator.pop(dialogContext, true)
                      : null,
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

  Future<void> _deleteDeficiency(
    
    dynamic deficiencyKey,
  ) async {
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

  Future<void> _generateAndShareDeficiencyReport() async { // <-- УБРАЛИ BuildContext context
  if (!Hive.isBoxOpen(userProfileBoxName) ||
      !Hive.isBoxOpen(instancesBoxName) ||
      !Hive.isBoxOpen(templatesBoxName) ||
      !Hive.isBoxOpen(deficienciesBoxName)) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).errorHiveBoxesNotOpen), backgroundColor: Colors.red),
    );
    return;
  }

  final profileBox = Hive.box<UserProfile>(userProfileBoxName);
  final userProfile = profileBox.get(1);
  final String? targetShipName = userProfile?.shipName;

  if (targetShipName == null || targetShipName.isEmpty) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).vesselNameNotInProfile), backgroundColor: Colors.orange),
    );
    return;
  }

  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(S.of(context).generatingPdfReportForVessel(targetShipName))),
  );

  try {
    final instancesBox = Hive.box<ChecklistInstance>(instancesBoxName);
    final templatesBox = Hive.box<ChecklistTemplate>(templatesBoxName);
    final deficienciesBox = Hive.box<Deficiency>(deficienciesBoxName);

    final Map<dynamic, ChecklistInstance> allInstancesMap = instancesBox.toMap();
    final Map<dynamic, ChecklistTemplate> allTemplatesMap = templatesBox.toMap();

    List<Deficiency> deficienciesForShip = [];
    for (var defEntry in deficienciesBox.toMap().entries) {
      final deficiency = defEntry.value;
      if (deficiency.instanceId != null) {
        final instance = allInstancesMap[deficiency.instanceId];
        if (instance != null && instance.shipName == targetShipName) {
          deficienciesForShip.add(deficiency);
        }
      }
    }

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

    final pdfService = PdfGeneratorService();
    final Uint8List pdfBytes = await pdfService.generateShipDeficiencyReportPdf(
      targetShipName, deficienciesForShip, userProfile, allInstancesMap, allTemplatesMap,
    );

    if (!mounted) return;

    final tempDir = await getTemporaryDirectory();
    if (!mounted) return;

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

  } catch (e, s) {
    debugPrint('Ошибка при генерации PDF отчета по несоответствиям: $e\n$s');
    if (!mounted) return;
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(S.of(context).pdfError), backgroundColor: Colors.red),
    );
  }
}

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
    String formatDate(DateTime dt) {
      return DateFormat.yMd(Localizations.localeOf(context).languageCode)
          .format(dt);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).deficiencyList),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: S.of(context).pdfReportForDeficienciesTooltip,
            onPressed: () => _generateAndShareDeficiencyReport(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
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
          ),
          const Divider(),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: deficienciesBox.listenable(),
              builder: (context, Box<Deficiency> box, _) {
                var deficienciesList = box.toMap().entries.toList();

                if (_selectedFilterStatus != null) {
                  deficienciesList = deficienciesList
                      .where((entry) =>
                          entry.value.status == _selectedFilterStatus)
                      .toList();
                }

                if (deficienciesList.isEmpty) {
                  return Center(
                    child: Text(S.of(context).noDeficienciesRegistered),
                  );
                }

                return ListView.builder(
                  itemCount: deficienciesList.length,
                  itemBuilder: (context, index) {
                    final entry = deficienciesList[index];
                    final dynamic key = entry.key;
                    final Deficiency deficiency = entry.value;

                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    bool isItemOverdue = false;
                    if (deficiency.dueDate != null &&
                        deficiency.status != DeficiencyStatus.closed) {
                      final normalizedDueDate = DateTime(
                          deficiency.dueDate!.year,
                          deficiency.dueDate!.month,
                          deficiency.dueDate!.day);
                      isItemOverdue = normalizedDueDate.isBefore(today);
                    }
                    final bool isItemClosed =
                        deficiency.status == DeficiencyStatus.closed;
                    Color statusColor =
                        Theme.of(context).textTheme.bodySmall?.color ??
                            Colors.grey;
                    IconData statusIconData = Icons.help_outline;

                    if (isItemClosed) {
                      statusColor = Colors.green;
                      statusIconData = Icons.check_circle_outline;
                    } else if (isItemOverdue) {
                      statusColor = Colors.red;
                      statusIconData = Icons.error_outline;
                    } else if (deficiency.status == DeficiencyStatus.open) {
                      statusColor = Colors.orangeAccent;
                      statusIconData = Icons.warning_amber_rounded;
                    } else if (deficiency.status ==
                        DeficiencyStatus.inProgress) {
                      statusColor = Colors.blueAccent;
                      statusIconData = Icons.hourglass_empty_rounded;
                    }

                    return ListTile(
                      leading:
                          Icon(statusIconData, color: statusColor, size: 28),
                      title: Text(deficiency.description,
                          maxLines: 2, overflow: TextOverflow.ellipsis),
                      subtitle: RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context)
                              .style
                              .copyWith(fontSize: 12),
                          children: <TextSpan>[
                            TextSpan(
                              text: S.of(context).statusLabel(
                                  _getDeficiencyStatusName(deficiency.status)),
                              style: TextStyle(
                                  color: statusColor,
                                  fontWeight: isItemClosed || isItemOverdue
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                            if (deficiency.dueDate != null)
                              TextSpan(
                                text: S.of(context).dueDateLabel(
                                    formatDate(deficiency.dueDate!)),
                                style: TextStyle(
                                    color: isItemOverdue ? Colors.red : null,
                                    fontWeight: isItemOverdue
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete_outline,
                            color: Colors.red.withAlpha(196)),
                        tooltip: S.of(context).deleteDeficiency,
                        onPressed: () => _showDeleteConfirmationDialog(
                            context, key, deficiency.description),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DeficiencyDetailScreen(deficiencyKey: key),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
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
}

/* // Файл: lib/screens/deficiency_list_screen.dart

import 'dart:typed_data'; // Для Uint8List
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io'; // Для File
import '../services/pdf_generator_service.dart'; // Наш сервис
import '../models/user_profile.dart'; // Нужен UserProfile
import '../models/checklist_instance.dart'; // Нужен ChecklistInstance
import '../models/checklist_template.dart'; // Нужен ChecklistTemplate
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Для ValueListenableBuilder и Box
import '../main.dart'; // Для deficiencyBoxName
import '../models/deficiency.dart';
import 'deficiency_detail_screen.dart'; // Для навигации к деталям
import '../models/enums.dart'; // Импорт enums может понадобиться для _getStatusName, если вы его добавите

class DeficiencyListScreen extends StatefulWidget {
  // <--- ИЗМЕНЕНИЕ
  const DeficiencyListScreen({super.key});

  @override
  State<DeficiencyListScreen> createState() => _DeficiencyListScreenState(); // <--- ИЗМЕНЕНИЕ
}

// --- НОВЫЙ КЛАСС СОСТОЯНИЯ ---
class _DeficiencyListScreenState extends State<DeficiencyListScreen> {
  // --- НОВАЯ ПЕРЕМЕННАЯ СОСТОЯНИЯ для фильтра ---
  DeficiencyStatus? _selectedFilterStatus; // null означает "Все"
  // ----------------------------------------------

  // --- НОВЫЙ МЕТОД: Показ диалога подтверждения удаления ---
  Future<void> _showDeleteConfirmationDialog(
    BuildContext context, // Нужен BuildContext для showDialog
    dynamic deficiencyKey,
    String? deficiencyDescription,
  ) async {
    // Не используем if (!mounted) return; т.к. это StatelessWidget,
    // но showDialog сам проверяет context.

    final TextEditingController confirmController = TextEditingController();
    final ValueNotifier<bool> deleteEnabled = ValueNotifier<bool>(false);

    void confirmationListener() {
      deleteEnabled.value =
          confirmController.text.trim() == 'Delete'; // Проверяем текст
    }

    confirmController.addListener(confirmationListener);

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Подтвердите Удаление'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Вы уверены, что хотите удалить несоответствие:\n"${deficiencyDescription ?? 'Без описания'}"?\n\nЭто действие необратимо!',
              ),
              const SizedBox(height: 15),
              Text(
                "Пожалуйста, введите слово 'Delete' для подтверждения:",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 5),
              ValueListenableBuilder<bool>(
                valueListenable: deleteEnabled,
                builder: (context, isEnabled, child) {
                  return TextField(
                    controller: confirmController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Delete',
                      isDense: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    onChanged: (_) {
                      confirmationListener();
                    },
                  );
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () => Navigator.pop(dialogContext, false),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: deleteEnabled,
              builder: (context, isEnabled, child) {
                return TextButton(
                  onPressed:
                      isEnabled
                          ? () => Navigator.pop(dialogContext, true)
                          : null,
                  style: TextButton.styleFrom(
                    foregroundColor: isEnabled ? Colors.red : Colors.grey,
                  ),
                  child: const Text('УДАЛИТЬ'),
                );
              },
            ),
          ],
        );
      },
    );
    // Освобождаем ресурсы
    // Не используем addPostFrameCallback, т.к. это StatelessWidget,
    // но т.к. controller и notifier созданы локально в async методе,
    // они должны быть уничтожены после выхода из области видимости.
    // Для большей надежности, можно сделать этот виджет StatefulWidget, если возникнут проблемы.
    // Но пока попробуем так.
    // --- ИЗМЕНЕНИЕ: Безопасное освобождение ресурсов ---
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Проверка mounted здесь не нужна, т.к. мы уже не в контексте State виджета,
      // а контроллеры и уведомитель были созданы локально в этом async методе.
      // Главное, что этот код выполнится ПОСЛЕ завершения текущего кадра отрисовки,
      // когда диалог уже точно закрыт.
      confirmController.removeListener(
        confirmationListener,
      ); // Не забываем отписаться
      confirmController.dispose();
      deleteEnabled.dispose();
    });

    if (confirmed == true) {
      // Передаем context для SnackBar
      // ignore: use_build_context_synchronously
      await _deleteDeficiency(context, deficiencyKey);
    }
  }
  // ------------------------------------------------------

  // --- НОВЫЙ МЕТОД: Фактическое удаление из Hive ---
  Future<void> _deleteDeficiency(
    BuildContext context,
    dynamic deficiencyKey,
  ) async {
    // Принимает context
    try {
      final deficienciesBox = Hive.box<Deficiency>(deficienciesBoxName);
      await deficienciesBox.delete(deficiencyKey);
      debugPrint("Deficiency с ключом $deficiencyKey удалено.");

      // Проверяем mounted перед использованием context для SnackBar
      // (Хотя для StatelessWidget это менее критично, но хорошая практика)
      if (!context.mounted) return;
      if (ScaffoldMessenger.of(context).mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Несоответствие удалено'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      // ValueListenableBuilder сам обновит список
    } catch (e) {
      debugPrint("Ошибка удаления Deficiency с ключом $deficiencyKey: $e");
      if (!context.mounted) return;
      if (ScaffoldMessenger.of(context).mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка удаления: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  // --------------------------------------------------

  // Внутри _DeficiencyListScreenState (или как статический метод)

  Future<void> _generateAndShareDeficiencyReport(BuildContext context) async {
    // Передаем context
    if (!Hive.isBoxOpen(userProfileBoxName) ||
        !Hive.isBoxOpen(instancesBoxName) ||
        !Hive.isBoxOpen(templatesBoxName) ||
        !Hive.isBoxOpen(deficienciesBoxName)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ошибка: Не все ящики Hive открыты.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final profileBox = Hive.box<UserProfile>(userProfileBoxName);
    final userProfile = profileBox.get(1);
    final String? targetShipName = userProfile?.shipName;

    if (targetShipName == null || targetShipName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Название судна не указано в профиле!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Генерация PDF отчета для судна "$targetShipName"...'),
      ),
    );

    try {
      final instancesBox = Hive.box<ChecklistInstance>(instancesBoxName);
      final templatesBox = Hive.box<ChecklistTemplate>(templatesBoxName);
      final deficienciesBox = Hive.box<Deficiency>(deficienciesBoxName);

      // Готовим данные для PDF сервиса
      final Map<dynamic, ChecklistInstance> allInstancesMap =
          instancesBox.toMap();
      final Map<dynamic, ChecklistTemplate> allTemplatesMap =
          templatesBox.toMap();

      // Фильтруем несоответствия
      List<Deficiency> deficienciesForShip = [];
      for (var defEntry in deficienciesBox.toMap().entries) {
        final deficiency = defEntry.value;
        if (deficiency.instanceId != null) {
          // Связано с проверкой
          final instance = allInstancesMap[deficiency.instanceId];
          if (instance != null && instance.shipName == targetShipName) {
            deficienciesForShip.add(deficiency);
          }
        } else {
          // TODO: Как обрабатывать несоответствия, созданные вручную?
          // Если у них тоже должно быть поле shipName или они привязаны к судну из профиля на момент создания?
          // Пока пропускаем их, если они не привязаны к instance с нужным кораблем.
          // Или, если у Deficiency будет свое поле shipName, фильтровать по нему.
        }
      }

      if (deficienciesForShip.isEmpty) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Не найдено несоответствий для судна "$targetShipName"',
            ),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Сортируем по статусу и дате (опционально)
      deficienciesForShip.sort((a, b) {
        int statusCompare = a.status.index.compareTo(b.status.index);
        if (statusCompare != 0) return statusCompare;
        return (a.dueDate ?? DateTime(0)).compareTo(b.dueDate ?? DateTime(0));
      });

      final pdfService = PdfGeneratorService();
      final Uint8List pdfBytes = await pdfService
          .generateShipDeficiencyReportPdf(
            targetShipName,
            deficienciesForShip,
            userProfile,
            allInstancesMap,
            allTemplatesMap,
          );

      final tempDir = await getTemporaryDirectory();
      final safeShipName = targetShipName
          .replaceAll(RegExp(r'[^\w\s]+'), '')
          .replaceAll(' ', '_');
      final filePath =
          '${tempDir.path}/deficiency_report_${safeShipName}_${DateTime.now().toIso8601String().split('T').first}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      debugPrint('PDF отчета по несоответствиям сохранен: $filePath');

      if (context.mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();

        // --- ИЗМЕНЕНИЕ: Создаем ShareParams ---
        final shareParams = ShareParams(
          text: 'Отчет о несоответствиях для судна: $targetShipName',
          files: [XFile(filePath)], // Передаем список файлов
        );
        final result = await SharePlus.instance.share(
          shareParams,
        ); // Вызываем share с ShareParams
        // ------------------------------------

        if (result.status == ShareResultStatus.success) {
          debugPrint('PDF отчета по несоответствиям успешно отправлен.');
        } else {
          debugPrint(
            'Отправка PDF отчета по несоответствиям отменена/не удалась: ${result.status}',
          );
        }
      }
    } catch (e, s) {
      debugPrint('Ошибка при генерации PDF отчета по несоответствиям: $e\n$s');
      if (context.mounted) {
        // Проверка context.mounted
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  // Вспомогательная функция для имен статусов
  String _getDeficiencyStatusName(DeficiencyStatus status) {
    switch (status) {
      case DeficiencyStatus.open:
        return 'Открыто';
      case DeficiencyStatus.inProgress:
        return 'В работе';
      case DeficiencyStatus.closed:
        return 'Закрыто';
    }
    // Строка ниже не должна быть достижима, если switch исчерпывающий или с default
    // return 'Неизвестный статус';
  }

  @override
  Widget build(BuildContext context) {
    // Получаем ссылку на ящик один раз
    final deficienciesBox = Hive.box<Deficiency>(deficienciesBoxName);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Список Несоответствий'),
        // --- ДОБАВЛЯЕМ СЕКЦИЮ ACTIONS С КНОПКОЙ PDF ---
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined), // Иконка PDF
            tooltip: 'PDF отчет по несоответствиям текущего судна', // Подсказка
            onPressed: () {
              // Вызываем метод генерации PDF, который мы добавили
              // 'context' здесь - это BuildContext метода build
              _generateAndShareDeficiencyReport(context);
            },
          ),
          // Сюда можно будет позже добавить другие кнопки, например, для расширенной фильтрации
        ],
      ),
      // Используем ValueListenableBuilder для автоматического обновления
      body: Column(
        // Оборачиваем все в Column, чтобы добавить SegmentedButton сверху
        children: [
          // --- НОВЫЙ ВИДЖЕТ: SegmentedButton для фильтров ---
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SegmentedButton<DeficiencyStatus?>(
              // Список сегментов: "Все" + все значения из DeficiencyStatus
              segments: <ButtonSegment<DeficiencyStatus?>>[
                const ButtonSegment<DeficiencyStatus?>(
                  value: null, // null для "Все"
                  label: Text('Все'),
                  icon: Icon(Icons.list_alt_rounded),
                ),
                // Генерируем сегменты для каждого статуса
                ...DeficiencyStatus.values.map(
                  (status) => ButtonSegment<DeficiencyStatus?>(
                    value: status,
                    label: Text(
                      _getDeficiencyStatusName(status),
                    ), // Используем нашу функцию для имен
                  ),
                ),
              ],
              // Текущий выбранный сегмент (должен быть в Set)
              selected: <DeficiencyStatus?>{_selectedFilterStatus},
              onSelectionChanged: (Set<DeficiencyStatus?> newSelection) {
                setState(() {
                  // SegmentedButton для single choice возвращает Set с одним элементом
                  _selectedFilterStatus = newSelection.first;
                });
              },
              multiSelectionEnabled: false, // Только один выбор
              showSelectedIcon: false, // Не показывать галочку на выбранном
              style: SegmentedButton.styleFrom(
                // Немного стилизуем
                visualDensity: VisualDensity.compact,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
          const Divider(),

          // ----------------------------------------------------
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: deficienciesBox.listenable(), // Слушаем ящик
              builder: (context, Box<Deficiency> box, _) {
                // Получаем все записи из ящика в виде Map<key, Deficiency>
                // Это эффективно, т.к. получаем и ключи, и значения сразу
                final deficienciesMap = box.toMap();
                // Преобразуем в список пар [ключ, значение] для ListView.builder
                var deficienciesList =
                    deficienciesMap.entries
                        .toList(); // var, т.к. будем переприсваивать

                // --- НОВАЯ ЛОГИКА: Фильтрация списка ---
                if (_selectedFilterStatus != null) {
                  deficienciesList =
                      deficienciesList
                          .where(
                            (entry) =>
                                entry.value.status == _selectedFilterStatus,
                          )
                          .toList();
                }
                // ------------------------------------
                // Если список пуст
                if (deficienciesList.isEmpty) {
                  return const Center(
                    child: Text('Нет зарегистрированных несоответствий.'),
                  );
                }

                // Если есть записи - строим список
                return ListView.builder(
                  itemCount: deficienciesList.length,
                  itemBuilder: (context, index) {
                    // Получаем ключ и сам объект Deficiency для текущего элемента
                    final entry = deficienciesList[index];
                    final dynamic key =
                        entry.key; // Ключ может быть int или String
                    final Deficiency deficiency = entry.value;

                    // --- НОВАЯ ЛОГИКА: Определение статуса для стилизации ---
                    final now = DateTime.now();
                    final today = DateTime(
                      now.year,
                      now.month,
                      now.day,
                    ); // Сегодняшняя дата без времени

                    bool isItemOverdue = false;
                    if (deficiency.dueDate != null &&
                        deficiency.status != DeficiencyStatus.closed) {
                      final normalizedDueDate = DateTime(
                        deficiency.dueDate!.year,
                        deficiency.dueDate!.month,
                        deficiency.dueDate!.day,
                      );
                      isItemOverdue = normalizedDueDate.isBefore(today);
                    }

                    final bool isItemClosed =
                        deficiency.status == DeficiencyStatus.closed;

                    Color statusColor =
                        Theme.of(context).textTheme.bodySmall?.color ??
                        Colors.grey; // Цвет по умолчанию
                    IconData statusIconData =
                        Icons.help_outline; // Иконка по умолчанию

                    if (isItemClosed) {
                      statusColor = Colors.green;
                      statusIconData = Icons.check_circle_outline;
                    } else if (isItemOverdue) {
                      statusColor = Colors.red;
                      statusIconData = Icons.error_outline;
                    } else if (deficiency.status == DeficiencyStatus.open) {
                      statusColor = Colors.orangeAccent;
                      statusIconData = Icons.warning_amber_rounded;
                    } else if (deficiency.status ==
                        DeficiencyStatus.inProgress) {
                      statusColor = Colors.blueAccent;
                      statusIconData = Icons.hourglass_empty_rounded;
                    }
                    // -------------------------------------------------------

                    // Формируем ListTile для отображения
                    return ListTile(
                      // leading: Icon(Icons.warning_amber_rounded, color: _getStatusColor(deficiency.status)), // Опционально: иконка статуса
                      // --- НОВОЕ: Добавляем иконку статуса ---
                      leading: Icon(
                        statusIconData,
                        color: statusColor,
                        size: 28,
                      ),
                      // --------------------------------------
                      title: Text(
                        deficiency.description,
                        maxLines: 2, // Ограничиваем кол-во строк описания
                        overflow:
                            TextOverflow
                                .ellipsis, // Добавляем многоточие, если не влезает
                      ),
                      subtitle: RichText(
                        // Используем RichText для разного стиля частей текста
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: 12,
                          ), // Базовый стиль для subtitle
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  'Статус: ${_getDeficiencyStatusName(deficiency.status)}',
                              // --- НОВОЕ: Цвет для текста статуса ---
                              style: TextStyle(
                                color: statusColor,
                                fontWeight:
                                    isItemClosed || isItemOverdue
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                              // -----------------------------------
                            ),
                            if (deficiency.dueDate != null)
                              TextSpan(
                                text:
                                    ' - Срок: ${deficiency.dueDate!.day}.${deficiency.dueDate!.month}.${deficiency.dueDate!.year}',
                                // --- НОВОЕ: Красный цвет для просроченной даты ---
                                style: TextStyle(
                                  color:
                                      isItemOverdue
                                          ? Colors.red
                                          : null, // null - унаследует цвет по умолчанию
                                  fontWeight:
                                      isItemOverdue
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                                // --------------------------------------------
                              ),
                          ],
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red.withAlpha(196),
                        ),
                        tooltip: 'Удалить несоответствие',
                        onPressed:
                            () => _showDeleteConfirmationDialog(
                              context,
                              key,
                              deficiency.description,
                            ),
                      ),

                      // ----------------
                      onTap: () {
                        // Переход на экран деталей для редактирования/просмотра
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => DeficiencyDetailScreen(
                                  deficiencyKey:
                                      key, // Передаем ключ существующего несоответствия
                                  // initial данные не передаем, т.к. открываем существующее
                                ),
                          ),
                        );
                        // setState не нужен, ValueListenableBuilder обновит список сам,
                        // если данные в ящике изменятся после возвращения с экрана деталей
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // --- НОВАЯ КНОПКА FAB ---
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Переход на экран деталей для СОЗДАНИЯ нового несоответствия
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => const DeficiencyDetailScreen(
                    // deficiencyKey: null, // Это значение по умолчанию для конструктора
                    // initialDescription: null, // И это
                    // initialInstanceKey: null, // И это
                    // initialChecklistItemId: null, // И это
                    // Если конструктор DeficiencyDetailScreen имеет isFirstRun, он здесь не нужен
                  ),
            ),
          );
          // ValueListenableBuilder на этом экране сам обновит список,
          // когда новое несоответствие будет добавлено в Hive и мы вернемся.
        },
        tooltip: 'Добавить Несоответствие',
        child: const Icon(Icons.add),
      ),
      // -------------------------
    );
  }

  // // Вспомогательная функция для цвета статуса (пример)
  // Color _getStatusColor(DeficiencyStatus status) {
  //   switch (status) {
  //     case DeficiencyStatus.open: return Colors.orange;
  //     case DeficiencyStatus.inProgress: return Colors.blue;
  //     case DeficiencyStatus.resolved: return Colors.green;
  //     case DeficiencyStatus.closed: return Colors.grey;
  //     default: return Colors.black;
  //   }
  // }
} */
