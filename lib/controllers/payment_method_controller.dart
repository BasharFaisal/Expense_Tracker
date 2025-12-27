import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/database_service.dart';
import '../models/payment_method_model.dart';

class PaymentMethodController extends GetxController {
  final DatabaseService _databaseService = DatabaseService.instance;

  // Validation
  String? validatePaymentMethodName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'please_fill_all_fields';
    }
    return null;
  }

  // Add payment method from name
  Future<PaymentMethod?> addPaymentMethodFromName(String name, int userId) async {
    final validationError = validatePaymentMethodName(name);
    if (validationError != null) {
      Get.snackbar('error'.tr, validationError.tr);
      return null;
    }

    try {
      final paymentMethod = PaymentMethod(name: name.trim(), userId: userId);
      await addPaymentMethod(paymentMethod);
      Get.snackbar('success'.tr, 'payment_method_added'.tr);
      
      // Get the newly added payment method with its ID
      final methods = await getUserPaymentMethods(userId);
      return methods.firstWhere((method) => method.name == name.trim());
    } catch (e) {
      Get.snackbar('error'.tr, '${'save_failed'.tr}: $e');
      return null;
    }
  }

  // Update payment method from name
  Future<bool> updatePaymentMethodFromName(PaymentMethod paymentMethod, String newName, int userId) async {
    if (newName.trim() == paymentMethod.name) {
      return false; // No change
    }

    final validationError = validatePaymentMethodName(newName);
    if (validationError != null) {
      Get.snackbar('error'.tr, validationError.tr);
      return false;
    }

    try {
      final updatedPaymentMethod = PaymentMethod(
        id: paymentMethod.id,
        name: newName.trim(),
        userId: userId,
      );
      await updatePaymentMethod(updatedPaymentMethod);
      Get.snackbar('success'.tr, 'payment_method_updated'.tr);
      return true;
    } catch (e) {
      Get.snackbar('error'.tr, '${'save_failed'.tr}: $e');
      return false;
    }
  }

  // Delete payment method with confirmation
  Future<bool> deletePaymentMethodWithConfirmation(int methodId) async {
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
        await deletePaymentMethod(methodId);
        Get.snackbar('success'.tr, 'payment_method_deleted'.tr);
        return true;
      } catch (e) {
        Get.snackbar('error'.tr, '${'save_failed'.tr}: $e');
        return false;
      }
    }
    return false;
  }

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
