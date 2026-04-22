// Controller في GetX: يدير الحالة والمنطق ويحدّث الواجهة.
import 'package:get/get.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../data/models/meal_detail_model.dart';
import '../../../data/services/meal_api_service.dart'; // هذا ال Controller مسؤول عن إدارة حالة شاشة تفاصيل الوجبة، بما في ذلك جلب بيانات الوجبة من API، التعامل مع حالات التحميل والأخطاء، وتوفير بيانات الوجبة للواجهة لعرضها.

class MealDetailController extends GetxController {
  MealDetailController({
    MealApiService? apiService,
    ConnectivityService? connectivityService,
  }) : _apiService = apiService ?? Get.find<MealApiService>(),
       _connectivityService =
           connectivityService ?? Get.find<ConnectivityService>();

  final MealApiService _apiService;
  final ConnectivityService _connectivityService;

  final RxBool isLoading = false.obs;
  final RxString mealId = ''.obs;
  final RxString errorMessage = ''.obs;
  final Rxn<MealDetailModel> meal = Rxn<MealDetailModel>();

  Future<void> loadMealDetail(String id) async {
    final String sanitizedId = id.trim();
    if (sanitizedId.isEmpty) {
      errorMessage.value = 'معرف الوجبة غير صالح.';
      meal.value = null;
      return;
    }

    mealId.value = sanitizedId;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final bool isOnline = await _connectivityService.isOnline();
      if (!isOnline) {
        throw AppException(
          'أنت غير متصل بالإنترنت. أعد المحاولة عند توفر الشبكة.',
        );
      }

      final MealDetailModel result = await _apiService.fetchMealDetailById(
        sanitizedId,
      );
      meal.value = result;
    } on AppException catch (error) {
      meal.value = null;
      errorMessage.value = error.message;
    } catch (_) {
      meal.value = null;
      errorMessage.value = 'حدث خطأ غير متوقع أثناء تحميل تفاصيل الوجبة.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retry() async {
    if (mealId.value.isNotEmpty) {
      await loadMealDetail(mealId.value);
    }
  }
}
