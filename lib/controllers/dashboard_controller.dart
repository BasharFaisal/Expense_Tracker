import 'package:get/get.dart';
import '../services/database_service.dart';

class DashboardController extends GetxController {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<double> getDailyTotal(int userId, DateTime date) async {
    final db = await _databaseService.database;
    final start = DateTime(date.year, date.month, date.day).toIso8601String();
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59, 999)
        .toIso8601String();

    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses WHERE user_id = ? AND date BETWEEN ? AND ?',
      [userId, start, end],
    );

    final value = result.first['total'];
    if (value == null) {
      return 0.0;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is double) {
      return value;
    }
    return double.tryParse(value.toString()) ?? 0.0;
  }

  Future<double> getMonthlyTotal(int userId, int year, int month) async {
    final db = await _databaseService.database;
    final start = DateTime(year, month, 1).toIso8601String();
    final nextMonth =
        (month == 12) ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);
    final end =
        nextMonth.subtract(const Duration(milliseconds: 1)).toIso8601String();

    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM expenses WHERE user_id = ? AND date BETWEEN ? AND ?',
      [userId, start, end],
    );

    final value = result.first['total'];
    if (value == null) {
      return 0.0;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is double) {
      return value;
    }
    return double.tryParse(value.toString()) ?? 0.0;
  }

  Future<Map<int, double>> getDailyTotalsByCategory(
      int userId, DateTime date) async {
    final db = await _databaseService.database;
    final start = DateTime(date.year, date.month, date.day).toIso8601String();
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59, 999)
        .toIso8601String();

    final result = await db.rawQuery(
      'SELECT category_id, SUM(amount) as total FROM expenses WHERE user_id = ? AND date BETWEEN ? AND ? GROUP BY category_id',
      [userId, start, end],
    );

    final Map<int, double> totals = {};
    for (final row in result) {
      final catId = row['category_id'];
      final val = row['total'];
      if (catId == null) {
        continue;
      }
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

  Future<Map<int, double>> getMonthlyTotalsByCategory(
      int userId, int year, int month) async {
    final db = await _databaseService.database;
    final start = DateTime(year, month, 1).toIso8601String();
    final nextMonth =
        (month == 12) ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);
    final end =
        nextMonth.subtract(const Duration(milliseconds: 1)).toIso8601String();

    final result = await db.rawQuery(
      'SELECT category_id, SUM(amount) as total FROM expenses WHERE user_id = ? AND date BETWEEN ? AND ? GROUP BY category_id',
      [userId, start, end],
    );

    final Map<int, double> totals = {};
    for (final row in result) {
      final catId = row['category_id'];
      final val = row['total'];
      if (catId == null) {
        continue;
      }
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
