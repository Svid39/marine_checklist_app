import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

// Импортируем ТОЛЬКО основные файлы моделей (.dart)
import 'models/enums.dart';
import 'models/user_profile.dart';
import 'models/checklist_template.dart';
import 'models/checklist_item.dart';
import 'models/checklist_instance.dart';
import 'models/checklist_item_response.dart';
import 'models/deficiency.dart';

// Импорт нашего сервиса для начальных данных
import 'services/database_seeder.dart';
// Импорт нашего главного экрана
import 'screens/dashboard_screen.dart';
import 'screens/app_settings_screen.dart'; // Для AppSettingsScreen

import 'package:marine_checklist_app/generated/l10n.dart'; // Make sure this import is correct
import 'package:flutter_localizations/flutter_localizations.dart';

// Константы для имен ящиков
const String userProfileBoxName = 'userProfileBox';
const String templatesBoxName = 'templatesBox';
const String instancesBoxName = 'instancesBox';
const String deficienciesBoxName = 'deficienciesBox';

final ValueNotifier<Locale> localeNotifier = ValueNotifier(const Locale('en'));

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Регистрируем адаптеры КЛАССОВ
  Hive.registerAdapter(UserProfileAdapter()); // typeId: 0
  Hive.registerAdapter(ChecklistTemplateAdapter()); // typeId: 1
  Hive.registerAdapter(ChecklistItemAdapter()); // typeId: 2
  Hive.registerAdapter(ChecklistInstanceAdapter()); // typeId: 3
  Hive.registerAdapter(ChecklistItemResponseAdapter()); // typeId: 4
  Hive.registerAdapter(DeficiencyAdapter()); // typeId: 5

  // Регистрируем адаптеры ENUM'ов
  // Названия адаптеров (напр., ChecklistInstanceStatusAdapter) доступны
  // через импорт основного файла enums.dart
  Hive.registerAdapter(ChecklistInstanceStatusAdapter()); // typeId: 6
  Hive.registerAdapter(ResponseTypeAdapter()); // typeId: 7
  Hive.registerAdapter(ItemResponseStatusAdapter()); // typeId: 8
  Hive.registerAdapter(DeficiencyStatusAdapter()); // typeId: 9

  // Открываем ящики Hive
  await Hive.openBox<UserProfile>(userProfileBoxName);
  await Hive.openBox<ChecklistTemplate>(templatesBoxName);
  await Hive.openBox<ChecklistInstance>(instancesBoxName);
  await Hive.openBox<Deficiency>(deficienciesBoxName);

  // Запускаем добавление начальных данных
  final seeder = DatabaseSeeder();
  await seeder.seedInitialTemplates();

  // --- НОВЫЙ КОД: Проверка профиля и определение стартового экрана ---
  final profileBox = Hive.box<UserProfile>(userProfileBoxName);
  UserProfile? userProfile = profileBox.get(1); // Профиль хранится под ключом 1

  // --- НОВЫЙ КОД: Устанавливаем начальную локаль из профиля ---
  if (userProfile?.languageCode != null &&
      userProfile!.languageCode!.isNotEmpty) {
    localeNotifier.value = Locale(userProfile.languageCode!);
  }
// --- КОНЕЦ НОВОГО КОДА ---

  Widget initialScreen;
  bool profileNeedsSetup = userProfile == null ||
      (userProfile.name == null || userProfile.name!.trim().isEmpty) ||
      (userProfile.position == null || userProfile.position!.trim().isEmpty);

  if (profileNeedsSetup) {
    debugPrint(
        "Профиль не найден или не заполнен. Открываем AppSettingsScreen.");
    initialScreen = const AppSettingsScreen(isFirstRun: true);
  } else {
    debugPrint("Профиль найден. Открываем DashboardScreen.");
    initialScreen = const DashboardScreen();
  }
  // ------------------------------------------------------------------

  runApp(MyApp(homeScreen: initialScreen)); // Передаем стартовый экран в MyApp
}

// --- ИЗМЕНЕНИЕ: MyApp теперь принимает homeScreen ---
class MyApp extends StatelessWidget {
  final Widget homeScreen;

  const MyApp({
    super.key,
    required this.homeScreen,
  });

  @override
  Widget build(BuildContext context) {
    // Оборачиваем MaterialApp в ValueListenableBuilder
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, currentLocale, child) {
        // Этот builder будет перестраиваться каждый раз,
        // когда меняется значение в localeNotifier
        return MaterialApp(
          locale: currentLocale, // <-- Устанавливаем текущую локаль

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
// -----------------------------------------------------
