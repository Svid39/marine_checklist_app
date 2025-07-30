// Файл: lib/screens/template_selection_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../main.dart'; // Нужен для имен ящиков (box names)
import '../models/checklist_template.dart';
import '../models/checklist_instance.dart';
import '../models/user_profile.dart';
import '../models/enums.dart';
import 'checklist_execution_screen.dart'; // Импортируем экран выполнения

class TemplateSelectionScreen extends StatefulWidget {
  const TemplateSelectionScreen({super.key});

  @override
  State<TemplateSelectionScreen> createState() =>
      _TemplateSelectionScreenState();
}

class _TemplateSelectionScreenState extends State<TemplateSelectionScreen> {
  bool _isLoading = true;
  Map<dynamic, ChecklistTemplate> _templateMap = {};
  UserProfile? _userProfile; // Для предзаполнения данных

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final templatesBox = Hive.box<ChecklistTemplate>(templatesBoxName);
      final profileBox = Hive.box<UserProfile>(userProfileBoxName);
      if (mounted) {
        setState(() {
          _templateMap = templatesBox.toMap();
          _userProfile = profileBox.get(1); // Загружаем профиль
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Ошибка загрузки шаблонов на TemplateSelectionScreen: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки шаблонов: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- НОВЫЙ МЕТОD: Показ диалога для ввода контекстных данных ---
  Future<Map<String, String>?> _showContextDataDialog(
    BuildContext context,
    String templateName,
    UserProfile? currentUserProfile,
  ) async {
    final formKey = GlobalKey<FormState>(); // Ключ для валидации формы диалога
    final TextEditingController shipNameController = TextEditingController(
      text: currentUserProfile?.shipName ?? '',
    );
    final TextEditingController portController = TextEditingController();
    final TextEditingController captainNameController = TextEditingController(
      text: currentUserProfile?.captainName ?? '',
    );

    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false, // Пользователь должен нажать кнопку
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Детали проверки для "$templateName"'),
          content: SingleChildScrollView(
            // Если полей будет много
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: shipNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Название Судна',
                      hintText: 'Введите или подтвердите название судна',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Название судна не может быть пустым';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: portController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Порт Проверки',
                      hintText: 'Введите порт',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Порт не может быть пустым';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: captainNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Имя Капитана (на эту проверку)',
                      hintText: 'Введите или подтвердите имя капитана',
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Имя капитана не может быть пустым';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  null,
                ); // Возвращаем null при отмене
              },
            ),
            ElevatedButton(
              // Используем ElevatedButton для акцента
              child: const Text('Начать Проверку'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // Проверяем валидность формы
                  Navigator.pop(dialogContext, {
                    'shipName': shipNameController.text.trim(),
                    'port': portController.text.trim(),
                    'captainNameOnCheck': captainNameController.text.trim(),
                  });
                }
              },
            ),
          ],
        );
      },
    );

    // --- ИЗМЕНЕНИЕ ЗДЕСЬ: Откладываем dispose ---
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (mounted) { // Проверка mounted здесь может быть излишней для локальных контроллеров диалога
      shipNameController.dispose();
      portController.dispose();
      captainNameController.dispose();
      // }
    });
    // ------------------------------------------

    return result;
  }
  // ---------------------------------------------------------------

  // --- ИЗМЕНЕННЫЙ МЕТОД: Старт новой проверки ---
  Future<void> _startChecklist(
    dynamic templateKey,
    ChecklistTemplate template,
  ) async {
    if (!mounted) return;
    debugPrint(
      "--> _startChecklist: Выбран шаблон '${template.name}' с ключом $templateKey",
    );

    final Map<String, String>? contextData = await _showContextDataDialog(
      context,
      template.name,
      _userProfile,
    );
    debugPrint(
      "--> _startChecklist: Данные из диалога contextData: $contextData",
    );

    if (contextData != null && mounted) {
      final instancesBox = Hive.box<ChecklistInstance>(instancesBoxName);
      final String? inspectorName = _userProfile?.name;

      debugPrint("--> _startChecklist: Попытка создать ChecklistInstance...");
      try {
        final newInstance = ChecklistInstance(
          templateId: templateKey,
          shipName: contextData['shipName'], // Проверяем эти ключи
          port: contextData['port'], // И этот
          captainNameOnCheck: contextData['captainNameOnCheck'], // И этот
          inspectorName: inspectorName,
          date: DateTime.now(),
          status: ChecklistInstanceStatus.inProgress,
          responses: [],
          completionDate: null, // Это поле необязательное, по умолчанию null
        );
        debugPrint(
          "--> _startChecklist: ChecklistInstance успешно создан локально.",
        );
        debugPrint("--> _startChecklist: shipName: ${newInstance.shipName}");
        debugPrint("--> _startChecklist: port: ${newInstance.port}");
        debugPrint(
          "--> _startChecklist: captainNameOnCheck: ${newInstance.captainNameOnCheck}",
        );
        debugPrint(
          "--> _startChecklist: inspectorName: ${newInstance.inspectorName}",
        );

        // Добавим логирование исходных значений для полей, которые будем менять:
        debugPrint("--> _startChecklist: ИСХОДНАЯ date: ${newInstance.date}");
        debugPrint(
          "--> _startChecklist: ИСХОДНЫЙ completionDate: ${newInstance.completionDate}",
        );
        debugPrint(
          "--> _startChecklist: ИСХОДНЫЕ responses: ${newInstance.responses.length} элементов",
        );

        /* // --- ВСТАВЬТЕ БЛОК ВРЕМЕННЫХ ИЗМЕНЕНИЙ ПРЯМО СЮДА ---
        // --- ВРЕМЕННЫЕ ИЗМЕНЕНИЯ ОБЪЕКТА newInstance ДЛЯ ТЕСТА СОХРАНЕНИЯ ---
        /* newInstance.date = DateTime.fromMillisecondsSinceEpoch(
          0,
        );  */// Устанавливаем очень простую базовую дату
        newInstance.completionDate =
            null; // Убеждаемся, что необязательная дата = null
        newInstance.responses =
            []; // Гарантируем, что responses - это пустой список
        // --------------------------------------------------------------------
        // --- НОВЫЕ ДОБАВЛЕНИЯ: Обнуляем строковые поля ---
        newInstance.shipName = null;
        newInstance.port = null;
        newInstance.captainNameOnCheck = null;
        newInstance.inspectorName = null;
        // -------------------------------------------------
        debugPrint(
          "--> _startChecklist: МОДИФИЦИРОВАННАЯ date для сохранения: ${newInstance.date}",
        );
        debugPrint(
          "--> _startChecklist: МОДИФИЦИРОВАННЫЙ completionDate для сохранения: ${newInstance.completionDate}",
        );
        debugPrint(
          "--> _startChecklist: МОДИФИЦИРОВАННЫЕ responses для сохранения: ${newInstance.responses.length} элементов",
        );
        debugPrint(
          "--> _startChecklist: МОДИФИЦИРОВАННЫЙ shipName: ${newInstance.shipName}",
        ); // Добавьте логи
        debugPrint(
          "--> _startChecklist: МОДИФИЦИРОВАННЫЙ port: ${newInstance.port}",
        );
        debugPrint(
          "--> _startChecklist: МОДИФИЦИРОВАННЫЙ captainNameOnCheck: ${newInstance.captainNameOnCheck}",
        );
        debugPrint(
          "--> _startChecklist: МОДИФИЦИРОВАННЫЙ inspectorName: ${newInstance.inspectorName}",
        );
        // --- КОНЕЦ БЛОКА ВРЕМЕННЫХ ИЗМЕНЕНИЙ --- */
        // Теперь изменим значения полей, которые будут меняться в процессе
        debugPrint(
          "--> _startChecklist: Попытка добавить ChecklistInstance в Hive...",
        );
        dynamic newInstanceKey; // Объявляем ключ здесь
        try {
          // --- ВНУТРЕННИЙ TRY-CATCH ДЛЯ HIVE.ADD ---
          debugPrint(
            "--> _startChecklist: ВЫЗОВ instancesBox.add(newInstance)...",
          );
          newInstanceKey = await instancesBox.add(newInstance);
          debugPrint(
            "--> _startChecklist: ChecklistInstance успешно добавлен в Hive с ключом: $newInstanceKey",
          );
        } catch (hiveError, hiveStackTrace) {
          debugPrint("!!!!!!!! ОШИБКА ПРИ ВЫЗОВЕ instancesBox.add() !!!!!!!!");
          debugPrint("ТИП ОШИБКИ HIVE: ${hiveError.runtimeType}");
          debugPrint("СООБЩЕНИЕ HIVE: $hiveError");
          debugPrint("СТЕК HIVE:\n$hiveStackTrace");
          // Перебрасываем ошибку во внешний catch, чтобы показать SnackBar
          throw Exception("Ошибка Hive при добавлении экземпляра: $hiveError");
        }
        // ---------------------------------------------

        if (mounted) {
          debugPrint(
            "--> _startChecklist: Переход на ChecklistExecutionScreen...",
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => ChecklistExecutionScreen(
                    instanceKey: newInstanceKey,
                    checklistName: template.name,
                  ),
            ),
          );
        }
      } catch (e, stackTrace) {
        // Ловим ошибку и ее стек вызовов
        debugPrint(
          "!!!!!!!! ОШИБКА в _startChecklist при создании/сохранении ChecklistInstance !!!!!!!!",
        );
        debugPrint("ТИП ОШИБКИ: ${e.runtimeType}");
        debugPrint("СООБЩЕНИЕ: $e");
        debugPrint("СТЕК ВЫЗОВОВ:\n$stackTrace");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Критическая ошибка при создании проверки: $e'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
              showCloseIcon: true,
            ),
          );
        }
      }
    } else {
      debugPrint(
        "--> _startChecklist: Создание проверки отменено пользователем в диалоге.",
      );
    }
  }
  // ---------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выбор шаблона проверки')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _templateMap.isEmpty
              ? const Center(
                child: Text('Шаблоны не найдены. Заполните базу данных.'),
              )
              : ListView.builder(
                itemCount: _templateMap.length,
                itemBuilder: (context, index) {
                  final key = _templateMap.keys.elementAt(index);
                  final template = _templateMap[key]!;
                  return ListTile(
                    title: Text(template.name),
                    subtitle: Text('Версия: ${template.version}'),
                    trailing: const Icon(Icons.play_arrow),
                    onTap:
                        () => _startChecklist(
                          key,
                          template,
                        ), // Вызываем обновленный метод
                  );
                },
              ),
    );
  }
}
