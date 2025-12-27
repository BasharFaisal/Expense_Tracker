import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  RegisterViewState createState() => RegisterViewState();
}

class RegisterViewState extends State<RegisterView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('register'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'name'.tr)),
            TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'email'.tr)),
            TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'password'.tr),
                obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () async {
                  final auth = Get.put(AuthController());
                  final success = await auth.registerWithValidation(
                    _nameController.text,
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (success) {
                    Get.offAllNamed(AppRoutes.login);
                  }
                },
                child: Text('register'.tr)),
          ],
        ),
      ),
    );
  }
}
