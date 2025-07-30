// Файл: lib/screens/checklist_execution_screen.dart
import 'dart:io'; // Нужен для работы с File
import 'package:image_picker/image_picker.dart'; // <-- Для выбора фото
import 'package:path_provider/path_provider.dart'; // <-- Для получения пути к папкам
import 'package:flutter_image_compress/flutter_image_compress.dart'; // <-- Для сжатия фото
import 'package:permission_handler/permission_handler.dart'; // <-- Для запроса разрешений на доступ к фото
import 'package:flutter/material.dart'; // Импортируем Flutter Material
import 'package:hive_flutter/hive_flutter.dart'; // Импортируем Hive и его расширения
import '../main.dart'; // Нужен для имен ящиков (box names)
import '../models/checklist_instance.dart'; // Импортируем модель экземпляра чек-листа
import '../models/checklist_template.dart'; // Импортируем модель шаблона чек-листа
import '../models/checklist_item.dart'; // Импортируем модель пункта чек-листа
import '../models/checklist_item_response.dart'; // Импортируем модель ответа на пункт чек-листа
import '../models/enums.dart'; // Импортируем перечисления (enums) для статусов и типов ответов
import '../screens/deficiency_detail_screen.dart'; // Импортируем экран для создания/редактирования несоответствий

class ChecklistExecutionScreen extends StatefulWidget {
  final dynamic instanceKey; // Ключ экземпляра ChecklistInstance в Hive
  final String checklistName; // Название чек-листа для заголовка

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
  ChecklistInstance? _instance; // Экземпляр чек-листа, загруженный из Hive
  ChecklistTemplate? _template; // Шаблон чек-листа, загруженный из Hive
  bool _isLoading = true; // Флаг загрузки данных
  // bool _isLoading = true; // Флаг загрузки данных (можно убрать, если не нужно)
  String? _error; // Поле для ошибки пока оставляем, вдруг понадобится
  late Box<ChecklistInstance> _instancesBox;
  // --- НОВАЯ ПЕРЕМЕННАЯ СОСТОЯНИЯ для сгруппированных пунктов ---
  List<MapEntry<String?, List<ChecklistItem>>> _groupedItems = [];
  // String? - это название секции (может быть null, если секция не указана)
  // List<ChecklistItem> - список пунктов в этой секции
  // -------------------------------------------------------------

  @override
  void initState() {
    super.initState(); // <-- ВЫЗЫВАЕМ super.initState()!
    _instancesBox = Hive.box<ChecklistInstance>(instancesBoxName);
    _loadChecklistData();
  }



  String _sanitizeForFilename(String? input, {String defaultVal = 'NA', int maxLength = 15}) {
    if (input == null || input.isEmpty) return defaultVal;
    // Удаляем или заменяем недопустимые символы
    String sanitized = input
        .toLowerCase()
        .replaceAll(
          RegExp(r'[^\w\s-]'),
          '',
        ) // Оставляем буквы, цифры, пробелы, дефисы
        .replaceAll(RegExp(r'\s+'), '_'); // Заменяем пробелы на подчеркивания
    // Обрезаем, если слишком длинно
    if (sanitized.length > maxLength) {
      sanitized = sanitized.substring(0, maxLength);
    }
    return sanitized.isEmpty
        ? 'sanitized'
        : sanitized; // На случай если все символы были удалены
  }

