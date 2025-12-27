import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import 'app_drawer.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SettingsController ctrl = Get.find();

    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('theme'.tr,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Obx(() => SwitchListTile(
                  title: Text(ctrl.isDark.value ? 'dark'.tr : 'light'.tr),
                  value: ctrl.isDark.value,
                  onChanged: (v) => ctrl.setTheme(v),
                )),
            const SizedBox(height: 24),
            Text('language'.tr,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Obx(() => DropdownButton<String>(
                  value: ctrl.language.value,
                  items: [
                    DropdownMenuItem(value: 'en', child: Text('english'.tr)),
                    DropdownMenuItem(value: 'ar', child: Text('arabic'.tr)),
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
