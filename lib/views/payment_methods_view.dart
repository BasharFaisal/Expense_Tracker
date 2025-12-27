import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_drawer.dart';
import '../controllers/payment_method_controller.dart';
import '../models/payment_method_model.dart';
import '../services/storage_service.dart';

class PaymentMethodsView extends StatefulWidget {
  const PaymentMethodsView({Key? key}) : super(key: key);

  @override
  State<PaymentMethodsView> createState() => _PaymentMethodsViewState();
}

class _PaymentMethodsViewState extends State<PaymentMethodsView> {
  final PaymentMethodController _paymentMethodController =
      Get.put(PaymentMethodController());
  int _refreshKey = 0;

  @override
  Widget build(BuildContext context) {
    final userId = StorageService.instance.userId ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text('payment_methods'.tr)),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _refreshKey++;
          });
        },
        child: FutureBuilder<List<PaymentMethod>>(
          key: ValueKey(_refreshKey),
          future: _paymentMethodController.getUserPaymentMethods(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('error'.tr));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('no_data'.tr));
            }

            final paymentMethods = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: paymentMethods.length,
              itemBuilder: (context, index) {
                final paymentMethod = paymentMethods[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(paymentMethod.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditPaymentMethodDialog(
                              paymentMethod, userId),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              _showDeleteDialog(paymentMethod, userId),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPaymentMethodDialog(userId),
        child: const Icon(Icons.add),
      ),
    );
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
      final added = await _paymentMethodController.addPaymentMethodFromName(
          result, userId);
      if (added != null) {
        setState(() {
          _refreshKey++;
        });
      }
    }
  }

  Future<void> _showEditPaymentMethodDialog(
      PaymentMethod paymentMethod, int userId) async {
    final nameController = TextEditingController(text: paymentMethod.name);
    final result = await Get.dialog<String>(
      AlertDialog(
        title: Text('edit_payment_method'.tr),
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

    if (result != null && result.isNotEmpty && result != paymentMethod.name) {
      try {
        final updatedPaymentMethod = PaymentMethod(
          id: paymentMethod.id,
          name: result,
          userId: userId,
        );
        await _paymentMethodController
            .updatePaymentMethod(updatedPaymentMethod);
        Get.snackbar('success'.tr, 'payment_method_updated'.tr);
        setState(() {
          _refreshKey++;
        });
      } catch (e) {
        Get.snackbar('error'.tr, '${'save_failed'.tr}: $e');
      }
    }
  }

  Future<void> _showDeleteDialog(
      PaymentMethod paymentMethod, int userId) async {
    if (paymentMethod.id != null) {
      final deleted = await _paymentMethodController
          .deletePaymentMethodWithConfirmation(paymentMethod.id!);
      if (deleted) {
        setState(() {
          _refreshKey++;
        });
      }
    }
  }
}
