import 'package:get/get.dart';
import '../services/database_service.dart';
import '../models/expense_model.dart';

class ExpenseController extends GetxController {
  final DatabaseService _databaseService = DatabaseService.instance;

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
