// هذا الكلاس مسؤول عن:

// حفظ الجلسة

// جلبها

// حذفها

// اللغة والثيم

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService instance = StorageService._internal();
  StorageService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ---------- Session ----------
  Future<void> saveSession({
    required int userId,
    required String role,
    required String username,
  }) async {
    await _prefs.setInt('userId', userId);
    await _prefs.setString('role', role);
    await _prefs.setString('username', username);
  }

  int? get userId => _prefs.getInt('userId');
  String? get role => _prefs.getString('role');
  String? get username => _prefs.getString('username');

  bool get isLoggedIn => userId != null;

  Future<void> clearSession() async {
    await _prefs.remove('userId');
    await _prefs.remove('role');
    await _prefs.remove('username');
  }

  // ---------- Language ----------
  Future<void> setLanguage(String langCode) async {
    await _prefs.setString('language', langCode);
  }

  String get language => _prefs.getString('language') ?? 'en';

  // ---------- Theme ----------
  Future<void> setTheme(bool isDark) async {
    await _prefs.setBool('theme', isDark);
  }

  bool get isDarkTheme => _prefs.getBool('theme') ?? false;
}
