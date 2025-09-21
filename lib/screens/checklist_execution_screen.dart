import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marine_checklist_app/generated/l10n.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';
import '../models/checklist_instance.dart';
import '../models/checklist_item.dart';
import '../models/checklist_item_response.dart';
import '../models/checklist_template.dart';
import '../models/enums.dart';
import 'deficiency_detail_screen.dart';

/// Экран для выполнения или просмотра конкретной проверки.
///
/// Отображает все пункты [ChecklistItem] из связанного [ChecklistTemplate]
/// и позволяет пользователю вводить ответы [ChecklistItemResponse].
class ChecklistExecutionScreen extends StatefulWidget {
  /// Ключ экземпляра [ChecklistInstance] в Hive, который отображается.
  final dynamic instanceKey;
  /// Название чек-листа для отображения в AppBar.
  final String checklistName;

  const ChecklistExecutionScreen({
    super.key,
    required this.instanceKey,
    required this.checklistName,
  });

  @override
  State<ChecklistExecutionScreen> createState() =>
      _ChecklistExecutionScreenState();
}

class _ChecklistExecutionScreenState extends State<ChecklistExecutionScreen> {
  /// Текущий экземпляр проверки, с которым работает пользователь.
  ChecklistInstance? _instance;
  /// Шаблон, на основе которого создан текущий экземпляр.
  ChecklistTemplate? _template;
  /// Флаг состояния загрузки данных.
  bool _isLoading = true;
  /// Сообщение об ошибке, если данные не удалось загрузить.
  String? _error;
  /// "Ящик" Hive с экземплярами проверок.
  late Box<ChecklistInstance> _instancesBox;
  /// Список пунктов чек-листа, сгруппированных по секциям для отображения.
  List<MapEntry<String?, List<ChecklistItem>>> _groupedItems = [];

  @override
  void initState() {
    super.initState();
    _instancesBox = Hive.box<ChecklistInstance>(instancesBoxName);
    _loadChecklistData();
  }

  /// Загружает из Hive экземпляр проверки и связанный с ним шаблон.
  Future<void> _loadChecklistData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final templatesBox = Hive.box<ChecklistTemplate>(templatesBoxName);
      final instance = _instancesBox.get(widget.instanceKey);

      if (instance == null) {
        throw Exception(S.of(context).instanceNotFoundForKey(widget.instanceKey));
      }

      final template = templatesBox.get(instance.templateId);

      if (template == null) {
        throw Exception(S.of(context).templateNotFoundForKey(instance.templateId));
      }

