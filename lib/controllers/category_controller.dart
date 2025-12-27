import 'package:get/get.dart';
import '../services/database_service.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<void> addCategory(Category category) async {
    final db = await _databaseService.database;
    await db.insert('categories', category.toMap());
  }

  Future<void> updateCategory(Category category) async {
    final db = await _databaseService.database;
    await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  Future<void> deleteCategory(int categoryId) async {
    final db = await _databaseService.database;
    await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [categoryId],
    );
  }

  Future<List<Category>> getUserCategories(int userId) async {
    final db = await _databaseService.database;
    final result = await db.query(
      'categories',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return result.map((map) => Category.fromMap(map)).toList();
  }
}
