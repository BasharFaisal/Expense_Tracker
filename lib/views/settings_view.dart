import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController ctrl = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Theme',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Obx(() => SwitchListTile(
                  title: Text(ctrl.isDark.value ? 'Dark' : 'Light'),
                  value: ctrl.isDark.value,
                  onChanged: (v) => ctrl.setTheme(v),
                )),
            const SizedBox(height: 24),
            const Text('Language',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Obx(() => DropdownButton<String>(
                  value: ctrl.language.value,
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                    DropdownMenuItem(value: 'ar', child: Text('العربية')),
                  ],
                  onChanged: (v) {
                    if (v != null) ctrl.setLanguage(v);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
