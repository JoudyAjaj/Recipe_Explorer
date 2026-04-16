import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, this.initialCategoryName, this.initialMealId});

  final String? initialCategoryName;
  final String? initialMealId;

  @override
  Widget build(BuildContext context) {
    // نأخذ نفس HomeController المسجل في AppBindings.
    final HomeController controller = Get.find<HomeController>();

    // إذا دخلنا من route فيه categoryName نحدّث الحالة.
    if (initialCategoryName != null && initialCategoryName!.isNotEmpty) {
      controller.selectedCategory.value = initialCategoryName!;
    }

    // إذا دخلنا من route فيه mealId نحدّث الحالة.
    if (initialMealId != null && initialMealId!.isNotEmpty) {
      controller.selectedMealId.value = initialMealId!;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Explorer')),
      body: Center(
        child: Obx(
          // Obx يعيد بناء Text تلقائيًا عند تغير أي Rx مستخدم داخله.
          () => Text(
            controller.selectedCategory.value.isNotEmpty
                ? 'Category: ${controller.selectedCategory.value}'
                : controller.selectedMealId.value.isNotEmpty
                    ? 'Meal: ${controller.selectedMealId.value}'
                    : 'Home tab ready',
          ),
        ),
      ),
    );
  }
}
