// Главный файл приложения Marine Checklist App.
//
// Этот файл отвечает за инициализацию всех необходимых сервисов (Flutter, Hive),
// регистрацию моделей данных, открытие "ящиков" базы данных и запуск
// корневого виджета приложения [MyApp].

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marine_checklist_app/generated/l10n.dart';

import 'models/checklist_instance.dart';
import 'models/checklist_item.dart';
import 'models/checklist_item_response.dart';
import 'models/checklist_template.dart';
import 'models/deficiency.dart';
import 'models/enums.dart';
import 'models/user_profile.dart';
import 'providers/theme_provider.dart';
import 'screens/app_settings_screen.dart';
import 'screens/dashboard_screen.dart';
import 'services/database_seeder.dart';
import 'theme/app_themes.dart';

// --- Константы для имен "ящиков" Hive ---

/// Имя ящика для хранения профиля пользователя [UserProfile].
const String userProfileBoxName = 'userProfileBox';

/// Имя ящика для хранения шаблонов чек-листов [ChecklistTemplate].
const String templatesBoxName = 'templatesBox';

/// Имя ящика для хранения экземпляров чек-листов [ChecklistInstance].
const String instancesBoxName = 'instancesBox';

/// Имя ящика для хранения несоответствий [Deficiency].
const String deficienciesBoxName = 'deficienciesBox';

/// Глобальный уведомитель, который хранит текущую локаль (язык) приложения.
///
/// [ValueListenableBuilder] в [MyApp] слушает этот объект и перестраивает
/// дерево виджетов при смене языка.
final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en'));

/// Основная функция и точка входа в приложение.
Future<void> main() async {
  // Гарантирует, что все биндинги Flutter инициализированы перед выполнением асинхронных операций.
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализирует Hive и все его компоненты.
  await _initializeHive();

  // Заполняет базу данных начальными шаблонами из JSON, если она пуста.
  await DatabaseSeeder().seedInitialTemplates();

  // Определяет, какой экран должен быть показан при запуске.
  final initialScreen = await _resolveInitialScreen();

  // Запускаем приложение
  runApp(
    ProviderScope( // <-- Обязательная обертка для Riverpod
      child: MyApp(homeScreen: initialScreen),
    ),
  );
} // <--- ВОТ ЭТУ СКОБКУ МЫ ПОТЕРЯЛИ! ТЕПЕРЬ ОНА НА МЕСТЕ.

/// Выполняет полную инициализацию Hive: регистрацию адаптеров и открытие ящиков.
Future<void> _initializeHive() async {
  await Hive.initFlutter();
  _registerHiveAdapters();
  await _openHiveBoxes();
}

/// Регистрирует все адаптеры типов для работы с Hive.
void _registerHiveAdapters() {
  Hive.registerAdapter(UserProfileAdapter()); // typeId: 0
  Hive.registerAdapter(ChecklistTemplateAdapter()); // typeId: 1
  Hive.registerAdapter(ChecklistItemAdapter()); // typeId: 2
  Hive.registerAdapter(ChecklistInstanceAdapter()); // typeId: 3
  Hive.registerAdapter(ChecklistItemResponseAdapter()); // typeId: 4
  Hive.registerAdapter(DeficiencyAdapter()); // typeId: 5
  Hive.registerAdapter(ChecklistInstanceStatusAdapter()); // typeId: 6
  Hive.registerAdapter(ResponseTypeAdapter()); // typeId: 7
  Hive.registerAdapter(ItemResponseStatusAdapter()); // typeId: 8
  Hive.registerAdapter(DeficiencyStatusAdapter()); // typeId: 9
  Hive.registerAdapter(SyncStatusAdapter()); // typeId: 10
}

/// Открывает все ящики Hive, используемые в приложении.
Future<void> _openHiveBoxes() async {
  await Hive.openBox<UserProfile>(userProfileBoxName);
  await Hive.openBox<ChecklistTemplate>(templatesBoxName);
  await Hive.openBox<ChecklistInstance>(instancesBoxName);
  await Hive.openBox<Deficiency>(deficienciesBoxName);
}

/// Определяет начальный экран и устанавливает локаль на основе сохраненного профиля.
Future<Widget> _resolveInitialScreen() async {
  final profileBox = Hive.box<UserProfile>(userProfileBoxName);
  UserProfile? userProfile = profileBox.get(1);

  if (userProfile?.languageCode != null &&
      userProfile!.languageCode!.isNotEmpty) {
    localeNotifier.value = Locale(userProfile.languageCode!);
  }

  final bool profileNeedsSetup = userProfile == null ||
      (userProfile.name == null || userProfile.name!.trim().isEmpty) ||
      (userProfile.position == null || userProfile.position!.trim().isEmpty);

  if (profileNeedsSetup) {
    return const AppSettingsScreen(isFirstRun: true);
  } else {
    return const DashboardScreen();
  }
}

/// Корневой виджет приложения.
class MyApp extends ConsumerWidget { // <-- Заменили StatelessWidget на ConsumerWidget
  final Widget homeScreen;

  const MyApp({
    super.key,
    required this.homeScreen,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) { // <-- Добавили WidgetRef
    // Подписываемся на изменения темы!
    final currentThemeMode = ref.watch(themeProvider);

    // Определяем активную ThemeData
    ThemeData activeTheme;
    switch (currentThemeMode) {
      case AppThemeMode.light:
        activeTheme = AppThemes.marineLight;
        break;
      case AppThemeMode.dark:
        activeTheme = AppThemes.marineDark;
        break;
      case AppThemeMode.standard:
      activeTheme = AppThemes.marineStandard;
    }

    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, currentLocale, child) {
        return MaterialApp(
          locale: currentLocale,
          localizationsDelegates: const [ // <-- Вернул твои делегаты локализации
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          title: 'Marine Checklist App',
          theme: activeTheme, // <-- Передаем нашу динамическую тему сюда!
          home: homeScreen,
        );
      },
    );
  }
}