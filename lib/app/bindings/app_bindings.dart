import 'package:get/get.dart';

import '../../features/favourites/controllers/favourites_controller.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../features/search/controllers/search_controller.dart';
import '../../features/surprise/controllers/surprise_controller.dart';

class AppBindings {
  static void init() {
    // permanent: true يعني يبقى الـ Controller حيًا طوال عمر التطبيق.
    Get.put(HomeController(), permanent: true);
    Get.put(SearchController(), permanent: true);
    Get.put(SurpriseController(), permanent: true);
    Get.put(FavouritesController(), permanent: true);
  }
}
