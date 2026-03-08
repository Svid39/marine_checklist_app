import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marine_checklist_app/generated/l10n.dart';

import '../main.dart';
import '../models/user_profile.dart';
import 'dashboard_screen.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';
import '../theme/app_themes.dart';

/// Экран для настройки профиля пользователя и параметров приложения.
///
/// Работает в двух режимах:
/// - **Первый запуск** (`isFirstRun = true`): Пользователь обязан заполнить профиль,
///   кнопка "Назад" скрыта. После сохранения происходит переход на Дашборд.
/// - **Настройки** (`isFirstRun = false`): Обычный режим редактирования, доступен
///   из главного меню.
class AppSettingsScreen extends ConsumerStatefulWidget {
  /// Флаг, указывающий, является ли это первым запуском приложения.
  final bool isFirstRun;

  const AppSettingsScreen({
    super.key,
    this.isFirstRun = false,
  });

  @override
  ConsumerState<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends ConsumerState<AppSettingsScreen> {
  /// "Ящик" Hive для доступа к профилю пользователя.
  late Box<UserProfile> _profileBox;

  /// "Рабочий" объект профиля, который редактируется на этом экране.
  UserProfile _userProfile = UserProfile();

  /// Флаг состояния загрузки данных.
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();

  // Контроллеры для полей формы
  final _nameController = TextEditingController();
  final _positionController = TextEditingController();
  final _shipNameController = TextEditingController();
  final _captainNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileBox = Hive.box<UserProfile>(userProfileBoxName);
    _loadProfileData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _positionController.dispose();
    _shipNameController.dispose();
    _captainNameController.dispose();
    super.dispose();
  }

  /// Загружает данные профиля из Hive.
  ///
  /// Если профиль уже существует, заполняет поля формы его данными.
  /// Если профиля нет (первый запуск), инициализирует пустую форму.
  Future<void> _loadProfileData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    final existingProfile = _profileBox.get(1);
    if (existingProfile != null) {
      _userProfile = existingProfile;
    }

    // Заполняем контроллеры данными
    _nameController.text = _userProfile.name ?? '';
    _positionController.text = _userProfile.position ?? '';
    _shipNameController.text = _userProfile.shipName ?? '';
    _captainNameController.text = _userProfile.captainName ?? '';

    // Устанавливаем язык по умолчанию, если он еще не выбран
    _userProfile.languageCode ??= 'en';

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// Валидирует форму, сохраняет данные в Hive и обновляет настройки приложения.
  Future<void> _saveSettings() async {
    if (!mounted) return;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Обновляем объект профиля данными из контроллеров
      _userProfile.name = _nameController.text.trim();
      _userProfile.position = _positionController.text.trim();
      _userProfile.shipName = _shipNameController.text.trim();
      _userProfile.captainName = _captainNameController.text.trim();

      try {
        // Сохраняем профиль в Hive (ключ всегда 1)
        await _profileBox.put(1, _userProfile);

        // Мгновенно обновляем язык приложения через глобальный notifier
        localeNotifier.value = Locale(_userProfile.languageCode ?? 'en');

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).settingsSaved),
            backgroundColor: Colors.green,
          ),
        );

        // Логика навигации
        if (widget.isFirstRun) {
          // Если первый запуск — заменяем экран на Дашборд
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardScreen()),
          );
        } else {
          // Если просто настройки — возвращаемся назад
          if (Navigator.canPop(context)) Navigator.pop(context);
        }
      } catch (e) {
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

  /// Строит форму настроек.
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Имя ---
            Text(
              S.of(context).yourName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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

            // --- Должность ---
            Text(
              S.of(context).yourPosition,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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

            // --- Название судна ---
            Text(
              S.of(context).defaultVesselName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
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

            // --- Имя Капитана ---
            Text(
              S.of(context).captainNameForReports,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _captainNameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: S.of(context).captainNameHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // --- Язык приложения ---
            Text(
              S.of(context).appLanguage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              initialValue: _userProfile.languageCode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'ru', child: Text('Русский 🇷🇺')),
                DropdownMenuItem(value: 'en', child: Text('English 🇬🇧')),
              ],
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _userProfile.languageCode = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            // --- Тема приложения ---
            const Text(
              'Theme (Тема оформления)', // Можно потом вынести в S.of(context)
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField<AppThemeMode>(
              // Читаем текущую тему напрямую из Riverpod
              // ignore: deprecated_member_use
              value: ref.watch(themeProvider),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                    value: AppThemeMode.light,
                    child: Text('☀️ Marine Light (Deck)')),
                DropdownMenuItem(
                    value: AppThemeMode.standard,
                    child: Text('⚙️ Marine Standard (Engine)')),
                DropdownMenuItem(
                    value: AppThemeMode.dark,
                    child: Text('🌙 Marine Dark (Bridge)')),
              ],
              onChanged: (AppThemeMode? newTheme) {
                if (newTheme != null) {
                  // Обновляем тему через провайдер (UI перерисуется мгновенно)
                  ref.read(themeProvider.notifier).setTheme(newTheme);

                  // Синхронизируем локальный объект профиля для корректного сохранения формы
                  setState(() {
                    _userProfile.themePreference = newTheme.name;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
