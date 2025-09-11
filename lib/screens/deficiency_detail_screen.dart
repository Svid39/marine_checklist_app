// Файл: lib/screens/deficiency_detail_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:marine_checklist_app/generated/l10n.dart'; // <-- ИМПОРТ

import '../models/user_profile.dart';
import '../models/checklist_instance.dart';
import '../main.dart';
import '../models/deficiency.dart';
import '../models/enums.dart';

class DeficiencyDetailScreen extends StatefulWidget {
  final dynamic deficiencyKey;
  final String? initialDescription;
  final dynamic initialInstanceKey;
  final int? initialChecklistItemId;

  const DeficiencyDetailScreen({
    super.key,
    this.deficiencyKey,
    this.initialDescription,
    this.initialInstanceKey,
    this.initialChecklistItemId,
  });

  @override
  State<DeficiencyDetailScreen> createState() => _DeficiencyDetailScreenState();
}

class _DeficiencyDetailScreenState extends State<DeficiencyDetailScreen> {
  late Box<Deficiency> _deficienciesBox;
  Deficiency? _deficiency;
  bool _isLoading = true;
  bool _isNew = true;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();
  final TextEditingController _actionsController = TextEditingController();

  DeficiencyStatus _selectedStatus = DeficiencyStatus.open;
  DateTime? _dueDate;
  DateTime? _resolutionDate;
  String? _photoPath;
  UserProfile? _loadedUserProfile;

  @override
  void initState() {
    super.initState();
    _deficienciesBox = Hive.box<Deficiency>(deficienciesBoxName);
    _loadInitialData();
  }
  
  // NOTE: There was a floating _loadInitialData; call in your original initState.
  // I have combined the logic into one block.
  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    final profileBox = Hive.box<UserProfile>(userProfileBoxName);
    _loadedUserProfile = profileBox.get(1);

