import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('login'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                final user = await auth.loginWithValidation(
                  _emailController.text,
                  _passwordController.text,
                );
                if (user != null) {
                  Get.offAllNamed(AppRoutes.dashboard);
                }
              },
              child: Text('login'.tr),
            ),
            TextButton(
              onPressed: () => Get.toNamed('/register'),
              child: Text('register'.tr),
            ),
          ],
        ),
      ),
    );
  }
}
