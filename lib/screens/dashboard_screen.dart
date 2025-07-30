// Файл: lib/screens/dashboard_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Для ValueListenableBuilder
import '../main.dart'; // Для имен ящиков
import '../models/user_profile.dart'; // Для профиля пользователя
import '../models/checklist_instance.dart';
import '../models/checklist_template.dart';
import '../models/enums.dart'; // Нужен для статуса
import 'template_selection_screen.dart'; // Для навигации
import 'checklist_execution_screen.dart'; // Для навигации
import 'deficiency_list_screen.dart'; // Для навигации к списку несоответствий
import '../models/deficiency.dart';
import 'app_settings_screen.dart';
import '../services/pdf_generator_service.dart'; // Для генерации PDF
import 'dart:io'; // Для File
import 'dart:typed_data'; // Для Uint8List
import 'package:path_provider/path_provider.dart'; // Для getTemporaryDirectory
import 'package:share_plus/share_plus.dart'; // Для функции "Поделиться"

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // --- ПЕРЕМЕННЫЕ СОСТОЯНИЯ ---
  UserProfile? _userProfile;
  // Для хранения шаблонов (чтобы легко получать имя по ID)
  Map<dynamic, ChecklistTemplate> _templateMap = {};
  // Мы будем слушать изменения ящиков напрямую с помощью ValueListenableBuilder,
  // чтобы списки обновлялись автоматически при завершении проверки.
  // Поэтому отдельные списки в состоянии не строго обязательны,
  // но оставим _userProfile для AppBar.

  @override
  void initState() {
    super.initState();
    _loadInitialData(); // Загружаем профиль и шаблоны один раз
  }

  // Загружаем данные, которые не меняются часто (профиль, шаблоны)
  Future<void> _loadInitialData() async {
    // ... (код загрузки профиля и шаблонов как был) ...
    // ВАЖНО: чтобы изменения профиля отражались на дашборде после возврата,
    // _loadInitialData() должен вызываться снова.
    // Самый простой способ - сделать это в then() после Navigator.push
    // Или, если AppSettingsScreen возвращает результат, обработать его.
    // Пока оставим так, обновление профиля на дашборде рассмотрим после теста.
    try {
      final profileBox = Hive.box<UserProfile>(userProfileBoxName);
      final templatesBox = Hive.box<ChecklistTemplate>(templatesBoxName);
      if (mounted) {
        setState(() {
          _userProfile = profileBox.get(1); // Загружаем профиль (ID=1)
          _templateMap = templatesBox.toMap(); // Загружаем все шаблоны
        });
      }
    } catch (e) {
      debugPrint("Ошибка загрузки начальных данных дашборда: $e");
      // Можно показать ошибку пользователю
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка загрузки данных: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // --- Функция для навигации на экран выполнения ---
  void _navigateToExecution(dynamic instanceKey, String? templateName) {
    if (instanceKey == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ChecklistExecutionScreen(
              instanceKey: instanceKey,
              checklistName:
                  templateName ??
                  'Checklist', // Используем имя шаблона или дефолтное
            ),
      ),
    ).then((_) {
      // Эта часть выполнится, когда пользователь вернется с экрана ChecklistExecutionScreen
      // Мы просто вызываем setState, чтобы обновить списки на Дашборде
      // (если проверка была завершена, она переместится в другой список)
      if (mounted) {
        setState(() {});
      }
    });
  }

  // --- НОВЫЙ МЕТОД: Показ диалога подтверждения удаления ---
  Future<void> _showDeleteConfirmationDialog(
    dynamic instanceKey,
    String? checklistName,
  ) async {
    if (!mounted) return;

    final TextEditingController confirmController = TextEditingController();
    // Используем ValueNotifier для управления состоянием кнопки "УДАЛИТЬ"
    final ValueNotifier<bool> deleteEnabled = ValueNotifier<bool>(false);

    // Слушатель для контроллера, обновляет состояние кнопки
    void confirmationListener() {
      deleteEnabled.value = confirmController.text.trim() == 'Delete';
    }

    confirmController.addListener(confirmationListener);

    // Показываем диалог и ждем результат (true если удалять, false/null если отмена)
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // Нельзя закрыть диалог кликом вне его
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Подтвердите Удаление'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Чтобы колонка не растягивалась
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Вы уверены, что хотите удалить проверку:\n"${checklistName ?? 'Без имени'}"?\n\nЭто действие необратимо!',
              ),
              const SizedBox(height: 15),
              Text(
                "Пожалуйста, введите слово 'Delete' для подтверждения:",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 5),
              // Используем ValueListenableBuilder для TextField, чтобы он обновлялся при изменении
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
                        borderSide: BorderSide(
                          color: Colors.red,
                        ), // Подчеркивание при фокусе
                      ),
                    ),
                    onChanged: (_) {
                      // Вызываем слушателя вручную при изменении (хотя addListener тоже должен работать)
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
              onPressed:
                  () => Navigator.pop(dialogContext, false), // Возвращаем false
            ),
            // Используем ValueListenableBuilder для кнопки "УДАЛИТЬ"
            ValueListenableBuilder<bool>(
              valueListenable: deleteEnabled,
              builder: (context, isEnabled, child) {
                return TextButton(
                  // Кнопка активна только если введено "удалить"
                  onPressed:
                      isEnabled
                          ? () => Navigator.pop(dialogContext, true)
                          : null, // Возвращаем true
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

    // Освобождаем ресурсы после закрытия диалога и завершения кадра
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // if (mounted) { // Проверка mounted здесь может быть излишней, т.к. мы уже в callback'е после закрытия
      confirmController.removeListener(confirmationListener);
      confirmController.dispose();
      deleteEnabled.dispose();
      // }
    });

    // Если пользователь подтвердил удаление
    if (confirmed == true && mounted) {
      await _deleteChecklistInstance(instanceKey);
    }
  }
  // ------------------------------------------------------

  // --- НОВЫЙ МЕТОД: Фактическое удаление из Hive ---
  Future<void> _deleteChecklistInstance(dynamic instanceKey) async {
    if (!mounted) return;
    try {
      final instancesBox = Hive.box<ChecklistInstance>(instancesBoxName);
      await instancesBox.delete(instanceKey);
      debugPrint("ChecklistInstance с ключом $instanceKey удален.");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Проверка удалена'),
            backgroundColor: Colors.orange,
          ),
        );
        // setState не нужен, ValueListenableBuilder сам обновит список
      }
      // TODO: Позже добавить удаление связанных Deficiency и фото
    } catch (e) {
      debugPrint("Ошибка удаления ChecklistInstance с ключом $instanceKey: $e");
      if (mounted) {
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

  // --- работа с PDF ---
  Future<void> _generateAndShareChecklistPdf(
    dynamic instanceKey,
    String? checklistName,
  ) async {
    if (!mounted) return;

    // Показываем индикатор загрузки (опционально, но желательно)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Генерация PDF для "${checklistName ?? "Отчет"}"...'),
      ),
    );

    try {
      // 1. Получаем необходимые данные
      final instance = Hive.box<ChecklistInstance>(
        instancesBoxName,
      ).get(instanceKey);
      if (instance == null) {
        throw Exception('Экземпляр проверки не найден для ключа $instanceKey');
      }
      final template =
          _templateMap[instance
              .templateId]; // _templateMap уже загружен в initState/loadInitialData
      if (template == null) {
        throw Exception('Шаблон не найден для ID ${instance.templateId}');
      }
      // _userProfile также должен быть уже загружен

      // 2. Генерируем PDF байты
      final pdfService = PdfGeneratorService();
      final Uint8List pdfBytes = await pdfService.generateChecklistInstancePdf(
        instance,
        template,
        _userProfile,
      );

      // 3. Сохраняем PDF во временный файл
      final tempDir = await getTemporaryDirectory();
      // Формируем имя файла, делая его более безопасным для разных систем
      final safeChecklistName =
          checklistName
              ?.replaceAll(RegExp(r'[^\w\s]+'), '')
              .replaceAll(' ', '_') ??
          'report';
      final filePath = '${tempDir.path}/${safeChecklistName}_$instanceKey.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      debugPrint('PDF сохранен во временный файл: $filePath');

      // --- НОВЫЙ КОД: Сбор путей к фотографиям для этого ChecklistInstance ---
      List<String> photoPathsForInstance = [];
      for (var response in instance.responses) {
        if (response.photoPath != null && response.photoPath!.isNotEmpty) {
          // Проверяем, существует ли файл, прежде чем добавить
          final photoFile = File(response.photoPath!);
          if (await photoFile.exists()) {
            photoPathsForInstance.add(response.photoPath!);
          } else {
            debugPrint('Файл фото не найден по пути: ${response.photoPath}');
          }
        }
      }
      debugPrint(
        'Найдено ${photoPathsForInstance.length} фото для этого отчета.',
      );
      // ---------------------------------------------------------------------

      // 4. Поделиться файлом
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).removeCurrentSnackBar(); // Убираем "Генерация PDF..."

        // --- НОВЫЙ КОД: Формируем список XFile для SharePlus ---
        List<XFile> filesToShare = [XFile(filePath)];
        for (String path in photoPathsForInstance) {
          filesToShare.add(XFile(path));
        }
        debugPrint('Всего файлов для отправки: ${filesToShare.length}');
        // -------------------------------------------------------

        // --- ИЗМЕНЕНИЕ: Создаем ShareParams и вызываем SharePlus.instance.share() ---
        final shareParams = ShareParams(
          text:
              'Отчет о проверке: ${template.name}', // template здесь должно быть доступно
          files: [XFile(filePath)], // Передаем список файлов
        );
        final result = await SharePlus.instance.share(shareParams);
        // ---------------------------------------------------------------------------

        if (result.status == ShareResultStatus.success) {
          debugPrint('PDF успешно отправлен/сохранен пользователем.');
        } else {
          debugPrint(
            'Отправка PDF была отменена или не удалась: ${result.status}',
          );
        }
      }
    } catch (e) {
      debugPrint('Ошибка при генерации или отправке PDF: $e');
      if (mounted) {
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

  @override
  Widget build(BuildContext context) {
    // Получаем ссылки на ящики в начале метода build
    final instancesBox = Hive.box<ChecklistInstance>(instancesBoxName);
    final deficienciesBox = Hive.box<Deficiency>(
      deficienciesBoxName,
    ); // <-- Получаем ящик несоответствий

    /* // Создаем объединенный "слушатель" для обоих ящиков
    final combinedListenable = Listenable.merge([
      instancesBox.listenable(), // Слушаем изменения в ящике проверок
      deficienciesBox.listenable(), // Слушаем изменения в ящике несоответствий
    ]); */

    return Scaffold(
      appBar: AppBar(
        // Отображаем данные пользователя
        title: Text(_userProfile?.position ?? 'Дашборд'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(_userProfile?.name ?? 'Пользователь'),
            ),
          ),
          // --- НОВАЯ КНОПКА НАСТРОЕК ---
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Настройки профиля',
            onPressed: () async {
              // Делаем async для ожидания результата, если понадобится
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => const AppSettingsScreen(
                        isFirstRun: false,
                      ), // Передаем isFirstRun: false
                ),
              );
              // После возврата с экрана настроек, перезагружаем данные профиля
              // чтобы обновить AppBar на Дашборде
              _loadInitialData();
            },
          ),
          // ------------------------------
        ],
      ),
      body: Padding(
        // Добавим общие отступы
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // Основной контент в колонке
          children: [
            // Кнопка начала новой проверки
            ElevatedButton.icon(
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Начать Новую Проверку'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TemplateSelectionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(
                  double.infinity,
                  40,
                ), // Кнопка на всю ширину
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 16), // Отступ
            // Используем ValueListenableBuilder для автоматического обновления списков
            Expanded(
              child: ValueListenableBuilder<Box<ChecklistInstance>>(
                // Внешний слушает instancesBox
                valueListenable:
                    instancesBox
                        .listenable(), // <--- ИСПРАВЛЕНИЕ: Слушаем конкретный ящик
                builder: (context, currentInstancesBox, _) {
                  // <--- ИСПРАВЛЕНИЕ: Получаем currentInstancesBox (это и есть снэпшот)
                  // Внутренний ValueListenableBuilder слушает deficienciesBox
                  return ValueListenableBuilder<Box<Deficiency>>(
                    valueListenable:
                        deficienciesBox
                            .listenable(), // <--- ИСПРАВЛЕНИЕ: Слушаем конкретный ящик
                    builder: (context, currentDeficienciesBox, _) {
                      // <--- ИСПРАВЛЕНИЕ: Получаем currentDeficienciesBox
                      // Теперь у нас есть актуальные ящики:
                      // currentInstancesBox (типа Box<ChecklistInstance>)
                      // currentDeficienciesBox (типа Box<Deficiency>)

                      final allInstancesMap =
                          currentInstancesBox
                              .toMap(); // Используем актуальный ящик
                      final inProgressInstances =
                          allInstancesMap.entries
                              .where(
                                (entry) =>
                                    entry.value.status ==
                                    ChecklistInstanceStatus.inProgress,
                              )
                              .toList();
                      final completedInstances =
                          allInstancesMap.entries
                              .where(
                                (entry) =>
                                    entry.value.status ==
                                    ChecklistInstanceStatus.completed,
                              )
                              .toList();

                      // Считаем открытые несоответствия из актуального currentDeficienciesBox
                      final openDeficienciesCount =
                          currentDeficienciesBox.values
                              .where(
                                (d) =>
                                    d.status == DeficiencyStatus.open ||
                                    d.status == DeficiencyStatus.inProgress,
                              )
                              .length;

                      // Если данных еще нет (или ошибка), можно показать индикатор/сообщение
                      // Но т.к. ValueListenableBuilder, он сработает когда данные появятся

                      // Используем ListView для всего контента, чтобы он скроллился
                      return ListView(
                        children: [
                          // --- НОВЫЙ КОД: Плитка для Несоответствий ---
                          ListTile(
                            leading: const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orangeAccent, // Цвет иконки
                            ),
                            title: const Text(
                              'Открытые Несоответствия',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ), // Немного выделим заголовок
                            ),
                            trailing: Container(
                              // Внутренние отступы для текста внутри контейнера
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ), // Немного увеличил отступы
                              decoration: BoxDecoration(
                                // Цвет фона зависит от количества несоответствий
                                color:
                                    openDeficienciesCount > 0
                                        ? Colors
                                            .redAccent // Красный, если есть открытые
                                        : Colors
                                            .blueGrey[300], // Серо-голубой, если нет
                                // Закругляем углы контейнера
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // Сделал немного круглее
                              ),
                              // Текст счетчика
                              child: Text(
                                '$openDeficienciesCount', // Само число
                                style: const TextStyle(
                                  color: Colors.white, // Белый цвет текста
                                  fontSize: 12, // Размер шрифта
                                  fontWeight:
                                      FontWeight
                                          .bold, // Жирный шрифт для лучшей читаемости
                                ),
                              ),
                            ),
                            onTap: () {
                              // Переход на экран списка несоответствий
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => const DeficiencyListScreen(),
                                ),
                              );
                            },
                          ),
                          const Divider(), // Разделитель
                          const SizedBox(height: 16),
                          // --- Секция "В Процессе" ---
                          Text(
                            'Проверки в Процессе (${inProgressInstances.length})',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                          // --- Секция "В Процессе" ---
                          if (inProgressInstances.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(
                                child: Text('Нет активных проверок'),
                              ),
                            )
                          else
                            // Используем Column т.к. мы уже внутри ListView
                            Column(
                              children:
                                  inProgressInstances.map((entry) {
                                    final instanceKey = entry.key;
                                    final instance = entry.value;
                                    final template =
                                        _templateMap[instance.templateId];
                                    return ListTile(
                                      title: Text(
                                        template?.name ?? 'Неизвестный шаблон',
                                      ),
                                      subtitle: Column(
                                        // Используем Column для нескольких строк в subtitle
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Начато: ${instance.date.day}.${instance.date.month}.${instance.date.year}',
                                          ),
                                          // --- НОВЫЕ СТРОКИ ДЛЯ ОТОБРАЖЕНИЯ КОНТЕКСТА ---
                                          if (instance.shipName != null &&
                                              instance.shipName!.isNotEmpty)
                                            Text(
                                              'Судно: ${instance.shipName}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          if (instance.port != null &&
                                              instance.port!.isNotEmpty)
                                            Text(
                                              'Порт: ${instance.port}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          if (instance.captainNameOnCheck !=
                                                  null &&
                                              instance
                                                  .captainNameOnCheck!
                                                  .isNotEmpty)
                                            Text(
                                              'Капитан: ${instance.captainNameOnCheck}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          if (instance.inspectorName != null &&
                                              instance
                                                  .inspectorName!
                                                  .isNotEmpty)
                                            Text(
                                              'Проверяющий: ${instance.inspectorName}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          // -------------------------------------------------
                                        ],
                                      ),

                                      trailing: IconButton(
                                        // <-- ВОТ КНОПКА УДАЛЕНИЯ
                                        icon: Icon(
                                          Icons.delete_outline,
                                          color: Colors.red.withAlpha(179),
                                        ),
                                        tooltip: 'Удалить проверку',
                                        // УБЕДИТЕСЬ, ЧТО ЗДЕСЬ ПРАВИЛЬНЫЙ ВЫЗОВ:
                                        onPressed:
                                            () => _showDeleteConfirmationDialog(
                                              instanceKey,
                                              template?.name,
                                            ),
                                      ),
                                      onTap:
                                          () => _navigateToExecution(
                                            instanceKey,
                                            template?.name,
                                          ), // Возобновить
                                    );
                                  }).toList(),
                            ),

                          const SizedBox(height: 24), // Отступ между секциями
                          // --- Секция "Завершенные" ---
                          Text(
                            'Завершенные Проверки (${completedInstances.length})',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const Divider(),
                          if (completedInstances.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: Center(
                                child: Text('Нет завершенных проверок'),
                              ),
                            )
                          else
                            Column(
                              children:
                                  completedInstances.map((entry) {
                                    final instanceKey = entry.key;
                                    final instance = entry.value;
                                    final template =
                                        _templateMap[instance.templateId];
                                    return ListTile(
                                      title: Text(
                                        template?.name ?? 'Неизвестный шаблон',
                                      ),
                                      subtitle: Column(
                                        // Используем Column
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            instance.completionDate != null
                                                ? 'Завершено: ${instance.completionDate!.day}.${instance.completionDate!.month}.${instance.completionDate!.year}'
                                                : 'Завершено: Дата не указана',
                                          ),
                                          // --- НОВЫЕ СТРОКИ ДЛЯ ОТОБРАЖЕНИЯ КОНТЕКСТА ---
                                          if (instance.shipName != null &&
                                              instance.shipName!.isNotEmpty)
                                            Text(
                                              'Судно: ${instance.shipName}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          if (instance.port != null &&
                                              instance.port!.isNotEmpty)
                                            Text(
                                              'Порт: ${instance.port}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          if (instance.captainNameOnCheck !=
                                                  null &&
                                              instance
                                                  .captainNameOnCheck!
                                                  .isNotEmpty)
                                            Text(
                                              'Капитан: ${instance.captainNameOnCheck}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          if (instance.inspectorName != null &&
                                              instance
                                                  .inspectorName!
                                                  .isNotEmpty)
                                            Text(
                                              'Проверяющий: ${instance.inspectorName}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          // -------------------------------------------------
                                        ],
                                      ),

                                      onTap:
                                          () => _navigateToExecution(
                                            instanceKey,
                                            template?.name,
                                          ), // Просмотреть
                                      // Добавляем кнопку PDF (пока без функции)
                                      // --- ИЗМЕНЕНИЕ: Row для кнопок PDF и Удалить ---
                                      trailing: Row(
                                        mainAxisSize:
                                            MainAxisSize
                                                .min, // Чтобы Row не растягивался
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                              Icons.picture_as_pdf_outlined,
                                            ),
                                            iconSize:
                                                20, // <-- Уменьшаем размер иконки
                                            padding:
                                                EdgeInsets
                                                    .zero, // <-- Убираем стандартные отступы кнопки
                                            visualDensity:
                                                VisualDensity
                                                    .compact, // <-- Делаем кнопку компактнее
                                            tooltip:
                                                'Создать PDF отчет (не реализовано)',
                                            onPressed:
                                                () =>
                                                    _generateAndShareChecklistPdf(
                                                      instanceKey,
                                                      template?.name,
                                                    ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete_outline,
                                              color: Colors.red.withAlpha(179),
                                            ),
                                            iconSize:
                                                20, // <-- Уменьшаем размер иконки
                                            padding:
                                                EdgeInsets
                                                    .zero, // <-- Убираем стандартные отступы кнопки
                                            visualDensity:
                                                VisualDensity
                                                    .compact, // <-- Делаем кнопку компактнее
                                            tooltip: 'Удалить проверку',
                                            onPressed:
                                                () =>
                                                    _showDeleteConfirmationDialog(
                                                      instanceKey,
                                                      template?.name,
                                                    ),
                                          ),
                                        ],
                                      ),
                                      // ---------------------------------------------
                                    );
                                  }).toList(),
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
  } // конец build
}

// ------------------------------------------------------
