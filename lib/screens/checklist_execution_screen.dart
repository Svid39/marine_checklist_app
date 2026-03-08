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

/// Экран для выполнения проверки.
///
/// Оптимизирован для работы с очень большими списками (2000+ пунктов)
/// за счет использования плоского списка и ленивой загрузки.
class ChecklistExecutionScreen extends StatefulWidget {
  final dynamic instanceKey;
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
  ChecklistInstance? _instance;
  ChecklistTemplate? _template;
  bool _isLoading = true;
  String? _error;
  late Box<ChecklistInstance> _instancesBox;

  // --- ОПТИМИЗАЦИЯ ---
  /// Плоский список для UI (содержит и Заголовки-строки, и Пункты-объекты).
  List<dynamic> _flatList = [];

  /// Карта для мгновенного доступа к ответам по ID пункта (вместо перебора списка).
  Map<int, ChecklistItemResponse> _responseMap = {};
  // -------------------

  @override
  void initState() {
    super.initState();
    _instancesBox = Hive.box<ChecklistInstance>(instancesBoxName);
    // Загружаем данные после построения UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadChecklistData();
    });
  }

  // --- ИНДИКАТОРЫ ЗАГРУЗКИ (v1.3.0) ---
  // Эти методы были пропущены в прошлой версии, теперь они добавлены
  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      ),
    );
  }

  void _hideLoadingDialog() {
    if (mounted) Navigator.pop(context);
  }
  // ------------------------------------

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
        throw Exception(
            S.of(context).instanceNotFoundForKey(widget.instanceKey));
      }

      final template = templatesBox.get(instance.templateId);

      if (template == null) {
        throw Exception(
            S.of(context).templateNotFoundForKey(instance.templateId));
      }

      // Асинхронно готовим данные, чтобы не блокировать UI
      await Future.microtask(() {
        if (!mounted) return;
        
        // 1. Заполняем карту ответов для скорости O(1)
        final newResponseMap = {for (var r in instance.responses) r.itemId: r};

        // 2. Готовим плоский список для UI
        final flatList = _prepareFlatList(template.items);

        setState(() {
          _instance = instance;
          _template = template;
          _responseMap = newResponseMap;
          _flatList = flatList;
          _isLoading = false;
        });
      });

    } catch (e) {
      if (mounted) {
        setState(() {
          _error = S.of(context).errorLoadingCheckData(e.toString());
          _isLoading = false;
        });
      }
    }
  }

  /// Превращает структуру с секциями в один длинный список для ListView.builder.
  List<dynamic> _prepareFlatList(List<ChecklistItem> allItems) {
    final List<dynamic> flat = [];
    // Группируем пункты по секциям
    final Map<String, List<ChecklistItem>> groupedMap = {};

    for (var item in allItems) {
      final sectionKey = item.section ?? '';
      groupedMap.putIfAbsent(sectionKey, () => []).add(item);
    }

    // Разворачиваем группы в плоский список: [Заголовок, Пункт, Пункт, Заголовок...]
    for (var entry in groupedMap.entries) {
      final sectionName = entry.key;
      final items = entry.value;

      if (sectionName.isNotEmpty) {
        flat.add(sectionName); // Добавляем строку-заголовок
      } else {
        flat.add(S.of(context).otherItems);
      }
      flat.addAll(items); // Добавляем сами пункты
    }
    return flat;
  }

  Future<void> _saveInstance() async {
    if (_instance == null || !mounted) return;
    try {
      await _instancesBox.put(widget.instanceKey, _instance!);
      if (mounted) setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(S.of(context).errorSaving),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  /// Синхронизирует изменение ответа и в Map (для UI), и в List (для БД).
  void _updateResponseInState(ChecklistItemResponse newResponse) {
    if (_instance == null) return;

    // Обновляем карту для мгновенного отображения
    _responseMap[newResponse.itemId] = newResponse;

    // Обновляем список для сохранения
    final index = _instance!.responses
        .indexWhere((r) => r.itemId == newResponse.itemId);
    if (index != -1) {
      _instance!.responses[index] = newResponse;
    } else {
      _instance!.responses.add(newResponse);
    }
  }

  Future<void> _updateItemStatus(
      ChecklistItem item, ItemResponseStatus newStatus) async {
    if (_instance == null || !mounted) return;

    // Берем ответ из карты или создаем новый
    final current =
        _responseMap[item.order] ?? ChecklistItemResponse(itemId: item.order);
    current.status = newStatus;

    _updateResponseInState(current);
    await _saveInstance();

    if (newStatus == ItemResponseStatus.notOk && mounted) {
      _showCreateDeficiencyDialog(item);
    }
  }

  Future<void> _updateItemComment(
      ChecklistItem item, String? newComment) async {
    if (_instance == null || !mounted) return;

    final current =
        _responseMap[item.order] ?? ChecklistItemResponse(itemId: item.order);
    current.comment =
        (newComment != null && newComment.trim().isEmpty) ? null : newComment;

    _updateResponseInState(current);
    await _saveInstance();
  }

  Future<void> _updateItemPhotoPath(
      ChecklistItem item, String? newPhotoPath) async {
    if (_instance == null || !mounted) return;

    final current =
        _responseMap[item.order] ?? ChecklistItemResponse(itemId: item.order);
    current.photoPath = (newPhotoPath != null && newPhotoPath.trim().isEmpty)
        ? null
        : newPhotoPath;

    _updateResponseInState(current);
    await _saveInstance();
  }

  Future<void> _completeChecklist() async {
    if (_instance == null ||
        !mounted ||
        _instance!.status == ChecklistInstanceStatus.completed) {
      return;
    }

    _instance!.status = ChecklistInstanceStatus.completed;
    _instance!.completionDate = DateTime.now();
    await _saveInstance();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).checkCompleted),
          backgroundColor: Colors.green));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canComplete = _instance != null &&
        _instance!.status != ChecklistInstanceStatus.completed;
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

  Widget _buildBody() {
    if (_isLoading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Ошибка: $_error',
                  style: const TextStyle(color: Colors.red))));
    }
    if (_instance == null || _template == null || _flatList.isEmpty) {
      return Center(child: Text(S.of(context).failedToLoadCheckData));
    }

    // --- ИСПОЛЬЗУЕМ ListView.builder (Ленивая загрузка) ---
    return ListView.builder(
      itemCount: _flatList.length,
      // Подгружаем немного элементов заранее для плавности скролла
      cacheExtent: 500,
      itemBuilder: (context, index) {
        final item = _flatList[index];

        if (item is String) {
          // Отрисовка ЗАГОЛОВКА СЕКЦИИ
          return Container(
            width: double.infinity,
            color: Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text(
              item,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          );
        } else if (item is ChecklistItem) {
          // Отрисовка ПУНКТА
          return _buildChecklistItemWidget(item);
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildChecklistItemWidget(ChecklistItem item) {
    // Мгновенное получение ответа из карты
    final currentResponse =
        _responseMap[item.order] ?? ChecklistItemResponse(itemId: item.order);

    final bool hasComment =
        currentResponse.comment != null && currentResponse.comment!.isNotEmpty;
    final bool hasPhoto = currentResponse.photoPath != null &&
        currentResponse.photoPath!.isNotEmpty;

    return Padding(
      key: ValueKey(item.order), // Для оптимизации обновлений
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${item.order}. ${item.text}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 15)),
              if (item.details != null && item.details!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 6.0),
                  child: Text(item.details!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(fontStyle: FontStyle.italic)),
                ),
              const SizedBox(height: 8),
              _buildResponseWidget(item, currentResponse),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                        hasComment ? Icons.comment : Icons.comment_outlined,
                        color: hasComment
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[600]),
                    iconSize: 20,
                    tooltip: hasComment
                        ? S.of(context).editComment
                        : S.of(context).addComment,
                    onPressed: () => _showCommentDialog(item, currentResponse),
                  ),
                  IconButton(
                    icon: Icon(
                        hasPhoto ? Icons.photo : Icons.photo_camera_outlined,
                        color: hasPhoto
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey[600]),
                    iconSize: 20,
                    tooltip: hasPhoto
                        ? S.of(context).managePhoto
                        : S.of(context).addPhoto,
                    onPressed: () =>
                        _handleChecklistItemPhoto(item, currentResponse),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResponseWidget(
      ChecklistItem item, ChecklistItemResponse currentResponse) {
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

  Future<void> _showCommentDialog(
      ChecklistItem item, ChecklistItemResponse currentResponse) async {
    final commentController =
        TextEditingController(text: currentResponse.comment ?? '');
    final savedComment = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
              onPressed: () => Navigator.pop(dialogContext)),
          TextButton(
              child: Text(S.of(context).save),
              onPressed: () =>
                  Navigator.pop(dialogContext, commentController.text)),
        ],
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) commentController.dispose();
    });
    if (savedComment != null && mounted) {
      await _updateItemComment(item, savedComment);
    }
  }

  void _showCreateDeficiencyDialog(ChecklistItem item) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(S.of(context).createDeficiency),
          content: Text(
              S.of(context).itemMarkedAsNotOk(item.order, item.text)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(S.of(context).later)),
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
                        initialShipName: _instance?.shipName, // Передаем имя судна
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

  Future<void> _handleChecklistItemPhoto(
      ChecklistItem item, ChecklistItemResponse currentResponse) async {
    if (!mounted) return;
    String? action;
    String? existingPhotoPath = currentResponse.photoPath;

    if (existingPhotoPath != null && existingPhotoPath.isNotEmpty) {
      action =
          await _showViewOrManageChecklistItemPhotoDialog(existingPhotoPath);
      if (!mounted || action == null) return;

      if (action == 'delete') {
        try {
          final oldFile = File(existingPhotoPath);
          if (await oldFile.exists()) await oldFile.delete();
        } catch (e) {/*...*/}
        await _updateItemPhotoPath(item, null);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(S.of(context).photoDeleted),
              backgroundColor: Colors.orange));
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
            ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(S.of(context).camera),
                onTap: () => Navigator.pop(context, ImageSource.camera)),
            ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(S.of(context).gallery),
                onTap: () => Navigator.pop(context, ImageSource.gallery)),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;

    final permission = source == ImageSource.camera
        ? Permission.camera
        : Permission.photos;
    final permissionName = source == ImageSource.camera
        ? S.of(context).camera
        : S.of(context).gallery;

    PermissionStatus status = await permission.status;
    if (status.isDenied || status.isRestricted) {
      status = await permission.request();
    }
    if (!mounted) return;
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(S.of(context).permissionRequired(permissionName)),
          showCloseIcon: true));
      return;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null || !mounted) return;

    // --- ИНДИКАТОР ЗАГРУЗКИ (v1.3.0) ---
    _showLoadingDialog(S.of(context).processingPhoto);

    try {
      final newPath = await _getCompressedImage(pickedFile, item,
          _instance?.shipName, _instance?.port, _instance?.date);
      
      _hideLoadingDialog(); // Скрываем индикатор
      if (!mounted) return;

      if (newPath != null) {
        final oldPath = currentResponse.photoPath;
        await _updateItemPhotoPath(item, newPath);
        if (!mounted) return;

        if (oldPath != null &&
            oldPath.isNotEmpty &&
            oldPath != newPath) {
          try {
            final oldFile = File(oldPath);
            if (await oldFile.exists()) await oldFile.delete();
          } catch (e) {/*...*/}
        }
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).photoAddedOrUpdated),
            backgroundColor: Colors.green));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).failedToProcessPhoto),
            backgroundColor: Colors.orange));
      }
    } catch (e) {
      _hideLoadingDialog(); // Скрываем индикатор при ошибке
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(S.of(context).photoError(e.toString())),
            backgroundColor: Colors.red));
      }
    }
  }

  Future<String?> _showViewOrManageChecklistItemPhotoDialog(
      String imagePath) async {
    if (!mounted) return null;
    return await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          contentPadding: const EdgeInsets.all(8),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Image.file(File(imagePath), height: 300)]),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            TextButton(
                child: Text(S.of(context).close),
                onPressed: () => Navigator.pop(dialogContext, null)),
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
        );
      },
    );
  }

  Future<String?> _getCompressedImage(XFile originalFile, ChecklistItem item,
      String? instanceShipName, String? instancePort, DateTime? instanceDate) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final imageDir = '${appDir.path}/checklist_images';
      await Directory(imageDir).create(recursive: true);
      final ext = originalFile.path.split('.').last.toLowerCase();
      final shipPart =
          _sanitizeForFilename(instanceShipName, defaultVal: 'ShipUnknown');
      final portPart =
          _sanitizeForFilename(instancePort, defaultVal: 'PortUnknown');
      final itemPart = item.order.toString();
      final datePart = instanceDate != null
          ? "${instanceDate.year}${instanceDate.month.toString().padLeft(2, '0')}${instanceDate.day.toString().padLeft(2, '0')}"
          : "DateUnknown";
      final uniqueName =
          '${shipPart}_${portPart}_ITEM_${itemPart}_${datePart}_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final targetPath = '$imageDir/$uniqueName';
      final result = await FlutterImageCompress.compressAndGetFile(
        originalFile.path,
        targetPath,
        quality: 80,
        minWidth: 1024,
        minHeight: 1024,
      );
      return result?.path;
    } catch (e) {
      return null;
    }
  }

  String _sanitizeForFilename(String? input,
      {String defaultVal = 'NA', int maxLength = 15}) {
    if (input == null || input.isEmpty) return defaultVal;
    String sanitized = input
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_');
    if (sanitized.length > maxLength) {
      sanitized = sanitized.substring(0, maxLength);
    }
    return sanitized.isEmpty ? 'sanitized' : sanitized;
  }
}



