import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../services/storage_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = StorageService.instance.userId;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userId != null ? 'User #$userId' : 'Guest'),
              accountEmail: const Text(''),
              currentAccountPicture:
                  const CircleAvatar(child: Icon(Icons.person)),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.of(context).pop();
                Get.offAllNamed(AppRoutes.dashboard);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Expense'),
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.addExpense);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categories'),
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.categories);
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: const Text('Payment Methods'),
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.paymentMethods);
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.settings);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.of(context).pop();
                await StorageService.instance.clearSession();
                Get.offAllNamed(AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
