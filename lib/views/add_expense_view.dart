import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/expense_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/payment_method_controller.dart';
import '../models/expense_model.dart';
import '../models/category_model.dart';
import '../models/payment_method_model.dart';
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
  int? _selectedCategoryId;
  int? _selectedPaymentMethodId;
  bool _isEditing = false;
  Expense? _editingExpense;
  int _categoryKey = 0;
  int _paymentMethodKey = 0;

  final ExpenseController _expenseController = Get.find<ExpenseController>();
  final CategoryController _categoryController = Get.put(CategoryController());
  final PaymentMethodController _paymentMethodController =
      Get.put(PaymentMethodController());

  @override
  void initState() {
    super.initState();
    _loadExpenseFromArguments();
  }

  void _loadExpenseFromArguments() {
    final arguments = Get.arguments;
    if (arguments is Expense) {
      _editingExpense = arguments;
      _isEditing = true;
      _amountController.text = arguments.amount.toString();
      _noteController.text = arguments.note ?? '';
      _selectedDate = arguments.date;
      _selectedCategoryId = arguments.categoryId;
      _selectedPaymentMethodId = arguments.paymentMethodId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = StorageService.instance.userId ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'edit_expense'.tr : 'add_expense'.tr),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'amount'.tr),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: 'note'.tr),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FutureBuilder<List<Category>>(
                    key: ValueKey(_categoryKey),
                    future: _categoryController.getUserCategories(userId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        _selectedCategoryId ??= snapshot.data!.first.id;
                        return DropdownButtonFormField<int>(
                          value: _selectedCategoryId,
                          decoration:
                              InputDecoration(labelText: 'select_category'.tr),
                          items: snapshot.data!.map((category) {
                            return DropdownMenuItem<int>(
                              value: category.id,
                              child: Text(category.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCategoryId = value;
                            });
                          },
                        );
                      }
                      return DropdownButtonFormField<int>(
                        value: _selectedCategoryId,
                        decoration:
                            InputDecoration(labelText: 'select_category'.tr),
                        items: const [],
                        hint: Text('no_data'.tr),
                        onChanged: null,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'add_category'.tr,
                  onPressed: () => _showAddCategoryDialog(userId),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FutureBuilder<List<PaymentMethod>>(
                    key: ValueKey(_paymentMethodKey),
                    future:
                        _paymentMethodController.getUserPaymentMethods(userId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        _selectedPaymentMethodId ??= snapshot.data!.first.id;
                        return DropdownButtonFormField<int>(
                          value: _selectedPaymentMethodId,
                          decoration: InputDecoration(
                              labelText: 'select_payment_method'.tr),
                          items: snapshot.data!.map((method) {
                            return DropdownMenuItem<int>(
                              value: method.id,
                              child: Text(method.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPaymentMethodId = value;
                            });
                          },
                        );
                      }
                      return DropdownButtonFormField<int>(
                        value: _selectedPaymentMethodId,
                        decoration: InputDecoration(
                            labelText: 'select_payment_method'.tr),
                        items: const [],
                        hint: Text('no_data'.tr),
                        onChanged: null,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'add_payment_method'.tr,
                  onPressed: () => _showAddPaymentMethodDialog(userId),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    label: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
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
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveExpense,
                child: Text('save'.tr),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddCategoryDialog(int userId) async {
    final nameController = TextEditingController();
    final result = await Get.dialog<String>(
      AlertDialog(
        title: Text('add_category'.tr),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'category_name'.tr),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Get.back(result: nameController.text.trim());
              }
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        final category = Category(
          name: result,
          userId: userId,
        );
        await _categoryController.addCategory(category);
        // Reload categories to get the new ID
        final categories = await _categoryController.getUserCategories(userId);
        final addedCategory =
            categories.firstWhere((cat) => cat.name == result);
        setState(() {
          _categoryKey++; // Refresh the dropdown
          _selectedCategoryId =
              addedCategory.id; // Select the newly added category
        });
        Get.snackbar('success'.tr, 'category_added'.tr);
      } catch (e) {
        Get.snackbar('error'.tr, '${'save_failed'.tr}: $e');
      }
    }
  }

  Future<void> _showAddPaymentMethodDialog(int userId) async {
    final nameController = TextEditingController();
    final result = await Get.dialog<String>(
      AlertDialog(
        title: Text('add_payment_method'.tr),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'payment_method_name'.tr),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Get.back(result: nameController.text.trim());
              }
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        final paymentMethod = PaymentMethod(
          name: result,
          userId: userId,
        );
        await _paymentMethodController.addPaymentMethod(paymentMethod);
        // Reload payment methods to get the new ID
        final methods =
            await _paymentMethodController.getUserPaymentMethods(userId);
        final addedMethod =
            methods.firstWhere((method) => method.name == result);
        setState(() {
          _paymentMethodKey++; // Refresh the dropdown
          _selectedPaymentMethodId =
              addedMethod.id; // Select the newly added method
        });
        Get.snackbar('success'.tr, 'payment_method_added'.tr);
      } catch (e) {
        Get.snackbar('error'.tr, '${'save_failed'.tr}: $e');
      }
    }
  }

  Future<void> _saveExpense() async {
    if (_amountController.text.isEmpty) {
      Get.snackbar('error'.tr, 'please_enter_valid_amount'.tr);
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      Get.snackbar('error'.tr, 'please_enter_valid_amount'.tr);
      return;
    }

    if (_selectedCategoryId == null || _selectedPaymentMethodId == null) {
      Get.snackbar('error'.tr, 'please_fill_all_fields'.tr);
      return;
    }

    final userId = StorageService.instance.userId ?? 0;

    try {
      if (_isEditing && _editingExpense != null) {
        // Update existing expense
        final expense = Expense(
          id: _editingExpense!.id,
          amount: amount,
          note: _noteController.text.isEmpty ? null : _noteController.text,
          date: _selectedDate,
          userId: userId,
          categoryId: _selectedCategoryId!,
          paymentMethodId: _selectedPaymentMethodId!,
        );
        await _expenseController.updateExpense(expense);
        Get.back(result: true);
        Get.snackbar('success'.tr, 'expense_updated'.tr);
      } else {
        // Add new expense
        final expense = Expense(
          amount: amount,
          note: _noteController.text.isEmpty ? null : _noteController.text,
          date: _selectedDate,
          userId: userId,
          categoryId: _selectedCategoryId!,
          paymentMethodId: _selectedPaymentMethodId!,
        );
        await _expenseController.addExpense(expense);
        Get.back(result: true);
        Get.snackbar('success'.tr, 'expense_saved'.tr);
      }
    } catch (e) {
      Get.snackbar('error'.tr, '${'save_failed'.tr}: $e');
    }
  }
}
