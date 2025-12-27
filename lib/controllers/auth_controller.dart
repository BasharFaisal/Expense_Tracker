import 'package:get/get.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final DatabaseService _databaseService = DatabaseService.instance;

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
