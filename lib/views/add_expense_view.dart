import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/expense_controller.dart';
import '../models/expense_model.dart';
import '../services/storage_service.dart';
import 'app_drawer.dart';

class AddExpenseView extends StatefulWidget {
  const AddExpenseView({Key? key}) : super(key: key);

  @override
  AddExpenseViewState createState() => AddExpenseViewState();
}

class AddExpenseViewState extends State<AddExpenseView> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  final int _selectedCategoryId = 1;
  final int _selectedPaymentMethodId = 1;

  final ExpenseController _expenseController = ExpenseController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('add_expense'.tr)),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'amount'.tr),
                keyboardType: TextInputType.number),
            TextField(
                controller: _noteController,
                decoration: InputDecoration(labelText: 'note'.tr)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (date != null) {
                  setState(() => _selectedDate = date);
                }
              },
              child: Text('pick_date'.tr),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(_amountController.text);
                if (amount == null || amount <= 0) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('please_enter_valid_amount'.tr)),
                    );
                  }
                  return;
                }

                final userId = StorageService.instance.userId ?? 0;
                final expense = Expense(
                  amount: amount,
                  note: _noteController.text.isEmpty
                      ? null
                      : _noteController.text,
                  date: _selectedDate,
                  userId: userId,
                  categoryId: _selectedCategoryId,
                  paymentMethodId: _selectedPaymentMethodId,
                );

                try {
                  await _expenseController.addExpense(expense);
                  if (context.mounted) {
                    Get.back();
                    Get.snackbar('success'.tr, 'expense_saved'.tr);
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${'save_failed'.tr}: $e')),
                    );
                  }
                }
              },
              child: Text('save'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
