import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/database_service.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController {
  final DatabaseService _databaseService = DatabaseService.instance;

  // Validation
  String? validateCategoryName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'please_fill_all_fields';
    }
    return null;
  }

  // Add category from name
  Future<Category?> addCategoryFromName(String name, int userId) async {
    final validationError = validateCategoryName(name);
    if (validationError != null) {
      Get.snackbar('error'.tr, validationError.tr);
      return null;
    }

    try {
      final category = Category(name: name.trim(), userId: userId);
      await addCategory(category);
      Get.snackbar('success'.tr, 'category_added'.tr);
      
      // Get the newly added category with its ID
      final categories = await getUserCategories(userId);
      return categories.firstWhere((cat) => cat.name == name.trim());
    } catch (e) {
      Get.snackbar('error'.tr, '${'save_failed'.tr}: $e');
      return null;
    }
  }

  // Update category from name
  Future<bool> updateCategoryFromName(Category category, String newName, int userId) async {
    if (newName.trim() == category.name) {
      return false; // No change
    }

    final validationError = validateCategoryName(newName);
    if (validationError != null) {
      Get.snackbar('error'.tr, validationError.tr);
      return false;
    }

    try {
      final updatedCategory = Category(
        id: category.id,
        name: newName.trim(),
        userId: userId,
        icon: category.icon,
      );
      await updateCategory(updatedCategory);
      Get.snackbar('success'.tr, 'category_updated'.tr);
      return true;
    } catch (e) {
      Get.snackbar('error'.tr, '${'save_failed'.tr}: $e');
      return false;
    }
  }

  // Delete category with confirmation
  Future<bool> deleteCategoryWithConfirmation(int categoryId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('delete'.tr),
        content: Text('are_you_sure'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await deleteCategory(categoryId);
        Get.snackbar('success'.tr, 'category_deleted'.tr);
        return true;
      } catch (e) {
        Get.snackbar('error'.tr, '${'save_failed'.tr}: $e');
        return false;
      }
    }
    return false;
  }

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
