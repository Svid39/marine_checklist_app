import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marine_checklist_app/generated/l10n.dart';

import '../main.dart';
import '../models/checklist_instance.dart';
import '../models/checklist_template.dart';
import '../models/enums.dart';
import '../models/user_profile.dart';
import 'checklist_execution_screen.dart';

/// Экран, на котором пользователь выбирает шаблон для начала новой проверки.
class TemplateSelectionScreen extends StatefulWidget {
  const TemplateSelectionScreen({super.key});

  @override
  State<TemplateSelectionScreen> createState() =>
      _TemplateSelectionScreenState();
}

class _TemplateSelectionScreenState extends State<TemplateSelectionScreen> {
  /// Флаг состояния загрузки данных из Hive.
  bool _isLoading = true;
  /// Карта всех доступных шаблонов, загруженных из Hive.
  Map<dynamic, ChecklistTemplate> _templateMap = {};
  /// Профиль пользователя для предзаполнения полей в диалоге.
  UserProfile? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Загружает все шаблоны и профиль пользователя из базы данных Hive.
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
          _userProfile = profileBox.get(1);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).errorLoadingTemplates(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Отображает модальный диалог для ввода пользователем контекстных данных
  /// (имя судна, порт, имя капитана) перед созданием новой проверки.
  ///
  /// Предзаполняет поля данными из профиля пользователя для удобства.
  Future<Map<String, String>?> _showContextDataDialog(
    String templateName,
  ) async {
    final formKey = GlobalKey<FormState>();
    final shipNameController = TextEditingController(text: _userProfile?.shipName ?? '');
    final portController = TextEditingController();
    final captainNameController = TextEditingController(text: _userProfile?.captainName ?? '');

    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).checkDetailsFor(templateName)),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: shipNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: S.of(context).vesselName,
                      hintText: S.of(context).enterOrConfirmVesselName,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).vesselNameCannotBeEmpty;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: portController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: S.of(context).portOfCheck,
                      hintText: S.of(context).enterPort,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).portCannotBeEmpty;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: captainNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: S.of(context).captainNameForCheck,
                      hintText: S.of(context).enterOrConfirmCaptainName,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).captainNameCannotBeEmpty;
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
              child: Text(S.of(context).cancel),
              onPressed: () => Navigator.pop(dialogContext, null),
            ),
            ElevatedButton(
              child: Text(S.of(context).startCheck),
              onPressed: () {
                if (formKey.currentState!.validate()) {
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

    // Безопасное освобождение ресурсов контроллеров.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      shipNameController.dispose();
      portController.dispose();
      captainNameController.dispose();
    });

    return result;
  }

  /// Запускает процесс создания новой проверки на основе выбранного шаблона.
  Future<void> _startChecklist(
    dynamic templateKey,
    ChecklistTemplate template,
  ) async {
    // 1. Запрашиваем у пользователя контекстные данные через диалог.
    final Map<String, String>? contextData = await _showContextDataDialog(template.name);
    if (!mounted || contextData == null) return;

    // 2. Если данные получены, создаем и сохраняем новый экземпляр проверки.
    final instancesBox = Hive.box<ChecklistInstance>(instancesBoxName);
    try {
      final newInstance = ChecklistInstance(
        templateId: templateKey,
        shipName: contextData['shipName'],
        port: contextData['port'],
        captainNameOnCheck: contextData['captainNameOnCheck'],
        inspectorName: _userProfile?.name,
        date: DateTime.now(),
        status: ChecklistInstanceStatus.inProgress,
        responses: [],
      );

      final newInstanceKey = await instancesBox.add(newInstance);
      if (!mounted) return;

      // 3. Переходим на экран выполнения созданной проверки.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChecklistExecutionScreen(
            instanceKey: newInstanceKey,
            checklistName: template.name,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).criticalErrorCreatingCheck(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).selectCheckTemplate)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _templateMap.isEmpty
              ? Center(child: Text(S.of(context).templatesNotFound))
              : ListView.builder(
                  itemCount: _templateMap.length,
                  itemBuilder: (context, index) {
                    final key = _templateMap.keys.elementAt(index);
                    final template = _templateMap[key]!;
                    return ListTile(
                      title: Text(template.name),
                      subtitle: Text(S.of(context).version(template.version)),
                      trailing: const Icon(Icons.play_arrow),
                      onTap: () => _startChecklist(key, template),
                    );
                  },
                ),
    );
  }
}