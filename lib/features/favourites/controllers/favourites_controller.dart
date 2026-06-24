// Controller في GetX: يدير الحالة والمنطق ويحدّث الواجهة.
import 'package:get/get.dart';

import '../../../data/models/meal_summary_model.dart';
import '../../../data/services/favourites_local_service.dart';

class FavouritesController extends GetxController {
  FavouritesController({FavouritesLocalService? localService})
    : _localService = localService ?? Get.find<FavouritesLocalService>();

  final FavouritesLocalService _localService;

    final RxBool isLoading = false.obs;
    final RxList<MealSummaryModel> favouriteMeals = <MealSummaryModel>[].obs;

    List<String> get favouriteMealIds =>
      favouriteMeals.map((MealSummaryModel meal) => meal.id).toList();

  @override
  void onInit() {
    super.onInit();
    loadFavourites();
  }

  Future<void> loadFavourites() async {
    isLoading.value = true;
    try {
      final List<MealSummaryModel> meals = await _localService
          .loadFavouriteMeals();
      favouriteMeals.assignAll(meals);
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavourite(String mealId) {
    return favouriteMeals.any((MealSummaryModel meal) => meal.id == mealId);
  }

  Future<void> toggleFavouriteMeal(MealSummaryModel meal) async {
    final String mealId = meal.id.trim();
    if (mealId.isEmpty) {
      return;
    }

    final int existingIndex = favouriteMeals.indexWhere(
      (MealSummaryModel item) => item.id == mealId,
    );

    if (existingIndex >= 0) {
      favouriteMeals.removeAt(existingIndex);
    } else {
      favouriteMeals.add(meal);
    }

    await _localService.saveFavouriteMeals(favouriteMeals.toList());
  }

  Future<void> removeFavourite(String mealId) async {
    favouriteMeals.removeWhere((MealSummaryModel meal) => meal.id == mealId);
    await _localService.saveFavouriteMeals(favouriteMeals.toList());
  }
}
