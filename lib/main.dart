import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'services/storage_service.dart';
import 'services/database_service.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'controllers/settings_controller.dart';
import 'utils/app_themes.dart';
import 'utils/app_sittens.dart';
import 'utils/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة SharedPreferences
  await StorageService.instance.init();

  // تهيئة قاعدة البيانات
  await DatabaseService.instance.database;

  // Register settings controller (reads prefs)
  final settings = SettingsController();
  Get.put(settings);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settings = Get.find();
    final storage = StorageService.instance;
    final String initialRoute =
        storage.isLoggedIn ? AppRoutes.dashboard : AppRoutes.login;

    return Obx(() {
      final currentLocale = Locale(settings.language.value.isNotEmpty
          ? settings.language.value
          : AppSittens.defaultLanguage);
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'app_title'.tr,
        // تحديد الصفحة الابتدائية بناءً على الجلسة
        initialRoute: initialRoute,
        // صفحات التطبيق مع الـ middleware معرفة في AppPages
        getPages: AppPages.pages,
        // الترجمة
        translations: AppTranslations(),
        locale: currentLocale,
        fallbackLocale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        // الثيمات
        theme: AppThemes.light,
        darkTheme: AppThemes.dark,
        themeMode: settings.isDark.value ? ThemeMode.dark : ThemeMode.light,
      );
    });
  }
}