  Future<void> _loadChecklistData() async {
    // Проверяем, жив ли виджет перед асинхронными операциями и setState
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });
    debugPrint(
      "--> _loadChecklistData: Начало загрузки для ключа ${widget.instanceKey}",
    );

    try {
      debugPrint("--> _loadChecklistData: Получаем templatesBox...");
      final templatesBox = Hive.box<ChecklistTemplate>(templatesBoxName);
      debugPrint("--> _loadChecklistData: templatesBox получен.");

      debugPrint(
        "--> _loadChecklistData: Загружаем instance с ключом ${widget.instanceKey}...",
      );
      final instance = _instancesBox.get(widget.instanceKey);
      debugPrint(
        "--> _loadChecklistData: instance загружен (null? ${instance == null})",
      );

      if (instance == null) {
        throw Exception('Экземпляр с ключом ${widget.instanceKey} не найден!');
      }

      debugPrint(
        "--> _loadChecklistData: Загружаем template с ключом ${instance.templateId}...",
      );
      final template = templatesBox.get(instance.templateId);
      debugPrint(
        "--> _loadChecklistData: template загружен (null? ${template == null})",
      );

      if (template == null) {
        throw Exception('Шаблон с ключом ${instance.templateId} не найден!');
      }

      debugPrint(
        "--> _loadChecklistData: Данные успешно загружены. Вызов setState...",
      );
      // Проверяем mounted снова перед setState
      if (mounted) {
        setState(() {
          _instance = instance;
          _template = template;
          if (_template != null) {
            _groupChecklistItems(_template!.items); // <-- ВЫЗЫВАЕМ ГРУППИРОВКУ
          }
          _isLoading = false;
        });
      }
      debugPrint(
        "--> _loadChecklistData: setState выполнен (или пропущен, если unmounted).",
      );
    } catch (e) {
      debugPrint("--> _loadChecklistData: ОШИБКА - $e");
      if (mounted) {
        // Проверяем mounted перед setState
        setState(() {
          _error = "Ошибка загрузки данных: $e";
          _isLoading = false;
        });
        debugPrint("--> _loadChecklistData: setState после ошибки выполнен.");
      }
    }
  }

  // ------------------------------------ НОВЫЙ МЕТОД: Группировка пунктов по секциям ----------
  void _groupChecklistItems(List<ChecklistItem> allItems) {
    final Map<String?, List<ChecklistItem>> tempMap = {};

    // Сначала соберем все пункты без секции (если такие есть)
    // (Это опционально, можно сделать так, чтобы они были первыми или последними)
    // List<ChecklistItem> itemsWithoutSection = allItems.where((item) => item.section == null || item.section!.isEmpty).toList();
    // if (itemsWithoutSection.isNotEmpty) {
    //   tempMap[null] = itemsWithoutSection; // Используем null как ключ для "без секции"
    // }

    // Проходим по всем пунктам
    for (var item in allItems) {
      // Используем название секции как ключ.
      // Если секция null или пустая, можно назначить ей специальный ключ,
      // например, "Общие" или оставить null. Давайте пока оставим как есть.
      final sectionKey = item.section;

      // Если такой секции еще нет в нашей карте, создаем для нее новый список
      if (!tempMap.containsKey(sectionKey)) {
        tempMap[sectionKey] = [];
      }
      // Добавляем пункт в список соответствующей секции
      tempMap[sectionKey]!.add(item);
    }

    // Обновляем состояние сгруппированными пунктами
    // Map.entries возвращает итератор, преобразуем его в список
    // Порядок секций будет зависеть от порядка их первого появления в allItems
    // (т.к. стандартная реализация Map в Dart - LinkedHashMap)
    if (mounted) {
      // Добавляем проверку, т.к. этот метод может вызываться из setState
      setState(() {
        _groupedItems = tempMap.entries.toList();
      });
    } else {
      // Если виджет уже не в дереве, просто присваиваем
      _groupedItems = tempMap.entries.toList();
    }

    debugPrint(
      "--> _groupChecklistItems: Пункты сгруппированы по ${_groupedItems.length} секциям.",
    );
  }
  // ----------------------------------------------------------------------------------------------

  // --- НОВЫЙ ВСПОМОГАТЕЛЬНЫЙ МЕТОД для отрисовки ОДНОГО пункта чек-листа --------------------------
  Widget _buildChecklistItemWidget(ChecklistItem item) {
    // Находим текущий сохраненный ответ для этого пункта (если он есть)
    // _instance должен быть уже загружен и не null к этому моменту
    final currentResponse = _instance!.responses.firstWhere(
      (r) => r.itemId == item.order,
      orElse:
          () => ChecklistItemResponse(
            itemId: item.order,
          ), // Возвращаем пустой, если не найден
    );
    final bool hasComment =
        currentResponse.comment != null && currentResponse.comment!.isNotEmpty;
    final bool hasPhoto =
        currentResponse.photoPath != null &&
        currentResponse.photoPath!.isNotEmpty; // Для иконки фото

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ), // Отступы для карточки внутри ExpansionTile
      child: Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(
          vertical: 2.0,
        ), // Уменьшим вертикальный отступ карточки
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Текст пункта (номер пункта теперь можно убрать, т.к. порядок внутри секции)
              // Или оставить item.order, если он важен глобально
              Text(
                '${item.order}. ${item.text}', // Если нужен глобальный номер
                //item.text, // Просто текст пункта
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 15,
                ), // Немного уменьшим
              ),
              // Детали
              if (item.details != null && item.details!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0, bottom: 6.0),
                  child: Text(
                    item.details!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              const SizedBox(height: 8),

              // Виджет для ответа (статус)
              _buildResponseWidget(
                item,
                currentResponse,
              ), // Передаем currentResponse
              // Кнопки Комментария и Фото (в ряду)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      hasComment ? Icons.comment : Icons.comment_outlined,
                      color:
                          hasComment
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[600],
                    ),
                    iconSize: 20,
                    tooltip:
                        hasComment
                            ? 'Редактировать комментарий'
                            : 'Добавить комментарий',
                    onPressed: () => _showCommentDialog(item, currentResponse),
                  ),
                  IconButton(
                    icon: Icon(
                      hasPhoto ? Icons.photo : Icons.photo_camera_outlined,
                      color:
                          hasPhoto
                              ? Theme.of(context).colorScheme.primary
                              : Colors.grey[600],
                    ),
                    iconSize: 20,
                    tooltip: hasPhoto ? 'Фото: Управление' : 'Добавить фото',
                    onPressed: () {
                      _handleChecklistItemPhoto(item, currentResponse);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  // -----------------------------------------------------------------------------------------------

  // ------------------------------------Обновление СТАТУСА------------------------------------------
  Future<void> _updateItemStatus(
    ChecklistItem item,
    ItemResponseStatus newStatus,
  ) async {
    debugPrint(
      "--> _updateItemStatus: Начало для пункта ${item.order}, новый статус $newStatus",
    );

    if (_instance == null || !mounted) {
      debugPrint(
        "--> _updateItemStatus: Выход (_instance null или unmounted)",
      ); // <-- ДОБАВЛЕНО
      return;
    } // Проверка mounted

    // ... (логика поиска/обновления responseIndex) ...
    final responseIndex = _instance!.responses.indexWhere(
      (r) => r.itemId == item.order,
    );
    if (responseIndex != -1) {
      _instance!.responses[responseIndex].status = newStatus;
    } else {
      final newResponse = ChecklistItemResponse(
        itemId: item.order,
        status: newStatus,
      );
      _instance!.responses.add(newResponse);
    }
    debugPrint(
      "--> _updateItemStatus: _instance обновлен локально, вызов _saveInstance...",
    ); // <-- ДОБАВЛЕНО

    await _saveInstance(); // Сохраняем и обновляем UI внутри saveInstance
    if (newStatus == ItemResponseStatus.notOk && mounted) {
      // Проверка mounted
      _showCreateDeficiencyDialog(item);
    }
    debugPrint(
      "--> _updateItemStatus: Завершение для пункта ${item.order}",
    ); // <-- ДОБАВЛЕНО
    // return; // Эта строка не обязательна для Future<void>
  }
  // ------------------------------------------------------------------------------------------------

  // ----------------------------------Обновление КОММЕНТАРИЯ----------------------------------------
  Future<void> _updateItemComment(
    ChecklistItem item,
    String? newComment,
  ) async {
    if (_instance == null || !mounted) return; // Проверка mounted
    final responseIndex = _instance!.responses.indexWhere(
      (r) => r.itemId == item.order,
    );
    final commentToSave =
        (newComment != null && newComment.trim().isEmpty) ? null : newComment;
    if (responseIndex != -1) {
      _instance!.responses[responseIndex].comment = commentToSave;
    } else if (commentToSave != null) {
      final newResponse = ChecklistItemResponse(
        itemId: item.order,
        comment: commentToSave,
      );
      _instance!.responses.add(newResponse);
    }
    await _saveInstance(); // Сохраняем и обновляем UI внутри saveInstance
  }
  // -----------------------------------------------------------------------------------------------

  // ------------------------------Отображение ДИАЛОГА КОММЕНТАРИЯ----------------------------------
  Future<void> _showCommentDialog(
    ChecklistItem item,
    ChecklistItemResponse currentResponse,
  ) async {
    // Локальный контроллер для диалога
    final TextEditingController commentController = TextEditingController(
      text: currentResponse.comment ?? '',
    );

    final String? savedComment = await showDialog<String>(
      context: context, // Используем context виджета
      builder: (BuildContext dialogContext) {
        // Локальный context для builder'а
        return AlertDialog(
          title: Text('Комментарий к п. ${item.order}'),
          content: TextField(
            controller: commentController, // Используем локальный контроллер
            autofocus: true,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: 'Введите комментарий...',
            ),
            keyboardType: TextInputType.multiline,
          ),
          actions: <Widget>[
            TextButton(
              // Убрали padding: EdgeInsets.zero
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            ),
            TextButton(
              // Убрали padding: EdgeInsets.zero
              child: const Text('Сохранить'),
              onPressed: () {
                Navigator.pop(dialogContext, commentController.text);
              },
            ),
          ],
        );
      },
    );
    // Освобождаем контроллер ПОСЛЕ того, как диалог закрыт
    // Заменяем старую строку dispose на это:
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Этот код выполнится после завершения текущего кадра отрисовки
      if (mounted) {
        // Добавим проверку mounted и здесь на всякий случай
        commentController.dispose();
      }
    });
    // Конец замены

    // Сохраняем только если пользователь нажал "Сохранить"
    // и виджет все еще в дереве
    if (savedComment != null && mounted) {
      await _updateItemComment(item, savedComment);
    }
  }
  // -----------------------------------------------------------------------------------------------

  // ----------------------------СОХРАНЕНИЕ ChecklistInstance в Hive--------------------------------
  Future<void> _saveInstance() async {
    debugPrint("--> _saveInstance: Начало"); // <-- ДОБАВЛЕНО
    if (_instance == null || !mounted) {
      debugPrint(
        "--> _saveInstance: Выход (_instance null или unmounted)",
      ); // <-- ДОБАВЛЕНО
      return;
    } // Проверка mounted
    try {
      debugPrint(
        "--> _saveInstance: Вызов _instancesBox.put...",
      ); // <-- ДОБАВЛЕНО
      // Сохраняем текущее состояние _instance по его ключу
      await _instancesBox.put(widget.instanceKey, _instance!);
      // Обновляем UI после успешного сохранения, чтобы отразить изменения
      // (например, подсветку кнопок, иконку комментария)
      debugPrint(
        "--> _saveInstance: _instancesBox.put УСПЕШНО выполнен.",
      ); // <-- ДОБАВЛЕНО
      if (mounted) {
        debugPrint("--> _saveInstance: Вызов setState..."); // <-- ДОБАВЛЕНО
        setState(() {});
        debugPrint("--> _saveInstance: setState выполнен."); // <-- ДОБАВЛЕНО
      } else {
        debugPrint(
          "--> _saveInstance: setState НЕ выполнен (unmounted).",
        ); // <-- ДОБАВЛЕНО
      }
    } catch (e) {
      debugPrint(
        "--> _saveInstance: ОШИБКА сохранения в Hive: $e",
      ); // <-- ДОБАВЛЕНО
      if (mounted) {
        // Проверка mounted перед показом SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ошибка сохранения!'),
            backgroundColor: Colors.red,
          ),
        );
      }
      debugPrint("--> _saveInstance: Завершение"); // <-- ДОБАВЛЕНО
    }
  }
  // -----------------------------------------------------------------------------------------------

  // --- ----------------------ВСПОМОГАТЕЛЬНЫЙ МЕТОД: Сжатие и сохранение --------------------------
  Future<String?> _getCompressedImage(
    XFile originalFile,
    ChecklistItem item,
    // --- НОВЫЕ ПАРАМЕТРЫ КОНТЕКСТА ---
    String? instanceShipName,
    String? instancePort,
    DateTime? instanceDate,
    // ---------------------------------
  ) async {
    try {
      // Получаем папку для хранения документов приложения
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String imageDir =
          '${appDir.path}/checklist_images'; // Создаем подпапку
      await Directory(imageDir).create(recursive: true);

      // // --- ВОТ ЗДЕСЬ ОПРЕДЕЛЯЕТСЯ fileExtension ---
      final String fileExtension =
          originalFile.path.split('.').last.toLowerCase();
      // ------------------------------------------- Создаем папку, если ее нет

      // --- НОВАЯ ЛОГИКА ФОРМИРОВАНИЯ ИМЕНИ ФАЙЛА ---
      final String shipPart = _sanitizeForFilename(
        instanceShipName,
        defaultVal: 'ShipUnknown',
      );

      final String portPart = _sanitizeForFilename(
        instancePort,
        defaultVal: 'PortUnknown',
      );
      final String itemOrderPart = item.order.toString();
      final String datePart =
          instanceDate != null
              ? "${instanceDate.year}${instanceDate.month.toString().padLeft(2, '0')}${instanceDate.day.toString().padLeft(2, '0')}"
              : "DateUnknown";

      final String uniqueFileName =
          '${shipPart}_${portPart}_ITEM_${itemOrderPart}_${datePart}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      // ---------------------------------------------

      final String targetPath = '$imageDir/$uniqueFileName';

      debugPrint("Оригинальный файл: ${originalFile.path}");
      debugPrint("Путь для сохранения сжатого файла: $targetPath");

      // Сжимаем файл
      final XFile? compressedXFile =
          await FlutterImageCompress.compressAndGetFile(
            originalFile.path, // Путь к исходному файлу
            targetPath, // Путь для сохранения сжатого файла
            quality: 80, // Качество сжатия (0-100)
            minWidth: 1024, // Минимальная ширина (если оригинал больше)
            minHeight: 1024, // Минимальная высота (если оригинал больше)
            // format: CompressFormat.jpeg // Можно указать формат
          );

      if (compressedXFile != null) {
        debugPrint("Файл успешно сжат и сохранен: ${compressedXFile.path}");
        return compressedXFile.path; // Возвращаем путь к сжатому файлу
      } else {
        debugPrint("Сжатие файла вернуло null.");
        return null;
      }
    } catch (e) {
      debugPrint("Ошибка сжатия/сохранения файла: $e");
      return null;
    }
  }
  // -----------------------------------------------------------------------------------------------

  // ----------------НОВЫЙ МЕТОД: Показ существующего фото пункта и опции управления-----------------
  Future<String?> _showViewOrManageChecklistItemPhotoDialog(
    String imagePath,
  ) async {
    if (!mounted) return null;

    return await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          contentPadding: const EdgeInsets.all(8),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [Image.file(File(imagePath)), const SizedBox(height: 10)],
          ),
          actionsAlignment: MainAxisAlignment.center,
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
              child: const Text('Заменить фото'),
              onPressed: () => Navigator.pop(dialogContext, 'replace'),
            ),
          ],
        );
      },
    );
  }
  // ------------------------------------------------------------------------------------------------

  // --- ОБНОВЛЕННЫЙ МЕТОД: Обработка фото пункта (просмотр/добавление/замена/удаление) -----------
  Future<void> _handleChecklistItemPhoto(
    ChecklistItem item,
    ChecklistItemResponse currentResponse,
  ) async {
    if (!mounted) return;
    String? action;
    String? existingPhotoPath =
        currentResponse.photoPath; // Получаем текущий путь к фото

    // ШАГ 1: Если фото уже есть, показываем диалог управления
    if (existingPhotoPath != null && existingPhotoPath.isNotEmpty) {
      action = await _showViewOrManageChecklistItemPhotoDialog(
        existingPhotoPath,
      );
      if (!mounted) {
        return; // Проверка, если виджет был удален пока показывался диалог
      }
      if (action == null) {
        // Пользователь нажал "Закрыть" в диалоге просмотра
        return;
      }

      if (action == 'delete') {
        // Пользователь выбрал "Удалить"
        try {
          final oldFile = File(existingPhotoPath);
          if (await oldFile.exists()) {
            await oldFile.delete();
            debugPrint("Файл фото пункта удален: $existingPhotoPath");
          }
        } catch (e) {
          debugPrint("Ошибка удаления старого файла пункта: $e");
        }

        await _updateItemPhotoPath(
          item,
          null,
        ); // Сохраняем null как путь к фото в Hive
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Фото пункта удалено'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return; // Действие "удалить" выполнено
      }
      // Если action == 'replace', то мы просто продолжаем выполнение метода ниже
      // для выбора нового фото. existingPhotoPath будет использован для удаления старого файла позже.
    }

    // Спрашиваем пользователя, откуда взять фото
    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder:
          (context) => SafeArea(
            // SafeArea для нижнего отступа
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Камера'),
                  onTap: () => Navigator.pop(context, ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Галерея'),
                  onTap: () => Navigator.pop(context, ImageSource.gallery),
                ),
              ],
            ),
          ),
    );

    if (source == null || !mounted) {
      return; // Пользователь отменил выбор или виджет удален
    }

    // --- НОВЫЙ БЛОК: Проверка и запрос разрешений ---
    Permission neededPermission;
    String permissionName;

    if (source == ImageSource.camera) {
      neededPermission = Permission.camera;
      permissionName = "Камера";
    } else {
      // Для галереи используем Permission.photos (для Android 13+ и iOS)
      // На старых Android может потребоваться Permission.storage, но photos обычно покрывает
      neededPermission = Permission.photos;
      permissionName = "Фото";
    }

    // Проверяем текущий статус разрешения
    PermissionStatus status = await neededPermission.status;
    debugPrint("Статус разрешения $permissionName: $status");

    // Если разрешение еще не выдано или отклонено
    if (status.isDenied || status.isRestricted) {
      // Запрашиваем разрешение
      status = await neededPermission.request();
      debugPrint(
        "Новый статус разрешения $permissionName после запроса: $status",
      );
    }

    // Если разрешение все еще не выдано (или запрещено навсегда)
    if (!status.isGranted) {
      String message =
          'Для добавления фото требуется разрешение на доступ к "$permissionName".';
      if (status.isPermanentlyDenied) {
        message += ' Пожалуйста, включите разрешение в настройках приложения.';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            showCloseIcon: true,
            duration: Duration(seconds: 5),
          ),
        );
        // Опционально: Предложить открыть настройки приложения
        if (status.isPermanentlyDenied) {
          // await openAppSettings(); // Функция из permission_handler
        }
      }
      return; // Прерываем выполнение, если нет разрешения
    }
    // --- КОНЕЦ БЛОКА ПРОВЕРКИ РАЗРЕШЕНИЙ ---

    // --- Если разрешение есть, продолжаем с ImagePicker ---

    // Используем image_picker для получения фото
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile == null || !mounted) {
      return; // Пользователь отменил выбор фото
    }

    // Показываем индикатор загрузки/обработки
    // (Можно реализовать более сложный индикатор состояния)
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Обработка фото...')));

    try {
      // Сжимаем и сохраняем фото
      final String? newCompressedPath =
          await _getCompressedImage(
            pickedFile,
            item,
            _instance
                ?.shipName, // Передаем shipName из текущего ChecklistInstance
            _instance?.port, // Передаем port
            _instance?.date, // Передаем дату начала проверки
          );

      if (newCompressedPath != null && mounted) {
        // Получаем путь к СТАРОМУ файлу ПЕРЕД обновлением
        final String? oldPath = currentResponse.photoPath;

        // Обновляем путь в Hive
        await _updateItemPhotoPath(item, newCompressedPath);

        // Удаляем старый файл ПОСЛЕ успешного сохранения нового пути
        if (oldPath != null &&
            oldPath.isNotEmpty &&
            oldPath != newCompressedPath) {
          try {
            final oldFile = File(oldPath);
            if (await oldFile.exists()) {
              await oldFile.delete();
              debugPrint("Старый файл фото удален: $oldPath");
            }
          } catch (e) {
            debugPrint("Ошибка удаления старого файла фото: $e");
            // Не критичная ошибка, просто старый файл останется
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).removeCurrentSnackBar(); // Убираем 'Обработка фото...'
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Фото добавлено/обновлено'),
              backgroundColor: Colors.green,
            ),
          );
        }
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
      debugPrint("Ошибка при обработке фото: $e");
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
  // -----------------------------------------------------------------------------------------------

  // ---------------------- РЕАЛИЗОВАННЫЙ МЕТОД: Обновление пути к фото в Hive ---------------------
  Future<void> _updateItemPhotoPath(
    ChecklistItem item,
    String? newPhotoPath,
  ) async {
    if (_instance == null || !mounted) return;
    final responseIndex = _instance!.responses.indexWhere(
      (r) => r.itemId == item.order,
    );
    final pathToSave =
        (newPhotoPath != null && newPhotoPath.trim().isEmpty)
            ? null
            : newPhotoPath;

    if (responseIndex != -1) {
      _instance!.responses[responseIndex].photoPath = pathToSave;
    } else if (pathToSave != null) {
      final newResponse = ChecklistItemResponse(
        itemId: item.order,
        photoPath: pathToSave,
      );
      _instance!.responses.add(newResponse);
    }

    // Если путь изменился, сохраняем в Hive
    if (responseIndex != -1 || pathToSave != null) {
      await _saveInstance(); // Сохраняем экземпляр с новым путем к фото
    }

    // !! Логику удаления старого файла перенесли в _handlePhotoAttachment ПОСЛЕ _saveInstance
    // Это безопаснее: сначала убедимся, что новый путь сохранен в БД, потом удаляем старый файл.
  }
  // -----------------------------------------------------------------------------------------------

  // --------------------------------НОВЫЙ МЕТОД: Завершение проверки ------------------------------
  Future<void> _completeChecklist() async {
    // Проверяем, загружен ли экземпляр и не завершен ли он уже
    if (_instance == null ||
        !mounted ||
        _instance!.status == ChecklistInstanceStatus.completed) {
      return; // Ничего не делаем, если нечего завершать или виджет удален
    }

    // TODO: Опционально - добавить проверку, все ли пункты заполнены?
    // Например, показать диалог подтверждения, если есть незаполненные пункты.

    // Обновляем статус и дату завершения
    _instance!.status = ChecklistInstanceStatus.completed;
    _instance!.completionDate = DateTime.now();

    // Сохраняем финальное состояние в Hive
    // Метод _saveInstance уже содержит проверку mounted и setState
    await _saveInstance();

    // Показываем сообщение об успехе (опционально)
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Проверка завершена'),
          backgroundColor: Colors.green,
        ),
      );
      // Возвращаемся на предыдущий экран (Дашборд)
      Navigator.pop(context);
    }
  }
  // -----------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    // Определяем, можно ли завершить проверку (для активации/деактивации кнопки)
    final bool canComplete =
        _instance != null &&
        _instance!.status != ChecklistInstanceStatus.completed;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.checklistName),
        // --- ДОБАВЛЯЕМ КНОПКУ ЗАВЕРШЕНИЯ В ACTIONS ---
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle_outline),
            tooltip: 'Завершить проверку',
            // Кнопка активна, только если проверка загружена и не завершена
            onPressed: canComplete ? _completeChecklist : null,
          ),
          const SizedBox(width: 8), // Небольшой отступ справа
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Отображаем ошибку, если она есть
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Ошибка: $_error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    // Если загрузка завершена, но данных нет (маловероятно после исправлений, но для надежности)
    if (_instance == null || _template == null || _groupedItems.isEmpty) {
      return const Center(child: Text('Не удалось загрузить данные проверки.'));
    }

    // Если все хорошо - строим список секций с помощью ExpansionTile
    return ListView.builder(
      itemCount: _groupedItems.length, // Количество секций
      itemBuilder: (context, sectionIndex) {
        final sectionEntry = _groupedItems[sectionIndex];
        final String sectionTitle =
            sectionEntry.key ?? 'Прочие пункты'; // Название секции или "Прочие"
        final List<ChecklistItem> itemsInSection = sectionEntry.value;

        return ExpansionTile(
          key: PageStorageKey<String>(
            sectionTitle,
          ), // Для сохранения состояния открыт/закрыт
          title: Text(
            sectionTitle,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          initiallyExpanded:
              true, // Пусть все секции будут раскрыты по умолчанию
          // backgroundColor: Colors.grey[100], // Опциональный фон для раскрытой секции
          childrenPadding: const EdgeInsets.only(
            bottom: 8.0,
          ), // Отступы для дочерних элементов
          // Создаем список виджетов для пунктов внутри этой секции
          children:
              itemsInSection.map((item) {
                // Для каждого пункта вызываем наш новый вспомогательный метод
                return _buildChecklistItemWidget(item);
              }).toList(),
        );
      },
    );
  }

  // Виджет для отображения кнопок статуса
  Widget _buildResponseWidget(
    ChecklistItem item,
    ChecklistItemResponse currentResponse,
  ) {
    final currentStatus = currentResponse.status;

    switch (item.responseType) {
      case ResponseType.okNotOkNA:
        return Center(
          // Центрируем ToggleButtons
          child: ToggleButtons(
            isSelected: [
              currentStatus == ItemResponseStatus.ok,
              currentStatus == ItemResponseStatus.notOk,
              currentStatus == ItemResponseStatus.na,
            ],
            onPressed: (int buttonIndex) {
              debugPrint(
                "--> ToggleButtons onPressed: buttonIndex = $buttonIndex",
              );

              // 1. Определяем НОВЫЙ статус по индексу кнопки
              ItemResponseStatus newStatus;
              if (buttonIndex == 0) {
                newStatus = ItemResponseStatus.ok;
              } else if (buttonIndex == 1) {
                newStatus = ItemResponseStatus.notOk;
              } else {
                // buttonIndex == 2
                newStatus = ItemResponseStatus.na;
              }

              // 2. Получаем ТЕКУЩИЙ СОХРАНЕННЫЙ статус из currentResponse
              // Переменная currentResponse ДОСТУПНА здесь, так как onPressed
              // находится внутри _buildResponseWidget, куда мы передали currentResponse
              final currentSavedStatus = currentResponse.status;

              debugPrint(
                "--> Определен newStatus: $newStatus, Текущий сохраненный: $currentSavedStatus",
              );

              // 3. Сравниваем и вызываем обновление ТОЛЬКО если статус изменился
              if (currentSavedStatus != newStatus) {
                debugPrint(
                  "--> Вызов _updateItemStatus для пункта ${item.order} со статусом $newStatus",
                );
                _updateItemStatus(
                  item,
                  newStatus,
                ); // Вызываем обновление и сохранение
              } else {
                debugPrint(
                  "--> Статус для пункта ${item.order} не изменился. Обновление не требуется.",
                );
              }
              // Конец onPressed
            },
            constraints: const BoxConstraints(
              minHeight: 32.0,
              minWidth: 55.0,
            ), // Уменьшил кнопки
            borderRadius: BorderRadius.circular(6),
            selectedColor: Colors.white,
            fillColor: Theme.of(
              context,
            ).colorScheme.primary.withAlpha(204), // Цвет фона выбранной
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withAlpha(179), // Цвет текста невыбранной
            selectedBorderColor:
                Theme.of(context).colorScheme.primary, // Цвет рамки выбранной
            borderColor: Colors.grey[400], // Цвет рамки невыбранной
            children: const <Widget>[
              // Используем Text напрямую без Padding
              Text('OK'),
              Text('Не ОК'),
              Text('N/A'),
            ],
          ),
        );

      case ResponseType.text:
      case ResponseType.number:
        // Ничего не отображаем для ввода этих типов в MVP
        return const SizedBox.shrink();
    }
    // return const SizedBox.shrink(); // Больше не нужно
  }

  void _showCreateDeficiencyDialog(ChecklistItem item) {
    debugPrint(
      'Нужно создать Deficiency для пункта ${item.order}: ${item.text}',
    );
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Создать Несоответствие?'),
          content: Text(
            'Пункт ${item.order}: ${item.text} отмечен как "Не ОК".',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Позже'),
            ),
            TextButton(
              child: const Text('Создать'),
              onPressed: () {
                Navigator.pop(dialogContext); // Закрываем диалог
                if (mounted) {
                  // --- ИЗМЕНЕНИЕ: Переход на DeficiencyDetailScreen ---
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => DeficiencyDetailScreen(
                            // Передаем начальные данные
                            initialDescription: item.text,
                            initialInstanceKey: widget.instanceKey,
                            initialChecklistItemId: item.order,
                            // deficiencyKey оставляем null, т.к. это создание
                          ),
                    ),
                  );
                  // -------------------------------------------------
                }
              },
            ),
          ],
        );
      },
    );
  }
} // конец _ChecklistExecutionScreenState
