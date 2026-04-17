// View تمثل واجهة المستخدم المرتبطة مباشرة بالـ Controller.
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart'; //ال HomeController يدير الحالة والمنطق لهذه الواجهة.

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    this.initialCategoryName,
    this.initialMealId,
  }); // نأخذ هذه المتغيرات من route parameters لتحديث الحالة عند الدخول من روابط مباشرة.  اي استقبال القيم التي تأتي من الراوت

  final String?
  initialCategoryName; // هذا المتغير سيحتوي على اسم الفئة إذا دخلنا من رابط مباشر يحتوي على categoryName، أو null إذا لم يكن موجودًا.

  final String?
  initialMealId; // هذا المتغير سيحتوي على معرف الوجبة إذا دخلنا من رابط مباشر يحتوي على mealId، أو null إذا لم يكن موجودًا.

  @override
  Widget build(BuildContext context) {
    // نأخذ نفس HomeController المسجل في AppBindings.
    final HomeController controller =
        Get.find<HomeController>(); //Get.find() → بتجيب نسخة من HomeController

    // إذا دخلنا من route فيه categoryName نحدّث الحالة.
    if (initialCategoryName != null && initialCategoryName!.isNotEmpty) {
      // نتأكد أن القيمة ليست null وأيضًا ليست فارغة قبل التحديث.
      controller.selectedCategory.value =
          initialCategoryName!; // نستخدم ! لأننا تأكدنا من أنها ليست null في الشرط السابق.
    }

    // إذا دخلنا من route فيه mealId نحدّث الحالة.
    if (initialMealId != null && initialMealId!.isNotEmpty) {
      controller.selectedMealId.value =
          initialMealId!; ////value → لأن المتغير من نوع Rx (Reactive) ويجب تحديثه بهذه الطريقة ليتم إعلام Obx بالتغيير وإعادة بناء الواجهة.
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Recipe Explorer')),
      body: Center(
        child: Obx(
          //
          //هاي قلب GetX
          // شو بتعمل؟
          // تراقب أي متغير Rx
          // أول ما يتغير → تعيد بناء الواجهة تلقائياً

          // Obx يعيد بناء Text تلقائيًا عند تغير أي Rx مستخدم داخله.
          () => Text(
            //شو يعني () => ؟
            //هاي دالة قصيرة (arrow function)
            controller.selectedCategory.value.isNotEmpty
                ? 'Category: ${controller.selectedCategory.value}'
                : controller.selectedMealId.value.isNotEmpty
                ? 'Meal: ${controller.selectedMealId.value}'
                : 'Home tab ready',
          ),

          //الكود ببساطة:
          // 👉 إذا في Category → اعرضها
          // 👉 إذا ما في، بس في Meal → اعرضه
          // 👉 إذا ولا شي → اعرض رسالة افتراضية
        ),
      ),
    );
  }
}
