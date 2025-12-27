// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simple splash that navigates after a short delay could be added later
    return Scaffold(
      body: const Center(
        child: Text('Splash'),
      ),
    );
  }
}