    if (widget.deficiencyKey == null) {
      _isNew = true;
      _deficiency = Deficiency(
        description: widget.initialDescription ?? '',
        instanceId: widget.initialInstanceKey,
        checklistItemId: widget.initialChecklistItemId,
        status: DeficiencyStatus.open,
      );
      _updateControllersFromDeficiency();
      if(mounted) setState(() => _isLoading = false);
    } else {
      _isNew = false;
      try {
        final loadedDeficiency = _deficienciesBox.get(widget.deficiencyKey!);
        if (loadedDeficiency != null) {
          if(mounted) {
            setState(() {
              _deficiency = loadedDeficiency;
              _updateControllersFromDeficiency();
              _isLoading = false;
            });
          }
        } else {
          throw Exception(S.of(context).deficiencyNotFound(widget.deficiencyKey.toString()));
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).errorLoadingDeficiency), backgroundColor: Colors.red),
          );
          Navigator.pop(context);
        }
      }
    }
  }

  void _updateControllersFromDeficiency() {
    if (_deficiency == null) return;
    _descriptionController.text = _deficiency!.description;
    _assignedToController.text = _deficiency!.assignedTo ?? '';
    _actionsController.text = _deficiency!.correctiveActions ?? '';
    _selectedStatus = _deficiency!.status;
    _dueDate = _deficiency!.dueDate;
    _resolutionDate = _deficiency!.resolutionDate;
    _photoPath = _deficiency!.photoPath;
  }
  
  @override
  void dispose() {
    _descriptionController.dispose();
    _assignedToController.dispose();
    _actionsController.dispose();
    super.dispose();
  }
  
  String _formatDate(DateTime? date, {bool feminine = false}) {
    if (date == null) {
        return feminine ? S.of(context).notSetFeminine : S.of(context).notSet;
    }
    return DateFormat.yMd(Localizations.localeOf(context).languageCode).format(date);
  }

  Future<void> _selectDate({required bool isDueDate}) async {
    final DateTime initial = (isDueDate ? _dueDate : _resolutionDate) ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && mounted) {
      setState(() {
        if (isDueDate) {
          _dueDate = picked;
        } else {
          _resolutionDate = picked;
        }
      });
    }
  }

  Future<void> _saveDeficiency() async {
    if (!mounted) return;
    if (!(_formKey.currentState?.validate() ?? false)) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).pleaseFixErrorsInForm), backgroundColor: Colors.orange),
        );
        return;
    }

    _deficiency!.description = _descriptionController.text.trim();
    _deficiency!.assignedTo = _assignedToController.text.trim().isNotEmpty ? _assignedToController.text.trim() : null;
    _deficiency!.correctiveActions = _actionsController.text.trim().isNotEmpty ? _actionsController.text.trim() : null;
    _deficiency!.status = _selectedStatus;
    _deficiency!.dueDate = _dueDate;
    _deficiency!.resolutionDate = _resolutionDate;
    _deficiency!.photoPath = _photoPath;

    try {
      if (_isNew) {
        await _deficienciesBox.add(_deficiency!);
      } else {
        await _deficienciesBox.put(widget.deficiencyKey!, _deficiency!);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).deficiencySaved), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).errorSavingDeficiency), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<String?> _showViewOrManagePhotoDialog(String imagePath) async {
    if (!mounted) return null;
    return await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          contentPadding: const EdgeInsets.all(8),
          content: Column(mainAxisSize: MainAxisSize.min, children: [Image.file(File(imagePath))]),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(child: Text(S.of(context).close), onPressed: () => Navigator.pop(dialogContext, null)),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => Navigator.pop(dialogContext, 'delete'),
              child: Text(S.of(context).delete),
            ),
            ElevatedButton(
              child: Text(S.of(context).replacePhoto),
              onPressed: () => Navigator.pop(dialogContext, 'replace'),
            ),
          ],
        );
      },
    );
  }
  
  String _sanitizeForFilename(String? input, {String defaultVal = 'NA', int maxLength = 15}) {
      if (input == null || input.isEmpty) return defaultVal;
      String sanitized = input.toLowerCase().replaceAll(RegExp(r'[^\w.-]'), '_').replaceAll(RegExp(r'\s+'), '_');
      if (sanitized.length > maxLength) {
          sanitized = sanitized.substring(0, maxLength);
      }
      return sanitized.isEmpty ? defaultVal : sanitized;
  }
  
  Future<String?> _compressAndSaveDeficiencyImage(XFile originalFile, String? contextShipName, String? contextPort, DateTime? contextDate, String contextIdentifier) async {
      try {
          final Directory appDir = await getApplicationDocumentsDirectory();
          final String imageDir = '${appDir.path}/deficiency_photos';
          await Directory(imageDir).create(recursive: true);
          final String fileExtension = originalFile.path.split('.').last.toLowerCase();
          final String shipPart = _sanitizeForFilename(contextShipName, defaultVal: 'ShipU');
          final String portPart = _sanitizeForFilename(contextPort, defaultVal: 'PortU');
          final String idPart = _sanitizeForFilename(contextIdentifier, defaultVal: 'ID_U', maxLength: 25);
          final String datePart = contextDate != null ? "${contextDate.year}${contextDate.month.toString().padLeft(2, '0')}${contextDate.day.toString().padLeft(2, '0')}" : "DateU";
          final String uniqueFileName = 'DEF_${shipPart}_${portPart}_${idPart}_${datePart}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
          final String targetPath = '$imageDir/$uniqueFileName';
          final XFile? compressedXFile = await FlutterImageCompress.compressAndGetFile(
              originalFile.path, targetPath, quality: 80, minWidth: 1024, minHeight: 1024,
          );
          return compressedXFile?.path;
      } catch (e) {
          debugPrint("Ошибка сжатия/сохранения файла несоответствия: $e");
          return null;
      }
  }

  Future<void> _handleDeficiencyPhoto() async {
    if (!mounted) return;
    String? action;
    if (_photoPath != null && _photoPath!.isNotEmpty) {
      action = await _showViewOrManagePhotoDialog(_photoPath!);
      if (!mounted || action == null) return;
      if (action == 'delete') {
        String? pathToDelete = _photoPath;
        setState(() => _photoPath = null);
        if (pathToDelete != null) {
          try {
            final oldFile = File(pathToDelete);
            if (await oldFile.exists()) await oldFile.delete();
          } catch (e) {
            if (!mounted) return;
            debugPrint(S.of(context).errorDeletingFile);
          }
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).photoDeleted), backgroundColor: Colors.orange),
          );
        }
        return;
      }
    }

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(leading: const Icon(Icons.photo_camera), title: Text(S.of(context).camera), onTap: () => Navigator.pop(context, ImageSource.camera)),
            ListTile(leading: const Icon(Icons.photo_library), title: Text(S.of(context).gallery), onTap: () => Navigator.pop(context, ImageSource.gallery)),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    Permission neededPermission = source == ImageSource.camera ? Permission.camera : Permission.photos;
    String permissionName = source == ImageSource.camera ? S.of(context).camera : S.of(context).gallery;
    PermissionStatus permissionStatus = await neededPermission.status;
    if (permissionStatus.isDenied || permissionStatus.isRestricted) {
      permissionStatus = await neededPermission.request();
    }

    if (!mounted) return;
    if (!permissionStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).permissionRequired(permissionName))),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null || !mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).processingPhoto)));

    try {
      String? contextShipName, contextPort;
      DateTime? contextDate;
      String contextIdentifier;
      final instanceIdForContext = _deficiency?.instanceId ?? widget.initialInstanceKey;
      if (instanceIdForContext != null) {
        final instance = Hive.box<ChecklistInstance>(instancesBoxName).get(instanceIdForContext);
        if (instance != null) {
          contextShipName = instance.shipName;
          contextPort = instance.port;
          contextDate = instance.date;
        }
        contextIdentifier = (_deficiency?.checklistItemId ?? widget.initialChecklistItemId)?.toString() ?? 'ItemNA';
      } else {
        contextShipName = _loadedUserProfile?.shipName;
        contextPort = "MANUAL";
        contextDate = DateTime.now();
        contextIdentifier = _isNew ? "NEW_MANUAL" : (widget.deficiencyKey?.toString() ?? "MANUAL_EDT");
      }
      
      final String? newCompressedPath = await _compressAndSaveDeficiencyImage(pickedFile, contextShipName, contextPort, contextDate, contextIdentifier);

      if (newCompressedPath != null && mounted) {
        if (_photoPath != null && _photoPath!.isNotEmpty && _photoPath != newCompressedPath) {
          try {
            final oldFile = File(_photoPath!);
            if (await oldFile.exists()) await oldFile.delete();
          } catch (e) {
            if (!mounted) return;
            debugPrint(S.of(context).errorDeletingFile);
          }
        }
        setState(() => _photoPath = newCompressedPath);
        if (!mounted) return;
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).photoAddedOrUpdated), backgroundColor: Colors.green));
      } else if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).failedToProcessPhoto), backgroundColor: Colors.orange));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).photoError(e.toString())), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? S.of(context).newDeficiency : S.of(context).deficiencyDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: S.of(context).save,
            onPressed: _isLoading ? null : _saveDeficiency,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _deficiency == null
              ? Center(child: Text(S.of(context).errorLoadingDeficiency))
              : _buildForm(),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).deficiencyDescription, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: S.of(context).describeTheProblem,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if(value == null || value.trim().isEmpty) return S.of(context).noDescription;
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(S.of(context).status, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            DropdownButtonFormField<DeficiencyStatus>(
              value: _selectedStatus,
              items: DeficiencyStatus.values.map((status) {
                return DropdownMenuItem<DeficiencyStatus>(value: status, child: Text(status.name));
              }).toList(),
              onChanged: (DeficiencyStatus? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedStatus = newValue;
                    if (newValue == DeficiencyStatus.closed && _resolutionDate == null) {
                      _resolutionDate = DateTime.now();
                    }
                  });
                }
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Text(S.of(context).assignedTo, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextFormField(
              controller: _assignedToController,
              decoration: InputDecoration(hintText: S.of(context).nameOrPosition, border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Text(S.of(context).dueDate, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: Text(_formatDate(_dueDate))),
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  tooltip: S.of(context).selectDueDate,
                  onPressed: () => _selectDate(isDueDate: true),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            Text(S.of(context).correctiveActions, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextFormField(
              controller: _actionsController,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(hintText: S.of(context).describeWhatWasDone, border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Text(S.of(context).resolutionDate, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: Text(_formatDate(_resolutionDate, feminine: true))),
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  tooltip: S.of(context).selectResolutionDate,
                  onPressed: () => _selectDate(isDueDate: false),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(S.of(context).deficiencyPhoto, style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    (_photoPath != null && _photoPath!.isNotEmpty) ? Icons.photo : Icons.add_a_photo_outlined,
                    color: (_photoPath != null && _photoPath!.isNotEmpty) ? Theme.of(context).primaryColor : Colors.grey[600],
                  ),
                  tooltip: (_photoPath != null && _photoPath!.isNotEmpty) ? S.of(context).viewOrReplacePhoto : S.of(context).addDeficiencyPhoto,
                  onPressed: _handleDeficiencyPhoto,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/* // Файл: lib/screens/deficiency_detail_screen.dart

import 'dart:io'; // Для File
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:permission_handler/permission_handler.dart'; // Для разрешений
import '../models/user_profile.dart'; // Этот импорт ДОЛЖЕН БЫТЬ ЗДЕСЬ
import '../models/checklist_instance.dart'; // <-- ДОБАВЬТЕ ИЛИ ПРОВЕРЬТЕ ЭТОТ ИМПОРТ

import '../main.dart';
import '../models/deficiency.dart';
import '../models/enums.dart';
// import 'dashboard_screen.dart'; // Если нужен для навигации из _saveSettings

class DeficiencyDetailScreen extends StatefulWidget {
  // Ключ существующего Deficiency в Hive (null, если создаем новое)
  final dynamic deficiencyKey;

  // Начальные данные (передаются при создании из чек-листа)
  final String? initialDescription;
  final dynamic initialInstanceKey; // Ключ ChecklistInstance
  final int? initialChecklistItemId; // Порядковый номер пункта

  const DeficiencyDetailScreen({
    super.key,
    this.deficiencyKey, // Необязательный ключ
    this.initialDescription,
    this.initialInstanceKey,
    this.initialChecklistItemId,
  });

  @override
  State<DeficiencyDetailScreen> createState() => _DeficiencyDetailScreenState();
}

class _DeficiencyDetailScreenState extends State<DeficiencyDetailScreen> {
  // --- Переменные Состояния ---
  late Box<Deficiency> _deficienciesBox; // Ящик Hive для несоответствий
  Deficiency? _deficiency; // Текущий редактируемый/создаваемый объект
  bool _isLoading = false; // Показываем загрузку только при редактировании
  bool _isNew = true; // Флаг: создаем новое (true) или редактируем (false)

  final _formKey = GlobalKey<FormState>();

  // Контроллеры для текстовых полей
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _assignedToController = TextEditingController();
  final TextEditingController _actionsController = TextEditingController();

  // Переменные для других полей
  DeficiencyStatus _selectedStatus =
      DeficiencyStatus.open; // Статус по умолчанию
  DateTime? _dueDate;
  DateTime? _resolutionDate;
  String? _photoPath; // Путь к фото для этого несоответствия

  UserProfile? _loadedUserProfile; // Для получения имени судна по умолчанию

  @override
  void initState() {
    super.initState();
    _deficienciesBox = Hive.box<Deficiency>(deficienciesBoxName);
    _loadInitialData;

    // Загружаем профиль пользователя
    final profileBox = Hive.box<UserProfile>(userProfileBoxName);
    _loadedUserProfile = profileBox.get(1);

    // Определяем, создаем мы новое или редактируем существующее
    if (widget.deficiencyKey == null) {
      // --- РЕЖИМ СОЗДАНИЯ ---
      _isNew = true;
      _isLoading = false; // Загружать нечего
      // Создаем новый пустой объект Deficiency с начальными данными (если есть)
      _deficiency = Deficiency(
        description: widget.initialDescription ?? '',
        instanceId: widget.initialInstanceKey, // Связь с экземпляром чек-листа
        checklistItemId:
            widget.initialChecklistItemId, // Связь с пунктом чек-листа
        status: DeficiencyStatus.open, // Начальный статус
      );
      // Инициализируем контроллеры
      _descriptionController.text = _deficiency!.description;
      // Остальные поля (assignedTo, actions и т.д.) пока пустые
      _selectedStatus = _deficiency!.status; // Устанавливаем начальный статус
      _dueDate = _deficiency!.dueDate;
      _resolutionDate = _deficiency!.resolutionDate;
      _photoPath = _deficiency!.photoPath;
      _updateControllersFromDeficiency();
    } else {
      // РЕЖИМ РЕДАКТИРОВАНИЯ
      _isNew = false;
      try {
        final loadedDeficiency = _deficienciesBox.get(widget.deficiencyKey!);
        if (loadedDeficiency != null && mounted) {
          setState(() {
            _deficiency = loadedDeficiency;
            _updateControllersFromDeficiency();
            _isLoading = false;
          });
        } else if (mounted) {
          throw Exception(
            'Несоответствие с ключом ${widget.deficiencyKey} не найдено!',
          );
        }
      } catch (e) {
        debugPrint("Ошибка загрузки Deficiency: $e");
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка загрузки: $e'),
              backgroundColor: Colors.red,
            ),
          );
          Navigator.pop(context);
        }
      }
    }
  }

  // Создадим метод для обновления контроллеров, чтобы не дублировать код
  void _updateControllersFromDeficiency() {
    if (!mounted || _deficiency == null) return;
    _descriptionController.text = _deficiency!.description;
    _assignedToController.text = _deficiency!.assignedTo ?? '';
    _actionsController.text = _deficiency!.correctiveActions ?? '';
    _selectedStatus = _deficiency!.status;
    _dueDate = _deficiency!.dueDate;
    _resolutionDate = _deficiency!.resolutionDate;
    _photoPath = _deficiency!.photoPath;
    // setState() не нужен здесь, он будет вызван в _loadInitialData или после действий пользователя
  }

  // -------------------------------Метод для загрузки существующего Deficiency из Hive--------------------
  Future<void> _loadInitialData(dynamic key) async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    }); // Начинаем загрузку

    try {
      final loadedDeficiency = _deficienciesBox.get(key);
      if (loadedDeficiency != null && mounted) {
        setState(() {
          _deficiency = loadedDeficiency;
          // Заполняем контроллеры и переменные состояния из загруженного объекта
          _updateControllersFromDeficiency();
          _isLoading = false; // Загрузка завершена
        });
      } else if (mounted) {
        throw Exception('Несоответствие с ключом $key не найдено!');
      }
    } catch (e) {
      debugPrint("Ошибка загрузки Deficiency: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        }); // Завершаем загрузку (с ошибкой)
        // Можно показать SnackBar с ошибкой
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки данных: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(
          context,
        ); // Возможно, закрыть экран, если данные не загрузить
      }
    }
  }

  // -------------------------------------НОВЫЙ МЕТОД: Выбор Даты Срока -----------------------------------
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ??
          DateTime.now(), // Начальная дата - сохраненная или сегодня
      firstDate: DateTime(2020), // Ограничение минимальной даты
      lastDate: DateTime(2101), // Ограничение максимальной даты
    );
    if (picked != null && picked != _dueDate && mounted) {
      setState(() {
        _dueDate = picked; // Обновляем состояние выбранной датой
      });
    }
  }
  // ------------------------------------------------------------------------------------------------------

  // --- НОВЫЙ МЕТОД: Выбор Даты Устранения ---
  Future<void> _selectResolutionDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _resolutionDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _resolutionDate && mounted) {
      setState(() {
        _resolutionDate = picked; // Обновляем состояние
      });
    }
  }

  // Освобождаем контроллеры при уничтожении виджета
  @override
  void dispose() {
    _descriptionController.dispose();
    _assignedToController.dispose();
    _actionsController.dispose();
    super.dispose();
  }

  // --- Метод для сохранения данных (пока пустой) ---
  Future<void> _saveDeficiency() async {
    if (!mounted) return;

    // --- MAKE SURE THIS IF CONDITION IS PRESENT AND USES _formKey ---
    // У ВАС ЗДЕСЬ ВСЕ ПРАВИЛЬНО, _formKey ИСПОЛЬЗУЕТСЯ:
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // -------------------------------------------------------------
      // _formKey.currentState!.save(); // Optional: if you use onSaved in TextFormFields

      // Обновляем объект _deficiency данными из контроллеров
      _deficiency!.description = _descriptionController.text.trim();
      _deficiency!.assignedTo = _assignedToController.text.trim().isNotEmpty
          ? _assignedToController.text.trim()
          : null;
      _deficiency!.correctiveActions = _actionsController.text.trim().isNotEmpty
          ? _actionsController.text.trim()
          : null;
      _deficiency!.status = _selectedStatus;
      _deficiency!.dueDate = _dueDate;
      _deficiency!.resolutionDate = _resolutionDate;
      _deficiency!.photoPath = _photoPath;

      try {
        if (_isNew) {
          await _deficienciesBox.add(_deficiency!);
          debugPrint("Новое Deficiency сохранено");
        } else {
          await _deficienciesBox.put(widget.deficiencyKey!, _deficiency!);
          debugPrint("Deficiency с ключом ${widget.deficiencyKey} обновлено.");
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Несоответствие сохранено'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        debugPrint("Ошибка сохранения Deficiency: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка сохранения: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      // Если форма не прошла валидацию
      debugPrint("Форма не прошла валидацию");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Пожалуйста, исправьте ошибки в форме.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  // -------------------------------------------------

  // --- НОВЫЙ МЕТОД: Показ существующего фото и опции управления ---
  Future<String?> _showViewOrManagePhotoDialog(String imagePath) async {
    if (!mounted) return null;

    // Действие, которое выберет пользователь (replace, delete, null/close)
    return await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          // Уменьшаем отступы по умолчанию у AlertDialog для большего изображения
          insetPadding: const EdgeInsets.all(10),
          contentPadding: const EdgeInsets.all(8), // Отступы вокруг контента
          content: Column(
            // Используем Column, чтобы добавить заголовок, если нужно
            mainAxisSize: MainAxisSize.min, // Минимальный размер по вертикали
            children: [
              // Отображение самого фото
              Image.file(File(imagePath)), // Загружаем фото из локального файла
              const SizedBox(height: 10), // Небольшой отступ
            ],
          ),
          actionsAlignment: MainAxisAlignment.center, // Центрируем кнопки
          actions: <Widget>[
            TextButton(
              child: const Text('Закрыть'),
              onPressed: () => Navigator.pop(dialogContext, null),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => Navigator.pop(dialogContext, 'delete'),
              child: const Text('Удалить'),
            ),
            ElevatedButton(
              // Главное действие - Заменить
              child: const Text('Заменить фото'),
              onPressed: () => Navigator.pop(dialogContext, 'replace'),
            ),
          ],
        );
      },
    );
  }
  // -------------------------------------------------------------

  // --- НОВЫЙ МЕТОД: Обработка выбора/съемки фото для несоответствия ---
  Future<void> _handleDeficiencyPhoto() async {
    if (!mounted) return;

    final String? currentPhotoPathForThisOperation = _photoPath;
    String? action;

    if (currentPhotoPathForThisOperation != null &&
        currentPhotoPathForThisOperation.isNotEmpty) {
      action = await _showViewOrManagePhotoDialog(
        currentPhotoPathForThisOperation,
      );
      if (!mounted || action == null) return;

      if (action == 'delete') {
        String? pathToDelete = _photoPath;
        setState(() {
          _photoPath = null;
        }); // Обновляем UI немедленно

        if (pathToDelete != null) {
          // Удаляем файл
          try {
            final oldFile = File(pathToDelete);
            if (await oldFile.exists()) {
              await oldFile.delete();
            }
          } catch (e) {
            debugPrint("Ошибка удаления файла: $e");
          }
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Фото удалено'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        // Сохранять _deficiency не нужно здесь, _photoPath сохранится при общем сохранении
        return;
      }
      // Если action == 'replace', продолжаем ниже
    }

    // V-- IMPORTANT PART FOR 'source' --V
    // Show modal bottom sheet to choose source
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Камера'), // Camera
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Галерея'), // Gallery
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null || !mounted) return; // User cancelled source selection

    // Permission handling using the 'source' variable
    Permission neededPermission;
    String permissionName;
    if (source == ImageSource.camera) {
      // 'source' is used here
      neededPermission = Permission.camera;
      permissionName = "Камера"; // Camera
    } else {
      neededPermission = Permission.photos;
      permissionName = "Фото"; // Photos
    }

    PermissionStatus permissionStatus = await neededPermission.status;
    if (permissionStatus.isDenied || permissionStatus.isRestricted) {
      permissionStatus = await neededPermission.request();
    }

    if (!mounted) return;
    if (!permissionStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Требуется разрешение для доступа к $permissionName',
          ), // Permission required
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }
    // ^-- END OF IMPORTANT PART FOR 'source' --^

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null || !mounted) return;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Обработка фото...')),
      ); // Processing photo...
    } else {
      return;
    }

    // --- СБОР КОНТЕКСТНЫХ ДАННЫХ для имени файла ---
    String? contextShipName;
    String? contextPort;
    DateTime? contextDate;
    String contextIdentifier;

    final instanceIdForContext =
        _deficiency?.instanceId ?? widget.initialInstanceKey;

    if (instanceIdForContext != null) {
      final instance = Hive.box<ChecklistInstance>(
        instancesBoxName,
      ).get(instanceIdForContext);
      if (instance != null) {
        contextShipName = instance.shipName;
        contextPort = instance.port;
        contextDate = instance.date;
      }
      contextIdentifier =
          (_deficiency?.checklistItemId ?? widget.initialChecklistItemId)
                  ?.toString() ??
              'ItemNA';
    } else {
      contextShipName = _loadedUserProfile?.shipName;
      contextPort =
          "MANUAL"; // Для несоответствий без привязки к конкретному порту проверки
      contextDate =
          DateTime.now(); // Используем дату создания несоответствия, если есть
      contextIdentifier = _isNew
          ? "NEW_MANUAL"
          : (widget.deficiencyKey?.toString() ?? "MANUAL_EDT");
    }
    // ---------------------------------------------

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Обработка фото...')));

    try {
      final String? newCompressedPath = await _compressAndSaveDeficiencyImage(
        pickedFile, // Убедитесь, что pickedFile не null на этом этапе (мы проверяли выше)
        contextShipName,
        contextPort,
        contextDate,
        contextIdentifier,
      );

      if (newCompressedPath != null && mounted) {
        // Если было старое фото, и оно не совпадает с новым, удаляем старый файл
        if (_photoPath != null &&
            _photoPath!.isNotEmpty &&
            _photoPath != newCompressedPath) {
          try {
            final oldFile = File(_photoPath!);
            if (await oldFile.exists()) {
              await oldFile.delete();
              debugPrint("Старый файл фото несоответствия удален: $_photoPath");
            }
          } catch (e) {
            debugPrint("Ошибка удаления старого файла фото несоответствия: $e");
          }
        }
        // Обновляем состояние с новым путем
        setState(() {
          _photoPath = newCompressedPath;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Фото добавлено/обновлено'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Не удалось обработать фото'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      debugPrint("Ошибка при обработке фото для несоответствия: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка фото: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  // ----------------------------------------------------------------

  // ------Вспомогательная функция для очистки строки для имени файла------
  String _sanitizeForFilename(
    String? input, {
    String defaultVal = 'NA',
    int maxLength = 15,
  }) {
    if (input == null || input.isEmpty) return defaultVal;
    String sanitized = input
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w.-]'), '_')
        .replaceAll(RegExp(r'\s+'), '_');
    if (sanitized.length > maxLength) {
      sanitized = sanitized.substring(0, maxLength);
    }
    return sanitized.isEmpty ? defaultVal : sanitized;
  }
  // -------------------------------------------------------------------------

  // --- НОВЫЙ ВСПОМОГАТЕЛЬНЫЙ МЕТОД: Сжатие и сохранение фото несоответствия ---
  Future<String?> _compressAndSaveDeficiencyImage(
    XFile originalFile, // --- НОВЫЕ ПАРАМЕТРЫ КОНТЕКСТА ---
    String? contextShipName,
    String? contextPort,
    DateTime? contextDate,
    String contextIdentifier,
  ) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      // Создаем уникальное имя папки для фото несоответствий, если нужно
      final String imageDir = '${appDir.path}/deficiency_photos';
      await Directory(imageDir).create(recursive: true);

      final String fileExtension =
          originalFile.path.split('.').last.toLowerCase();

      final String shipPart = _sanitizeForFilename(
        contextShipName,
        defaultVal: 'ShipU',
      );
      final String portPart = _sanitizeForFilename(
        contextPort,
        defaultVal: 'PortU',
      );
      final String idPart = _sanitizeForFilename(
        contextIdentifier,
        defaultVal: 'ID_U',
        maxLength: 25,
      );
      final String datePart = contextDate != null
          ? "${contextDate.year}${contextDate.month.toString().padLeft(2, '0')}${contextDate.day.toString().padLeft(2, '0')}"
          : "DateU";

      final String uniqueFileName =
          'DEF_${shipPart}_${portPart}_${idPart}_${datePart}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

      final String targetPath = '$imageDir/$uniqueFileName';
      debugPrint("Новое имя и путь (несоответствие): $targetPath");

      final XFile? compressedXFile =
          await FlutterImageCompress.compressAndGetFile(
        originalFile.path,
        targetPath,
        quality: 80,
        minWidth: 1024,
        minHeight: 1024,
      );
      return compressedXFile?.path;
    } catch (e) {
      debugPrint("Ошибка сжатия/сохранения файла несоответствия: $e");
      return null;
    }
  }
  // -------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Заголовок зависит от режима
        title: Text(_isNew ? 'Новое Несоответствие' : 'Детали Несоответствия'),
        actions: [
          // Добавляем кнопку Сохранить (пока может быть неактивна)
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Сохранить',
            onPressed:
                _isLoading ? null : _saveDeficiency, // Вызываем сохранение
          ),
        ],
      ),
      // Тело экрана: пока просто индикатор загрузки или текст
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _deficiency == null // Проверка на случай ошибки загрузки
              ? const Center(
                  child: Text('Ошибка: Данные несоответствия не загружены.'),
                )
              : _buildForm(), // Выносим форму в отдельный метод
    );
  }

  // --- РЕАЛИЗОВАННЫЙ МЕТОД для построения формы ---
  Widget _buildForm() {
    // Используем SingleChildScrollView, чтобы форма скроллилась
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      key: _formKey, // Отступы для формы
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Выравнивание по левому краю
        children: [
          // --- Поле Описание ---
          const Text('Описание Несоответствия:'),
          const SizedBox(height: 4),
          TextFormField(
            controller: _descriptionController,
            maxLines: 5, // Многострочное поле
            textInputAction:
                TextInputAction.newline, // Для многострочного ввода
            decoration: const InputDecoration(
              hintText: 'Опишите проблему...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // --- Поле Статус ---
          const Text('Статус:'),
          const SizedBox(height: 4),
          DropdownButtonFormField<DeficiencyStatus>(
            value: _selectedStatus, // Текущее выбранное значение
            // Строим пункты меню из всех значений DeficiencyStatus
            items: DeficiencyStatus.values.map((DeficiencyStatus status) {
              return DropdownMenuItem<DeficiencyStatus>(
                value: status,
                // Отображаем имя статуса (open, inProgress и т.д.)
                child: Text(status.name),
              );
            }).toList(),
            // Обработчик изменения значения
            onChanged: (DeficiencyStatus? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedStatus = newValue; // Обновляем выбранный статус

                  // --- НОВАЯ ЛОГИКА: Авто-установка даты устранения ---
                  if (newValue == DeficiencyStatus.closed &&
                      _resolutionDate == null) {
                    _resolutionDate =
                        DateTime.now(); // Устанавливаем текущую дату
                    debugPrint(
                      "Статус изменен на 'Закрыто', дата устранения автоматически установлена: $_resolutionDate",
                    );
                  }
                  // ----------------------------------------------------
                });
              }
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ), // Уменьшим padding
            ),
          ),
          const SizedBox(height: 16),

          // --- Поле Ответственный ---
          const Text('Кому Поручено:'),
          const SizedBox(height: 4),
          TextFormField(
            controller: _assignedToController,
            decoration: const InputDecoration(
              hintText: 'Имя или должность...',
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
          const SizedBox(height: 16),

          // --- Поле Срок Устранения (Due Date) ---
          const Text('Срок Устранения:'),
          const SizedBox(height: 4),
          Row(
            // Используем Row для даты и кнопки выбора
            children: [
              Expanded(
                // Текст занимает доступное место
                child: Text(
                  _dueDate == null
                      ? 'Не установлен'
                      : '${_dueDate!.day}.${_dueDate!.month}.${_dueDate!.year}', // Форматируем дату
                ),
              ),
              IconButton(
                // Кнопка для вызова DatePicker
                icon: const Icon(Icons.calendar_month),
                tooltip: 'Выбрать дату срока',
                onPressed: () =>
                    _selectDueDate(context), // Вызываем метод выбора даты
              ),
            ],
          ),
          const Divider(), // Разделитель
          const SizedBox(height: 16),

          // --- Поле Действия по Устранению ---
          const Text('Корректирующие Действия:'),
          const SizedBox(height: 4),
          TextFormField(
            controller: _actionsController,
            maxLines: 5,
            textInputAction: TextInputAction.newline,
            decoration: const InputDecoration(
              hintText: 'Опишите, что было сделано...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // --- Поле Дата Устранения ---
          const Text('Дата Устранения:'),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  _resolutionDate == null
                      ? 'Не установлена'
                      : '${_resolutionDate!.day}.${_resolutionDate!.month}.${_resolutionDate!.year}',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.calendar_month),
                tooltip: 'Выбрать дату устранения',
                onPressed: () => _selectResolutionDate(
                  context,
                ), // Вызываем метод выбора даты
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 16),

          // --- Поле Фото ---
          Row(
            children: [
              const Text('Фото Несоответствия:'),
              const Spacer(), // Занимает место между текстом и кнопкой
              IconButton(
                icon: Icon(
                  (_photoPath != null && _photoPath!.isNotEmpty)
                      ? Icons.photo // Показываем, если фото есть
                      : Icons.add_a_photo_outlined, // Иконка добавления
                  color: (_photoPath != null && _photoPath!.isNotEmpty)
                      ? Theme.of(context).primaryColor
                      : Colors.grey[600],
                ),
                tooltip: (_photoPath != null && _photoPath!.isNotEmpty)
                    ? 'Просмотреть/Заменить Фото'
                    : 'Добавить Фото',
                onPressed: _handleDeficiencyPhoto, // <-- ВЫЗЫВАЕМ НОВЫЙ МЕТОД
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  // --------------------------------------------------

  // --------------------------------------------------
} // конец _DeficiencyDetailScreenState */
