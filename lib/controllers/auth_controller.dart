import 'package:get/get.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final DatabaseService _databaseService = DatabaseService.instance;

  // Validation
  String? validateLogin(String? email, String? password) {
    if (email == null || email.trim().isEmpty || password == null || password.isEmpty) {
      return 'please_enter_email_password';
    }
    return null;
  }

  String? validateRegister(String? name, String? email, String? password) {
    if (name == null || name.trim().isEmpty || 
        email == null || email.trim().isEmpty || 
        password == null || password.isEmpty) {
      return 'please_fill_all_fields';
    }
    return null;
  }

  // Login with validation
  Future<User?> loginWithValidation(String email, String password) async {
    final validationError = validateLogin(email, password);
    if (validationError != null) {
      Get.snackbar('error'.tr, validationError.tr);
      return null;
    }

    final user = await loginUser(email.trim(), password);
    if (user != null) {
      Get.snackbar('success'.tr, 'logged_in'.tr);
      return user;
    } else {
      Get.snackbar('error'.tr, 'invalid_credentials'.tr);
      return null;
    }
  }

  // Register with validation
  Future<bool> registerWithValidation(String name, String email, String password) async {
    final validationError = validateRegister(name, email, password);
    if (validationError != null) {
      Get.snackbar('error'.tr, validationError.tr);
      return false;
    }

    try {
      final user = User(
        name: name.trim(),
        email: email.trim(),
        password: password,
        role: 'User',
      );
      await registerUser(user);
      Get.snackbar('success'.tr, 'account_created'.tr);
      return true;
    } catch (e) {
      Get.snackbar('error'.tr, e.toString());
      return false;
    }
  }

  Future<void> registerUser(User user) async {
    final db = await _databaseService.database;
    await db.insert('users', user.toMap());
  }

  Future<User?> loginUser(String email, String password) async {
    final db = await _databaseService.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isNotEmpty) {
      final user = User.fromMap(result.first);
      await StorageService.instance.saveSession(
        userId: user.id!,
        role: user.role,
        username: user.name,
      );
      return user;
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    final db = await _databaseService.database;
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int userId) async {
    final db = await _databaseService.database;
    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}
