import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_drawer.dart';
import '../controllers/category_controller.dart';
import '../models/category_model.dart';
import '../services/storage_service.dart';

class CategoriesView extends StatefulWidget {
  const CategoriesView({Key? key}) : super(key: key);

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  final CategoryController _categoryController = Get.put(CategoryController());
  int _refreshKey = 0;

  @override
  Widget build(BuildContext context) {
    final userId = StorageService.instance.userId ?? 0;

    return Scaffold(
      appBar: AppBar(title: Text('categories'.tr)),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _refreshKey++;
          });
        },
        child: FutureBuilder<List<Category>>(
          key: ValueKey(_refreshKey),
          future: _categoryController.getUserCategories(userId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('error'.tr));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('no_data'.tr));
            }

            final categories = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    title: Text(category.name),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () =>
                              _showEditCategoryDialog(category, userId),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _showDeleteDialog(category, userId),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCategoryDialog(userId),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddCategoryDialog(int userId) async {
    final nameController = TextEditingController();
    final result = await Get.dialog<String>(
      AlertDialog(
        title: Text('add_category'.tr),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'category_name'.tr),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Get.back(result: nameController.text.trim());
              }
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        final category = Category(
          name: result,
          userId: userId,
        );
        await _categoryController.addCategory(category);
        Get.snackbar('success'.tr, 'category_added'.tr);
        setState(() {
          _refreshKey++;
        });
      } catch (e) {
        Get.snackbar('error'.tr, '${'save_failed'.tr}: $e');
      }
    }
  }

  Future<void> _showEditCategoryDialog(Category category, int userId) async {
    final nameController = TextEditingController(text: category.name);
    final result = await Get.dialog<String>(
      AlertDialog(
        title: Text('edit_category'.tr),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(labelText: 'category_name'.tr),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Get.back(result: nameController.text.trim());
              }
            },
            child: Text('save'.tr),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty && result != category.name) {
      try {
        final updatedCategory = Category(
          id: category.id,
          name: result,
          userId: userId,
          icon: category.icon,
        );
        await _categoryController.updateCategory(updatedCategory);
        Get.snackbar('success'.tr, 'category_updated'.tr);
        setState(() {
          _refreshKey++;
        });
      } catch (e) {
        Get.snackbar('error'.tr, '${'save_failed'.tr}: $e');
      }
    }
  }

  Future<void> _showDeleteDialog(Category category, int userId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('delete'.tr),
        content: Text('are_you_sure'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );

    if (confirmed == true && category.id != null) {
      try {
        await _categoryController.deleteCategory(category.id!);
        Get.snackbar('success'.tr, 'category_deleted'.tr);
        setState(() {
          _refreshKey++;
        });
      } catch (e) {
        Get.snackbar('error'.tr, '${'save_failed'.tr}: $e');
      }
    }
  }
}
