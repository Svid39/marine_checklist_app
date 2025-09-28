
// Главный файл приложения Marine Checklist App.
// Этот файл отвечает за инициализацию всех необходимых сервисов (Flutter, Hive),
// регистрацию моделей данных, открытие "ящиков" базы данных и запуск
// корневого виджета приложения [MyApp].

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:marine_checklist_app/generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'models/enums.dart';
import 'models/user_profile.dart';
import 'models/checklist_template.dart';
import 'models/checklist_item.dart';
import 'models/checklist_instance.dart';
import 'models/checklist_item_response.dart';
import 'models/deficiency.dart';
import 'services/database_seeder.dart';
import 'screens/dashboard_screen.dart';
import 'screens/app_settings_screen.dart';

// --- НОВЫЕ ИМПОРТЫ ДЛЯ FIREBASE ---
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// ------------------------------------

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

// --- ПРАВИЛЬНОЕ МЕСТО ДЛЯ ОБЪЯВЛЕНИЯ ---
/// Глобальный уведомитель для статуса подключения к Firebase.
final ValueNotifier<bool> firebaseConnectedNotifier = ValueNotifier(false);
// ----------------------------------------

/// Основная функция и точка входа в приложение.
Future<void> main() async {
  // Гарантирует, что все биндинги Flutter инициализированы перед выполнением асинхронных операций.
  WidgetsFlutterBinding.ensureInitialized();

   // --- НОВЫЙ БЛОК: Инициализация Firebase ---
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // Если успешно, меняем статус на "онлайн"
    firebaseConnectedNotifier.value = true;
  } catch (e) {
    // Если ошибка (нет интернета), статус остается "офлайн"
    firebaseConnectedNotifier.value = false;
  }
  // -----------------------------------------
  
  // Инициализирует Hive и все его компоненты.
  await _initializeHive();

  // Заполняет базу данных начальными шаблонами, если она пуста.
  await DatabaseSeeder().seedInitialTemplates();

  // Определяет, какой экран должен быть показан при запуске.
  final initialScreen = await _resolveInitialScreen();

  runApp(MyApp(homeScreen: initialScreen));
}

/// Выполняет полную инициализацию Hive: регистрацию адаптеров и открытие ящиков.
Future<void> _initializeHive() async {
  await Hive.initFlutter();
  _registerHiveAdapters();
  await _openHiveBoxes();
}

/// Регистрирует все адаптеры типов для работы с Hive.
void _registerHiveAdapters() {
  Hive.registerAdapter(UserProfileAdapter());
  Hive.registerAdapter(ChecklistTemplateAdapter());
  Hive.registerAdapter(ChecklistItemAdapter());
  Hive.registerAdapter(ChecklistInstanceAdapter());
  Hive.registerAdapter(ChecklistItemResponseAdapter());
  Hive.registerAdapter(DeficiencyAdapter());
  Hive.registerAdapter(ChecklistInstanceStatusAdapter());
  Hive.registerAdapter(ResponseTypeAdapter());
  Hive.registerAdapter(ItemResponseStatusAdapter());
  Hive.registerAdapter(DeficiencyStatusAdapter());
  Hive.registerAdapter(SyncStatusAdapter()); // <-- Убедитесь, что этот адаптер добавлен
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

  if (userProfile?.languageCode != null && userProfile!.languageCode!.isNotEmpty) {
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
class MyApp extends StatelessWidget {
  /// Экран, который будет показан при запуске ([DashboardScreen] или [AppSettingsScreen]).
  final Widget homeScreen;

  /// Создает экземпляр приложения.
  const MyApp({
    super.key,
    required this.homeScreen,
  });

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder слушает изменения в localeNotifier и перестраивает
    // MaterialApp с новой локалью при необходимости.
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, currentLocale, child) {
        return MaterialApp(
          locale: currentLocale,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          title: 'Marine Checklist App',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
            useMaterial3: true,
          ),
          home: homeScreen,
        );
      },
    );
  }
}
