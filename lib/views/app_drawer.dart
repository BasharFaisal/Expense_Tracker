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
              accountName: Text(
                userId != null
                    ? (StorageService.instance.username ?? 'guest'.tr)
                    : 'guest'.tr,
              ),
              accountEmail: const Text(''),
              currentAccountPicture:
                  const CircleAvatar(child: Icon(Icons.person)),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: Text('dashboard'.tr),
              onTap: () {
                Navigator.of(context).pop();
                Get.offAllNamed(AppRoutes.dashboard);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: Text('add_expense'.tr),
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.addExpense);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: Text('categories'.tr),
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.categories);
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: Text('payment_methods'.tr),
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.paymentMethods);
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text('settings'.tr),
              onTap: () {
                Navigator.of(context).pop();
                Get.toNamed(AppRoutes.settings);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text('logout'.tr),
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
