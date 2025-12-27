import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_drawer.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('categories'.tr)),
      drawer: const AppDrawer(),
      body: Center(child: Text('categories_list'.tr)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
