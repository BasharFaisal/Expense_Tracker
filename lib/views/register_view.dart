import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../models/user_model.dart';
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
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name')),
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true),
            const SizedBox(height: 16),
            ElevatedButton(
                onPressed: () async {
                  final name = _nameController.text.trim();
                  final email = _emailController.text.trim();
                  final password = _passwordController.text;

                  if (name.isEmpty || email.isEmpty || password.isEmpty) {
                    Get.snackbar('Error', 'Please fill all fields');
                    return;
                  }

                  final auth = Get.put(AuthController());
                  final user = User(
                      name: name,
                      email: email,
                      password: password,
                      role: 'User');
                  try {
                    await auth.registerUser(user);
                    Get.snackbar('Success', 'Account created');
                    Get.offAllNamed(AppRoutes.login);
                  } catch (e) {
                    Get.snackbar('Error', e.toString());
                  }
                },
                child: const Text('Register')),
          ],
        ),
      ),
    );
  }
}