      if (mounted) {
        setState(() {
          _instance = instance;
          _template = template;
          _groupChecklistItems(template.items);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = S.of(context).errorLoadingCheckData(e.toString());
          _isLoading = false;
        });
      }
    }
  }

  /// Группирует плоский список пунктов из шаблона в карту `[Секция -> Список пунктов]`.
  void _groupChecklistItems(List<ChecklistItem> allItems) {
    final Map<String?, List<ChecklistItem>> tempMap = {};
    for (var item in allItems) {
      final sectionKey = item.section;
      tempMap.putIfAbsent(sectionKey, () => []).add(item);
    }
    if (mounted) {
      setState(() {
        _groupedItems = tempMap.entries.toList();
      });
    }
  }

  /// Сохраняет текущее состояние экземпляра [ChecklistInstance] в Hive.
  ///
  /// Этот метод является центральной точкой для сохранения всех изменений,
  /// сделанных пользователем на этом экране.
  Future<void> _saveInstance() async {
    if (_instance == null || !mounted) return;
    try {
      await _instancesBox.put(widget.instanceKey, _instance!);
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(S.of(context).errorSaving), backgroundColor: Colors.red),
        );
      }
    }
  }

  /// Обновляет статус ответа ([ItemResponseStatus]) для указанного пункта.
  Future<void> _updateItemStatus(ChecklistItem item, ItemResponseStatus newStatus) async {
    if (_instance == null) return;

    final responseIndex = _instance!.responses.indexWhere((r) => r.itemId == item.order);
    if (responseIndex != -1) {
      _instance!.responses[responseIndex].status = newStatus;
    } else {
      _instance!.responses.add(ChecklistItemResponse(itemId: item.order, status: newStatus));
    }
    await _saveInstance();
    
    if (newStatus == ItemResponseStatus.notOk && mounted) {
      _showCreateDeficiencyDialog(item);
    }
  }

  /// Обновляет текстовый комментарий для указанного пункта.
  Future<void> _updateItemComment(ChecklistItem item, String? newComment) async {
    if (_instance == null) return;
    
    final responseIndex = _instance!.responses.indexWhere((r) => r.itemId == item.order);
    final commentToSave = (newComment != null && newComment.trim().isEmpty) ? null : newComment;
    
    if (responseIndex != -1) {
      _instance!.responses[responseIndex].comment = commentToSave;
    } else if (commentToSave != null) {
      _instance!.responses.add(ChecklistItemResponse(itemId: item.order, comment: commentToSave));
    }
    await _saveInstance();
  }

  /// Обновляет путь к фото для указанного пункта.
  Future<void> _updateItemPhotoPath(ChecklistItem item, String? newPhotoPath) async {
    if (_instance == null) return;
    final responseIndex = _instance!.responses.indexWhere((r) => r.itemId == item.order);
    final pathToSave = (newPhotoPath != null && newPhotoPath.trim().isEmpty) ? null : newPhotoPath;
    if (responseIndex != -1) {
      _instance!.responses[responseIndex].photoPath = pathToSave;
    } else if (pathToSave != null) {
      _instance!.responses.add(ChecklistItemResponse(itemId: item.order, photoPath: pathToSave));
    }
    await _saveInstance();
  }
  
  /// Помечает проверку как завершенную и возвращает пользователя на дашборд.
  Future<void> _completeChecklist() async {
    if (_instance == null || !mounted || _instance!.status == ChecklistInstanceStatus.completed) return;
    
    _instance!.status = ChecklistInstanceStatus.completed;
    _instance!.completionDate = DateTime.now();
    await _saveInstance();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).checkCompleted), backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }

  // --- Методы для UI ---

  @override
  Widget build(BuildContext context) {
    final bool canComplete = _instance != null && _instance!.status != ChecklistInstanceStatus.completed;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.checklistName),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: S.of(context).completeCheck,
            onPressed: canComplete ? _completeChecklist : null,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _buildBody(),
    );
  }

  /// Строит основное содержимое экрана в зависимости от состояния (загрузка, ошибка, данные).
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Ошибка: $_error', style: const TextStyle(color: Colors.red)),
        ),
      );
    }
    if (_instance == null || _template == null) {
      return Center(child: Text(S.of(context).failedToLoadCheckData));
    }
    return ListView.builder(
      itemCount: _groupedItems.length,
      itemBuilder: (context, sectionIndex) {
        final sectionEntry = _groupedItems[sectionIndex];
        final String sectionTitle = sectionEntry.key ?? S.of(context).otherItems;
        final List<ChecklistItem> itemsInSection = sectionEntry.value;
        return ExpansionTile(
          key: PageStorageKey<String>(sectionTitle),
          title: Text(sectionTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          initiallyExpanded: true,
          childrenPadding: const EdgeInsets.only(bottom: 8.0),
          children: itemsInSection.map((item) => _buildChecklistItemWidget(item)).toList(),
        );
      },
    );
  }

  /// Строит виджет для одного пункта чек-листа.
  Widget _buildChecklistItemWidget(ChecklistItem item) {
    final currentResponse = _instance!.responses.firstWhere(
      (r) => r.itemId == item.order,
      orElse: () => ChecklistItemResponse(itemId: item.order),
    );
    final bool hasComment = currentResponse.comment != null && currentResponse.comment!.isNotEmpty;
    final bool hasPhoto = currentResponse.photoPath != null && currentResponse.photoPath!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${item.order}. ${item.text}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 15),
              ),
              if (item.details != null && item.details!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 6.0),
                  child: Text(
                    item.details!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic),
                  ),
                ),
              const SizedBox(height: 8),
              _buildResponseWidget(item, currentResponse),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      hasComment ? Icons.comment : Icons.comment_outlined,
                      color: hasComment ? Theme.of(context).colorScheme.primary : Colors.grey[600],
                    ),
                    iconSize: 20,
                    tooltip: hasComment ? S.of(context).editComment : S.of(context).addComment,
                    onPressed: () => _showCommentDialog(item, currentResponse),
                  ),
                  IconButton(
                    icon: Icon(
                      hasPhoto ? Icons.photo : Icons.photo_camera_outlined,
                      color: hasPhoto ? Theme.of(context).colorScheme.primary : Colors.grey[600],
                    ),
                    iconSize: 20,
                    tooltip: hasPhoto ? S.of(context).managePhoto : S.of(context).addPhoto,
                    onPressed: () => _handleChecklistItemPhoto(item, currentResponse),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Строит виджет для ответа на пункт (например, кнопки OK/Не ОК).
  Widget _buildResponseWidget(ChecklistItem item, ChecklistItemResponse currentResponse) {
    final currentStatus = currentResponse.status;
    switch (item.responseType) {
      case ResponseType.okNotOkNA:
        return Center(
          child: ToggleButtons(
            isSelected: [
              currentStatus == ItemResponseStatus.ok,
              currentStatus == ItemResponseStatus.notOk,
              currentStatus == ItemResponseStatus.na,
            ],
            onPressed: (int buttonIndex) {
              final newStatus = ItemResponseStatus.values[buttonIndex];
              if (currentResponse.status != newStatus) {
                _updateItemStatus(item, newStatus);
              }
            },
            constraints: const BoxConstraints(minHeight: 32.0, minWidth: 55.0),
            borderRadius: BorderRadius.circular(6),
            selectedColor: Colors.white,
            fillColor: Theme.of(context).colorScheme.primary.withAlpha(204),
            color: Theme.of(context).colorScheme.onSurface.withAlpha(179),
            selectedBorderColor: Theme.of(context).colorScheme.primary,
            borderColor: Colors.grey[400],
            children: <Widget>[
              Text(S.of(context).ok),
              Text(S.of(context).notOk),
              Text(S.of(context).na),
            ],
          ),
        );
      case ResponseType.text:
      case ResponseType.number:
        return const SizedBox.shrink();
    }
  }

  /// Показывает диалог для добавления/редактирования комментария.
  Future<void> _showCommentDialog(ChecklistItem item, ChecklistItemResponse currentResponse) async {
    final commentController = TextEditingController(text: currentResponse.comment ?? '');
    final savedComment = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).commentToItem(item.order)),
          content: TextField(
            controller: commentController,
            autofocus: true,
            maxLines: null,
            decoration: InputDecoration(hintText: S.of(context).enterComment),
            keyboardType: TextInputType.multiline,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(S.of(context).cancel),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            TextButton(
              child: Text(S.of(context).save),
              onPressed: () => Navigator.pop(dialogContext, commentController.text),
            ),
          ],
        );
      },
    );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      commentController.dispose();
    });

    if (savedComment != null && mounted) {
      await _updateItemComment(item, savedComment);
    }
  }

  /// Показывает диалог с предложением создать несоответствие.
  void _showCreateDeficiencyDialog(ChecklistItem item) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).createDeficiency),
          content: Text(S.of(context).itemMarkedAsNotOk(item.order, item.text)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(S.of(context).later),
            ),
            TextButton(
              child: Text(S.of(context).create),
              onPressed: () {
                Navigator.pop(dialogContext);
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DeficiencyDetailScreen(
                        initialDescription: item.text,
                        initialInstanceKey: widget.instanceKey,
                        initialChecklistItemId: item.order,
                        initialShipName: _instance?.shipName, // Передаем имя судна version1.1
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // --- Методы для работы с фото ---

  /// Оркестрирует весь процесс работы с фото: от запроса разрешений до сохранения.
  Future<void> _handleChecklistItemPhoto(ChecklistItem item, ChecklistItemResponse currentResponse) async {
    String? action;
    if (currentResponse.photoPath != null && currentResponse.photoPath!.isNotEmpty) {
      action = await _showViewOrManageChecklistItemPhotoDialog(currentResponse.photoPath!);
      if (!mounted || action == null) return;
      if (action == 'delete') {
        try {
          final oldFile = File(currentResponse.photoPath!);
          if (await oldFile.exists()) await oldFile.delete();
        } catch (e) {
            // Ошибка удаления файла не критична, можно просто записать в лог
        }
        await _updateItemPhotoPath(item, null);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).photoDeleted), backgroundColor: Colors.orange));
        }
        return;
      }
    }

    final source = await showModalBottomSheet<ImageSource>(
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

    final permission = source == ImageSource.camera ? Permission.camera : Permission.photos;
    final permissionName = source == ImageSource.camera ? S.of(context).camera : S.of(context).gallery;
    PermissionStatus status = await permission.status;
    if (status.isDenied|| status.isRestricted) {
      status = await permission.request();
    }
     // Проверяем, активен ли виджет, сразу после асинхронного запроса
    if (!mounted) return;
    
    if (!status.isGranted) {
      String message = S.of(context).permissionRequiredFor(permissionName);
      if(status.isPermanentlyDenied) {
        message += S.of(context).permissionPermanentlyDenied;
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), showCloseIcon: true, duration: const Duration(seconds: 5),));
      }
      return;
    }

    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile == null || !mounted) return;

    // Проверяем, активен ли виджет, сразу после асинхронной операции
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).processingPhoto)));

    try {
      final newPath = await _getCompressedImage(pickedFile, item, _instance?.shipName, _instance?.port, _instance?.date);
      if (!mounted) return;
      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      if (newPath != null) {
        final oldPath = currentResponse.photoPath;
        await _updateItemPhotoPath(item, newPath);
        if (!mounted) return;
        if (oldPath != null && oldPath.isNotEmpty && oldPath != newPath) {
          try {
            final oldFile = File(oldPath);
            if (await oldFile.exists()) await oldFile.delete();
          } catch (e) {
            // Ошибка удаления старого файла не критична
          }
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).photoAddedOrUpdated), backgroundColor: Colors.green));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).failedToProcessPhoto), backgroundColor: Colors.orange));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(S.of(context).photoError(e.toString())), backgroundColor: Colors.red));
      }
    }
  }

  /// Показывает диалог для просмотра, удаления или замены существующего фото.
  Future<String?> _showViewOrManageChecklistItemPhotoDialog(String imagePath) async {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        insetPadding: const EdgeInsets.all(10),
        contentPadding: const EdgeInsets.all(8),
        content: Column(mainAxisSize: MainAxisSize.min, children: [Image.file(File(imagePath))]),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          TextButton(child: Text(S.of(context).close), onPressed: () => Navigator.pop(dialogContext)),
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

  /// Сжимает и сохраняет изображение в файловой системе, возвращая новый путь.
  Future<String?> _getCompressedImage(XFile originalFile, ChecklistItem item, String? shipName, String? port, DateTime? date) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imageDir = '${appDir.path}/checklist_images';
      await Directory(imageDir).create(recursive: true);
      final ext = originalFile.path.split('.').last.toLowerCase();
      final shipPart = _sanitizeForFilename(shipName, defaultVal: 'Ship');
      final portPart = _sanitizeForFilename(port, defaultVal: 'Port');
      final itemPart = item.order.toString();
      final datePart = date != null ? "${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}" : "NoDate";
      final uniqueName = '${shipPart}_${portPart}_ITEM_${itemPart}_${datePart}_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final targetPath = '$imageDir/$uniqueName';
      final result = await FlutterImageCompress.compressAndGetFile(originalFile.path, targetPath, quality: 80, minWidth: 1024, minHeight: 1024);
      return result?.path;
    } catch (e) {
      return null;
    }
  }

  /// Вспомогательная функция для создания безопасного имени файла.
  String _sanitizeForFilename(String? input, {String defaultVal = 'NA', int maxLength = 15}) {
    if (input == null || input.isEmpty) return defaultVal;
    String sanitized = input.toLowerCase().replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(RegExp(r'\s+'), '_');
    if (sanitized.length > maxLength) {
      sanitized = sanitized.substring(0, maxLength);
    }
    return sanitized.isEmpty ? 'sanitized' : sanitized;
  }
}






