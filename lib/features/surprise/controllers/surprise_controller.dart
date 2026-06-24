// Controller في GetX: يدير الحالة والمنطق ويحدّث الواجهة.
import 'package:get/get.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../../data/models/meal_detail_model.dart';
import '../../../data/services/meal_api_service.dart';

class SurpriseController extends GetxController {
  SurpriseController({
    MealApiService? apiService,
  }) // نستخدم خدمة API من GetX إذا لم يتم تمريرها، مما يسهل اختبار الكنترولر بوحدات اختبارية.
  : _apiService = apiService ?? Get.find<MealApiService>();

  final MealApiService
  _apiService; // خدمة API لجلب بيانات الوجبة العشوائية من الشبكة.

  final RxBool isLoading = false.obs; // حالة التحميل أثناء جلب البيانات من API.
  final RxString errorMessage =
      ''.obs; // رسالة الخطأ في حال فشل جلب البيانات (مبدئيًا فارغة).
  final Rxn<MealDetailModel> randomMeal =
      Rxn<
        MealDetailModel
      >(); // الوجبة العشوائية التي تم جلبها، باستخدام Rxn للسماح بأن تكون null في حالة الخطأ أو عدم وجود بيانات.
  //       شو يعني Rxn؟

  // يعني القيمة ممكن تكون null
  // مفيد إذا:
  // ما في بيانات
  // أو صار خطأ
  @override
  void onInit() {
    super.onInit();
    loadRandomMeal();
  }

  Future<void> loadRandomMeal() async {
    if (isLoading.value) {
      return;
    }

    isLoading.value =
        true; // نبدأ عملية التحميل ونضع حالة isLoading على true لعرض مؤشر التحميل في الواجهة.
    errorMessage.value = ''; // نعيد تعيين رسالة الخطأ إلى فارغة في بداية
    // errorMessage.value = '';

    try {
      final MealDetailModel meal = await _apiService.fetchRandomMeal();
      randomMeal.value = meal;
    } on AppException catch (error) {
      randomMeal.value = null;
      errorMessage.value = error.message;
    } catch (_) {
      randomMeal.value = null;
      errorMessage.value =
          'An unexpected error occurred while loading the surprise meal.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retry() async {
    await loadRandomMeal();
  }
}
