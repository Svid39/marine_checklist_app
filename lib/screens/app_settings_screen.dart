import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marine_checklist_app/generated/l10n.dart';

import '../main.dart';
import '../models/user_profile.dart';
import 'dashboard_screen.dart';

/// Экран для настройки профиля пользователя и параметров приложения.
///
/// Работает в двух режимах:
/// - Режим первого запуска (`isFirstRun = true`), где нельзя вернуться назад.
/// - Режим обычных настроек (`isFirstRun = false`), куда можно зайти из главного меню.
class AppSettingsScreen extends StatefulWidget {
  /// Флаг, определяющий, является ли это первым запуском приложения.
  final bool isFirstRun;

  const AppSettingsScreen({
    super.key,
    this.isFirstRun = false,
  });

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
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

  /// Загружает существующий профиль из Hive или инициализирует новый.
  Future<void> _loadProfileData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final existingProfile = _profileBox.get(1);
    if (existingProfile != null) {
      _userProfile = existingProfile;
    }

    // Заполняем контроллеры и состояние данными из профиля
    _nameController.text = _userProfile.name ?? '';
    _positionController.text = _userProfile.position ?? '';
    _shipNameController.text = _userProfile.shipName ?? '';
    _captainNameController.text = _userProfile.captainName ?? '';
    
    // Устанавливаем язык в Dropdown. Если не сохранен, по умолчанию 'en'.
    // Мы также обновили это значение в main.dart при запуске.
    _userProfile.languageCode ??= 'en';


    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  /// Валидирует и сохраняет данные формы в Hive.
  Future<void> _saveSettings() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    _formKey.currentState!.save();

    // Обновляем "рабочий" объект данными из контроллеров.
    _userProfile.name = _nameController.text.trim();
    _userProfile.position = _positionController.text.trim();
    _userProfile.shipName = _shipNameController.text.trim();
    _userProfile.captainName = _captainNameController.text.trim();

    try {
      await _profileBox.put(1, _userProfile);

      // Уведомляем остальную часть приложения о возможной смене языка.
      localeNotifier.value = Locale(_userProfile.languageCode ?? 'en');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).settingsSaved),
          backgroundColor: Colors.green,
        ),
      );

      if (widget.isFirstRun) {
        // Заменяем экран настроек на главный экран без возможности вернуться.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
        );
      } else {
        // Просто закрываем экран настроек.
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).errorSavingProfile(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
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

  /// Строит виджет формы для редактирования данных профиля.
  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(S.of(context).yourName, style: const TextStyle(fontWeight: FontWeight.bold)),
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
            Text(S.of(context).yourPosition, style: const TextStyle(fontWeight: FontWeight.bold)),
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
            Text(S.of(context).defaultVesselName, style: const TextStyle(fontWeight: FontWeight.bold)),
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
            Text(S.of(context).captainNameForReports, style: const TextStyle(fontWeight: FontWeight.bold)),
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
            Text(
              S.of(context).appLanguage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: _userProfile.languageCode,
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
          ],
        ),
      ),
    );
  }
}

