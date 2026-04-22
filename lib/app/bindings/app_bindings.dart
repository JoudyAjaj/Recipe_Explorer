// هذا الملف مسؤول عن حقن Controllers باستخدام GetX عند تشغيل التطبيق.
import 'package:get/get.dart';

import '../../core/network/connectivity_service.dart';
import '../../data/services/favourites_local_service.dart';
import '../../data/services/meal_api_service.dart';
import '../../data/services/search_local_service.dart';
import '../../features/favourites/controllers/favourites_controller.dart';
import '../../features/home/controllers/category_meals_controller.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/meal_detail/controllers/meal_detail_controller.dart';
import '../../features/search/controllers/search_controller.dart';
import '../../features/surprise/controllers/surprise_controller.dart';

class AppBindings {
  //
  static void init() {
    // نسجل الخدمات أولًا حتى تكون جاهزة للـ Controllers.
    Get.put(const MealApiService(), permanent: true);
    Get.put(const FavouritesLocalService(), permanent: true);
    Get.put(const SearchLocalService(), permanent: true);
    Get.put(ConnectivityService(), permanent: true);

    // permanent: true يعني يبقى الـ Controller حيًا طوال عمر التطبيق.
    Get.put(HomeController(), permanent: true);
    Get.put(CategoryMealsController(), permanent: true);
    Get.put(MealDetailController(), permanent: true);
    Get.put(SearchController(), permanent: true);
    Get.put(SurpriseController(), permanent: true);
    Get.put(FavouritesController(), permanent: true);
  }
}
