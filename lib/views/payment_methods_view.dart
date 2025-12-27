import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_drawer.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('payment_methods'.tr)),
      drawer: const AppDrawer(),
      body: Center(child: Text('payment_methods_list'.tr)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
