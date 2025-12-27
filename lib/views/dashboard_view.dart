import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_drawer.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('dashboard'.tr)),
      drawer: const AppDrawer(),
      body: Center(child: Text('dashboard_content'.tr)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-expense'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
