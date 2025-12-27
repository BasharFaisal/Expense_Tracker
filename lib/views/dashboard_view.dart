import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_drawer.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('Dashboard content')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed('/add-expense'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
