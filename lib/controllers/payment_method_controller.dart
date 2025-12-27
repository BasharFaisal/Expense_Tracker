import 'package:get/get.dart';
import '../services/database_service.dart';
import '../models/payment_method_model.dart';

class PaymentMethodController extends GetxController {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<void> addPaymentMethod(PaymentMethod method) async {
    final db = await _databaseService.database;
    await db.insert('payment_methods', method.toMap());
  }

  Future<void> updatePaymentMethod(PaymentMethod method) async {
    final db = await _databaseService.database;
    await db.update(
      'payment_methods',
      method.toMap(),
      where: 'id = ?',
      whereArgs: [method.id],
    );
  }

  Future<void> deletePaymentMethod(int methodId) async {
    final db = await _databaseService.database;
    await db.delete(
      'payment_methods',
      where: 'id = ?',
      whereArgs: [methodId],
    );
  }

  Future<List<PaymentMethod>> getUserPaymentMethods(int userId) async {
    final db = await _databaseService.database;
    final result = await db.query(
      'payment_methods',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return result.map((map) => PaymentMethod.fromMap(map)).toList();
  }
}
