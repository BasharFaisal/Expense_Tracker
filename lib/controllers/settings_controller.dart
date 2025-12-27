import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/storage_service.dart';

class SettingsController extends GetxController {
  final StorageService _storage = StorageService.instance;

  final RxBool isDark = false.obs;
  final RxString language = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    // Load saved settings
    isDark.value = _storage.isDarkTheme;
    language.value = _storage.language;
  }

  Future<void> setTheme(bool dark) async {
    isDark.value = dark;
    await _storage.setTheme(dark);
    // notify GetX to update theme
    update();
  }

  Future<void> setLanguage(String langCode) async {
    language.value = langCode;
    await _storage.setLanguage(langCode);
    // update GetX locale
    Get.updateLocale(Locale(langCode));
    // Force rebuild to update all widgets
    update();
  }
}
