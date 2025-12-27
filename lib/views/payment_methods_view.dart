import 'package:flutter/material.dart';

import 'app_drawer.dart';

class PaymentMethodsView extends StatelessWidget {
  const PaymentMethodsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment Methods')),
      drawer: const AppDrawer(),
      body: const Center(child: Text('Payment methods list')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
