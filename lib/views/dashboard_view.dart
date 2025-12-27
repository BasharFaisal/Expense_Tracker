import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'app_drawer.dart';
import '../controllers/dashboard_controller.dart';
import '../controllers/expense_controller.dart';
import '../controllers/category_controller.dart';
import '../models/category_model.dart';
import '../services/storage_service.dart';
import '../routes/app_routes.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardCtrl = Get.put(DashboardController());
    final ExpenseController expenseCtrl = Get.find<ExpenseController>();
    final CategoryController categoryCtrl = Get.put(CategoryController());

    return Scaffold(
      appBar: AppBar(
        title: Text('dashboard'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => dashboardCtrl.refresh(),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => dashboardCtrl.refresh(),
        child: Obx(() {
          if (dashboardCtrl.expenses.isEmpty) {
            return Center(child: Text('no_expenses'.tr));
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Totals Section
                _buildTotalsSection(dashboardCtrl, categoryCtrl),
                const SizedBox(height: 24),
                // Expenses List
                Text(
                  'total'.tr,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildExpensesList(dashboardCtrl, expenseCtrl),
              ],
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Get.toNamed(AppRoutes.addExpense);
          if (result == true) {
            dashboardCtrl.refresh();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTotalsSection(
      DashboardController dashboardCtrl, CategoryController categoryCtrl) {
    final userId = StorageService.instance.userId ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'total'.tr,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildTotalRow(
                    'daily_total'.tr, dashboardCtrl.dailyTotal.value),
                const Divider(),
                _buildTotalRow(
                    'monthly_total'.tr, dashboardCtrl.monthlyTotal.value),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'total_by_category'.tr,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Obx(() {
          if (dashboardCtrl.totalsByCategory.isEmpty) {
            return Text('no_data'.tr);
          }
          return FutureBuilder<List<Category>>(
            future: categoryCtrl.getUserCategories(userId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CircularProgressIndicator();
              }
              final categories = snapshot.data ?? [];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children:
                        dashboardCtrl.totalsByCategory.entries.map((entry) {
                      try {
                        final category = categories.firstWhere(
                          (cat) => cat.id == entry.key,
                        );
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(category.name),
                              Text(
                                NumberFormat.currency(symbol: '')
                                    .format(entry.value),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      } catch (e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Category #${entry.key}'),
                              Text(
                                NumberFormat.currency(symbol: '')
                                    .format(entry.value),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }
                    }).toList(),
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildTotalRow(String label, double value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          NumberFormat.currency(symbol: '').format(value),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildExpensesList(
      DashboardController dashboardCtrl, ExpenseController expenseCtrl) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dashboardCtrl.expenses.length,
      itemBuilder: (context, index) {
        final expense = dashboardCtrl.expenses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            title: Text(
              NumberFormat.currency(symbol: '').format(expense.amount),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (expense.note != null && expense.note!.isNotEmpty)
                  Text(expense.note!),
                Text(
                  DateFormat('yyyy-MM-dd').format(expense.date),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    final result = await Get.toNamed(
                      AppRoutes.addExpense,
                      arguments: expense,
                    );
                    if (result == true) {
                      dashboardCtrl.refresh();
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
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
                      await expenseCtrl.deleteExpense(expense.id!);
                      Get.snackbar('success'.tr, 'expense_deleted'.tr);
                      dashboardCtrl.refresh();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
