// هذا الملف مسؤول عن حقن Controllers باستخدام GetX عند تشغيل التطبيق.
import 'package:get/get.dart';

import '../../features/favourites/controllers/favourites_controller.dart';
import '../../features/home/controllers/category_meals_controller.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/meal_detail/controllers/meal_detail_controller.dart';
import '../../features/search/controllers/search_controller.dart';
import '../../features/surprise/controllers/surprise_controller.dart';

class AppBindings {
  static void init() {
    // permanent: true يعني يبقى الـ Controller حيًا طوال عمر التطبيق.
    Get.put(HomeController(), permanent: true);
    Get.put(CategoryMealsController(), permanent: true);
    Get.put(MealDetailController(), permanent: true);
    Get.put(SearchController(), permanent: true);
    Get.put(SurpriseController(), permanent: true);
    Get.put(FavouritesController(), permanent: true);
  }
}
