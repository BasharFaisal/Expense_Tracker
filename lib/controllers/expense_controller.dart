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
}
