// Файл: lib/screens/app_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marine_checklist_app/generated/l10n.dart'; // <-- ИМПОРТ

import '../main.dart';
import '../models/user_profile.dart';
import 'dashboard_screen.dart';

class AppSettingsScreen extends StatefulWidget {
  final bool isFirstRun;

  const AppSettingsScreen({
    super.key,
    this.isFirstRun = false,
  });

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  late Box<UserProfile> _profileBox;
  UserProfile _userProfile = UserProfile();
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _shipNameController = TextEditingController();
  final TextEditingController _captainNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileBox = Hive.box<UserProfile>(userProfileBoxName);
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final existingProfile = _profileBox.get(1);
    if (existingProfile != null) {
      _userProfile = existingProfile;
    }

    _nameController.text = _userProfile.name ?? '';
    _positionController.text = _userProfile.position ?? '';
    _shipNameController.text = _userProfile.shipName ?? '';
    _captainNameController.text = _userProfile.captainName ?? '';

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _shipNameController.dispose();
    _captainNameController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (!mounted) return;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      _userProfile.name = _nameController.text.trim();
      _userProfile.position = _positionController.text.trim();
      _userProfile.shipName = _shipNameController.text.trim();
      _userProfile.captainName = _captainNameController.text.trim();

      try {
        await _profileBox.put(1, _userProfile);
        // --- НОВАЯ СТРОКА: Уведомляем приложение о смене языка ---
        localeNotifier.value = Locale(_userProfile.languageCode ?? 'ru');

        if (!mounted) return;

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).settingsSaved),
            backgroundColor: Colors.green,
          ),
        );

        if (widget.isFirstRun) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else {
          if (Navigator.canPop(context)) Navigator.pop(context);
        }
      } catch (e) {
        debugPrint("Ошибка сохранения профиля: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).errorSavingProfile(e.toString())),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isFirstRun
              ? S.of(context).profileSetup
              : S.of(context).appSettings,
        ),
        automaticallyImplyLeading: !widget.isFirstRun,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: S.of(context).save,
            onPressed: _isLoading ? null : _saveSettings,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
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
          children: <Widget>[
            Text(S.of(context).yourName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: S.of(context).yourNameHint,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return S.of(context).nameCannotBeEmpty;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(S.of(context).yourPosition,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextFormField(
              controller: _positionController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: S.of(context).yourPositionHint,
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return S.of(context).positionCannotBeEmpty;
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(S.of(context).defaultVesselName,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextFormField(
              controller: _shipNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: S.of(context).defaultVesselNameHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(S.of(context).captainNameForReports,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            TextFormField(
              controller: _captainNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: S.of(context).captainNameHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              S.of(context).appLanguage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value:
                  _userProfile.languageCode ?? 'ru', // Язык по умолчанию 'ru'
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                // Список поддерживаемых языков
                DropdownMenuItem(
                  value: 'ru',
                  child: Text('Русский 🇷🇺'),
                ),
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English 🇬🇧'),
                ),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _userProfile.languageCode = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

/* // Файл: lib/screens/app_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../main.dart'; // Для userProfileBoxName
import '../models/user_profile.dart';
import 'dashboard_screen.dart'; // Импортируем DashboardScreen

class AppSettingsScreen extends StatefulWidget {
  // Флаг, указывающий, это первый запуск/настройка или обычный вызов настроек
  final bool isFirstRun;

  const AppSettingsScreen({
    super.key,
    this.isFirstRun = false, // По умолчанию это не первый запуск
  });

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  late Box<UserProfile> _profileBox;
  UserProfile _userProfile =
      UserProfile(); // Инициализируем пустым профилем по умолчанию
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>(); // Ключ для валидации формы

  // Контроллеры для текстовых полей
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _shipNameController = TextEditingController();
  final TextEditingController _captainNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileBox = Hive.box<UserProfile>(userProfileBoxName);
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    final existingProfile = _profileBox.get(
      1,
    ); // Профиль всегда хранится под ключом 1

    if (existingProfile != null) {
      _userProfile = existingProfile; // Используем существующий профиль
    }
    // Если existingProfile == null, _userProfile остается новым пустым объектом,
    // созданным при объявлении переменной.

    // Заполняем контроллеры данными из _userProfile
    _nameController.text = _userProfile.name ?? '';
    _positionController.text = _userProfile.position ?? '';
    _shipNameController.text = _userProfile.shipName ?? '';
    _captainNameController.text = _userProfile.captainName ?? '';

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Освобождаем все контроллеры
    _nameController.dispose();
    _positionController.dispose();
    _shipNameController.dispose();
    _captainNameController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    if (!mounted) return;

    // Проверяем валидность формы (если есть валидаторы)
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save(); // Вызываем onSaved у полей формы

      // Обновляем объект _userProfile данными из контроллеров
      _userProfile.name = _nameController.text.trim();
      _userProfile.position = _positionController.text.trim();
      _userProfile.shipName = _shipNameController.text.trim();
      _userProfile.captainName = _captainNameController.text.trim();

      try {
        // Сохраняем профиль в Hive под ключом 1
        await _profileBox.put(1, _userProfile);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Настройки сохранены!'),
              backgroundColor: Colors.green,
            ),
          );

          if (widget.isFirstRun) {
            // Импортируем DashboardScreen, если еще не импортирован
            // import 'dashboard_screen.dart'; // Убедитесь, что импорт есть вверху файла
            Navigator.pushReplacement(
              // Используем pushReplacement, чтобы пользователь не мог вернуться назад
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          } else {
            // Если это обычное редактирование, просто закрываем экран настроек
            if (Navigator.canPop(context)) Navigator.pop(context);
          }
        }
      } catch (e) {
        debugPrint("Ошибка сохранения профиля: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка сохранения: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isFirstRun ? 'Настройка Профиля' : 'Настройки Приложения',
        ),
        automaticallyImplyLeading:
            !widget
                .isFirstRun, // Не показывать кнопку "Назад" при первой настройке
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Сохранить',
            onPressed: _isLoading ? null : _saveSettings,
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildForm(), // Выносим форму в отдельный метод
    );
  }

  // --- Метод для построения формы ---
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Поле Имя Пользователя ---
            const Text(
              'Ваше Имя:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Например, Иван Иванов',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Имя не может быть пустым';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // --- Поле Должность ---
            const Text(
              'Ваша Должность:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _positionController,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Например, 2й Механик',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Должность не может быть пустой';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // --- Поле Название Судна ---
            const Text(
              'Название Судна (по умолчанию):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _shipNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Например, MV Example',
                border: OutlineInputBorder(),
              ),
              // Валидация опциональна, может быть пустым
            ),
            const SizedBox(height: 16),

            // --- Поле Имя Капитана (для отчетов) ---
            const Text(
              'Имя Капитана (для отчетов):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _captainNameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Например, Петр Петров',
                border: OutlineInputBorder(),
              ),
              // Валидация опциональна
            ),
            const SizedBox(height: 24),

            // Кнопка Сохранить, если не используется IconButton в AppBar
            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     onPressed: _isLoading ? null : _saveSettings,
            //     child: const Text('Сохранить Настройки'),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
} */
