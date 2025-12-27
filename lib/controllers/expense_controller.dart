import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/database_service.dart';
import '../services/storage_service.dart';
import '../models/expense_model.dart';

class ExpenseController extends GetxController {
  final DatabaseService _databaseService = DatabaseService.instance;

  // Validation
  String? validateExpenseData(
      String? amount, int? categoryId, int? paymentMethodId) {
    if (amount == null || amount.isEmpty) {
      return 'please_enter_valid_amount';
    }
    final parsedAmount = double.tryParse(amount);
    if (parsedAmount == null || parsedAmount <= 0) {
      return 'please_enter_valid_amount';
    }
    if (categoryId == null) {
      return 'please_fill_all_fields';
    }
    if (paymentMethodId == null) {
      return 'please_fill_all_fields';
    }
    return null;
  }

  // Create expense from form data
  Future<bool> saveExpenseFromForm({
    required String amount,
    String? note,
    required DateTime date,
    required int? categoryId,
    required int? paymentMethodId,
    int? expenseId,
  }) async {
    final validationError =
        validateExpenseData(amount, categoryId, paymentMethodId);
    if (validationError != null) {
      Get.snackbar('error'.tr, validationError.tr);
      return false;
    }

    final userId = StorageService.instance.userId ?? 0;
    final parsedAmount = double.parse(amount);

    try {
      if (expenseId != null) {
        // Update
        final expense = Expense(
          id: expenseId,
          amount: parsedAmount,
          note: note?.isEmpty ?? true ? null : note,
          date: date,
          userId: userId,
          categoryId: categoryId!,
          paymentMethodId: paymentMethodId!,
        );
        await updateExpense(expense);
      } else {
        // Add
        final expense = Expense(
          amount: parsedAmount,
          note: note?.isEmpty ?? true ? null : note,
          date: date,
          userId: userId,
          categoryId: categoryId!,
          paymentMethodId: paymentMethodId!,
        );
        await addExpense(expense);
      }
      return true;
    } catch (e) {
      Get.snackbar('error'.tr, '${'save_failed'.tr}: $e');
      return false;
    }
  }

  // Delete expense with confirmation
  Future<bool> deleteExpenseWithConfirmation(int expenseId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('delete'.tr),
        content: const Text('Are you sure?'),
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
        await deleteExpense(expenseId);
        Get.snackbar('success'.tr, 'expense_deleted'.tr);
        return true;
      } catch (e) {
        Get.snackbar('error'.tr, '${'save_failed'.tr}: $e');
        return false;
      }
    }
    return false;
  }

  Future<void> addExpense(Expense expense) async {
    final db = await _databaseService.database;
    await db.insert('expenses', expense.toMap());
  }

  Future<void> updateExpense(Expense expense) async {
    final db = await _databaseService.database;
    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<void> deleteExpense(int expenseId) async {
    final db = await _databaseService.database;
    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [expenseId],
    );
  }

  Future<List<Expense>> getUserExpenses(int userId) async {
    final db = await _databaseService.database;
    final result = await db.query(
      'expenses',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'date DESC',
    );

    return result.map((map) => Expense.fromMap(map)).toList();
  }

  Future<Map<int, double>> getTotalByCategory(int userId) async {
    final db = await _databaseService.database;
    final result = await db.rawQuery(
      'SELECT category_id, SUM(amount) as total FROM expenses WHERE user_id = ? GROUP BY category_id',
      [userId],
    );

    final Map<int, double> totals = {};
    for (final row in result) {
      final catId = row['category_id'];
      final val = row['total'];
      if (catId == null) continue;
      int key = (catId is int) ? catId : int.parse(catId.toString());
      double amount;
      if (val == null) {
        amount = 0.0;
      } else if (val is int) {
        amount = val.toDouble();
      } else if (val is double) {
        amount = val;
      } else {
        amount = double.tryParse(val.toString()) ?? 0.0;
      }
      totals[key] = amount;
    }

    return totals;
  }
}
