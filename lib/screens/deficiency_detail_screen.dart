import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:marine_checklist_app/generated/l10n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
import '../models/checklist_instance.dart';
import '../models/deficiency.dart';
import '../models/enums.dart';
import '../models/user_profile.dart';

/// Экран для создания нового или редактирования существующего несоответствия.
class DeficiencyDetailScreen extends StatefulWidget {
  /// Ключ существующего [Deficiency] в Hive. `null` для создания нового.
  final dynamic deficiencyKey;

  /// Начальное описание (предзаполняется при создании из пункта чек-листа).
  final String? initialDescription;

  /// Ключ связанного [ChecklistInstance].
  final dynamic initialInstanceKey;

  /// ID связанного пункта чек-листа.
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

  final _descriptionController = TextEditingController();
  final _assignedToController = TextEditingController();
  final _actionsController = TextEditingController();

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

  @override
  void dispose() {
    _descriptionController.dispose();
    _assignedToController.dispose();
    _actionsController.dispose();
    super.dispose();
  }

  /// Загружает данные для экрана в зависимости от режима (создание/редактирование).
  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);


    _loadedUserProfile = Hive.box<UserProfile>(userProfileBoxName).get(1);

    if (widget.deficiencyKey == null) {
      _isNew = true;
      _deficiency = Deficiency(
        description: widget.initialDescription ?? '',
        instanceId: widget.initialInstanceKey,
        checklistItemId: widget.initialChecklistItemId,
        status: DeficiencyStatus.open,
      );
      _updateStateFromDeficiency();
      if (mounted) setState(() => _isLoading = false);
    } else {
      _isNew = false;
      try {
        final loadedDeficiency = _deficienciesBox.get(widget.deficiencyKey!);
        if (loadedDeficiency != null) {
          if (mounted) {
            setState(() {
              _deficiency = loadedDeficiency;
              _updateStateFromDeficiency();
              _isLoading = false;
            });
          }
        } else {
          throw Exception(S
              .of(context)
              .deficiencyNotFound(widget.deficiencyKey.toString()));
        }
      } catch (e) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(S.of(context).errorLoadingDeficiency),
                backgroundColor: Colors.red),
          );
          Navigator.pop(context);
        }
      }
    }
  }

  /// Обновляет контроллеры и переменные состояния данными из объекта [_deficiency].
  void _updateStateFromDeficiency() {
    if (_deficiency == null) return;
    _descriptionController.text = _deficiency!.description;
    _assignedToController.text = _deficiency!.assignedTo ?? '';
    _actionsController.text = _deficiency!.correctiveActions ?? '';
    _selectedStatus = _deficiency!.status;
    _dueDate = _deficiency!.dueDate;
    _resolutionDate = _deficiency!.resolutionDate;
    _photoPath = _deficiency!.photoPath;
  }

  /// Форматирует дату в локализованный строковый формат.
  String _formatDate(DateTime? date, {bool feminine = false}) {
    if (date == null) {
      return feminine ? S.of(context).notSetFeminine : S.of(context).notSet;
    }
    return DateFormat.yMd(Localizations.localeOf(context).languageCode)
        .format(date);
  }

  /// Отображает DatePicker для выбора даты и обновляет состояние.
  Future<void> _selectDate({required bool isDueDate}) async {
    final initialDate =
        (isDueDate ? _dueDate : _resolutionDate) ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && mounted) {
      setState(() {
        if (isDueDate) {
          _dueDate = pickedDate;
        } else {
          _resolutionDate = pickedDate;
        }
      });
    }
  }

  /// Валидирует форму и сохраняет объект [Deficiency] в Hive.
  Future<void> _saveDeficiency() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(S.of(context).pleaseFixErrorsInForm),
            backgroundColor: Colors.orange),
      );
      return;
    }

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
      } else {
        await _deficienciesBox.put(widget.deficiencyKey!, _deficiency!);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(S.of(context).deficiencySaved),
            backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(S.of(context).errorSavingDeficiency),
            backgroundColor: Colors.red),
      );
    }
  }

  /// Оркестрирует весь процесс работы с фото для несоответствия.
  Future<void> _handleDeficiencyPhoto() async {
    if (_photoPath != null && _photoPath!.isNotEmpty) {
      final action = await _showViewOrManagePhotoDialog(_photoPath!);
      if (!mounted || action == null) return;

      if (action == 'delete') {
        final pathToDelete = _photoPath;
        setState(() => _photoPath = null);
        if (pathToDelete != null) {
          try {
            final oldFile = File(pathToDelete);
            if (await oldFile.exists()) await oldFile.delete();
          } catch (e) {
            // Ошибка удаления файла не критична
          }
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(S.of(context).photoDeleted),
                backgroundColor: Colors.orange),
          );
        }
        return;
      }
      // Если action == 'replace', продолжаем выполнение
    }

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: Text(S.of(context).camera),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: Text(S.of(context).gallery),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    final permission =
        source == ImageSource.camera ? Permission.camera : Permission.photos;
    final permissionName = source == ImageSource.camera
        ? S.of(context).camera
        : S.of(context).gallery;
    PermissionStatus permissionStatus = await permission.status;
    if (permissionStatus.isDenied) {
      permissionStatus = await permission.request();
    }
    if (!mounted) return;
    if (!permissionStatus.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(S.of(context).permissionRequired(permissionName))),
      );
      return;
    }

    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null || !mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(S.of(context).processingPhoto)));

    try {
      String? contextShipName, contextPort;
      DateTime? contextDate;
      String contextIdentifier;
      final instanceId = _deficiency?.instanceId ?? widget.initialInstanceKey;
      if (instanceId != null) {
        final instance =
            Hive.box<ChecklistInstance>(instancesBoxName).get(instanceId);
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
        contextPort = "MANUAL";
        contextDate = DateTime.now();
        contextIdentifier = _isNew
            ? "NEW_MANUAL"
            : (widget.deficiencyKey?.toString() ?? "MANUAL_EDT");
      }

      final newPath = await _compressAndSaveDeficiencyImage(pickedFile,
          contextShipName, contextPort, contextDate, contextIdentifier);

      if (!mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      if (newPath != null) {
        
        if (_photoPath != null &&
            _photoPath!.isNotEmpty &&
            _photoPath != newPath) {
          try {
            final oldFile = File(_photoPath!);
            if (await oldFile.exists()) await oldFile.delete();
          } catch (e) {/* Не критично */}
        }

        if (!mounted) return;
        setState(() => _photoPath = newPath);
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).photoAddedOrUpdated),
            backgroundColor: Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).failedToProcessPhoto),
            backgroundColor: Colors.orange));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).photoError(e.toString())),
            backgroundColor: Colors.red));
      }
    }
  }

  /// Показывает диалог для просмотра, удаления или замены фото.
  Future<String?> _showViewOrManagePhotoDialog(String imagePath) async {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.all(8),
        content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Image.file(File(imagePath))]),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          TextButton(
              child: Text(S.of(context).close),
              onPressed: () => Navigator.pop(dialogContext)),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(S.of(context).delete),
            onPressed: () => Navigator.pop(dialogContext, 'delete'),
          ),
          ElevatedButton(
            child: Text(S.of(context).replacePhoto),
            onPressed: () => Navigator.pop(dialogContext, 'replace'),
          ),
        ],
      ),
    );
  }

  /// Сжимает и сохраняет изображение, возвращая новый путь.
  Future<String?> _compressAndSaveDeficiencyImage(XFile originalFile,
      String? shipName, String? port, DateTime? date, String identifier) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imageDir = '${appDir.path}/deficiency_photos';
      await Directory(imageDir).create(recursive: true);
      final ext = originalFile.path.split('.').last.toLowerCase();
      final shipPart = _sanitizeForFilename(shipName, defaultVal: 'ShipU');
      final portPart = _sanitizeForFilename(port, defaultVal: 'PortU');
      final idPart =
          _sanitizeForFilename(identifier, defaultVal: 'ID_U', maxLength: 25);
      final datePart = date != null
          ? "${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}"
          : "DateU";
      final uniqueName =
          'DEF_${shipPart}_${portPart}_${idPart}_${datePart}_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final targetPath = '$imageDir/$uniqueName';
      final result = await FlutterImageCompress.compressAndGetFile(
          originalFile.path, targetPath,
          quality: 80, minWidth: 1024, minHeight: 1024);
      return result?.path;
    } catch (e) {
      return null;
    }
  }

  /// Вспомогательная функция для создания безопасного имени файла.
  String _sanitizeForFilename(String? input,
      {String defaultVal = 'NA', int maxLength = 15}) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew
            ? S.of(context).newDeficiency
            : S.of(context).deficiencyDetails),
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

  /// Строит виджет формы для ввода данных несоответствия.
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(S.of(context).deficiencyDescription,
                style: const TextStyle(fontWeight: FontWeight.bold)),
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
                if (value == null || value.trim().isEmpty)
                  {return S.of(context).noDescription;}
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(S.of(context).status,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            DropdownButtonFormField<DeficiencyStatus>(
              value: _selectedStatus,
              items: DeficiencyStatus.values.map((status) {
                return DropdownMenuItem<DeficiencyStatus>(
                    value: status, child: Text(status.name));
              }).toList(),
              onChanged: (DeficiencyStatus? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedStatus = newValue;
                    if (newValue == DeficiencyStatus.closed &&
                        _resolutionDate == null) {
                      _resolutionDate = DateTime.now();
                    }
                  });
                }
              },
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Text(S.of(context).assignedTo,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextFormField(
              controller: _assignedToController,
              decoration: InputDecoration(
                  hintText: S.of(context).nameOrPosition,
                  border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Text(S.of(context).dueDate,
                style: const TextStyle(fontWeight: FontWeight.bold)),
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
            Text(S.of(context).correctiveActions,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextFormField(
              controller: _actionsController,
              maxLines: 5,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                  hintText: S.of(context).describeWhatWasDone,
                  border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Text(S.of(context).resolutionDate,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                    child: Text(_formatDate(_resolutionDate, feminine: true))),
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  tooltip: S.of(context).selectResolutionDate,
                  onPressed: () => _selectDate(isDueDate: false),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                Text(S.of(context).deficiencyPhoto,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    (_photoPath != null && _photoPath!.isNotEmpty)
                        ? Icons.photo
                        : Icons.add_a_photo_outlined,
                    color: (_photoPath != null && _photoPath!.isNotEmpty)
                        ? Theme.of(context).primaryColor
                        : Colors.grey[600],
                  ),
                  tooltip: (_photoPath != null && _photoPath!.isNotEmpty)
                      ? S.of(context).viewOrReplacePhoto
                      : S.of(context).addDeficiencyPhoto,
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
