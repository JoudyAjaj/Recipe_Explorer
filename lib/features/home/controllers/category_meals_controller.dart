// Controller في GetX: يدير الحالة والمنطق ويحدّث الواجهة.
import 'package:get/get.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../data/models/meal_summary_model.dart'; // استيراد موديل ملخص الوجبة لاستخدامه في قائمة الوجبات ضمن التصنيف.
import '../../../data/services/meal_api_service.dart'; // استيراد خدمة API لجلب بيانات الوجبات من الشبكة.

class CategoryMealsController extends GetxController { // هذا الكنترولر مسؤول عن إدارة حالة وجبات تصنيف معين.
  CategoryMealsController({MealApiService? apiService, ConnectivityService? connectivityService})
      : _apiService = apiService ?? Get.find<MealApiService>(), // نستخدم خدمة API من GetX إذا لم يتم تمريرها، مما يسهل اختبار الكنترولر بوحدات اختبارية.
        _connectivityService = connectivityService ?? Get.find<ConnectivityService>();// نفس الشيء لخدمة الاتصال بالشبكة.

  final MealApiService _apiService;
  final ConnectivityService _connectivityService;

  final RxBool isLoading = false.obs; // حالة التحميل أثناء جلب البيانات من API.
  final RxString errorMessage = ''.obs; // رسالة الخطأ في حال فشل جلب البيانات (مبدئيًا فارغة).
  final RxList<MealSummaryModel> meals = <MealSummaryModel>[].obs; // قائمة الوجبات ضمن التصنيف باستخدام الموديل الجاهز للبطاقات.
  final RxString currentCategoryName = ''.obs;

  Future<void> loadMealsByCategory(String categoryName) async {
    currentCategoryName.value = categoryName;
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final bool online = await _connectivityService.isOnline();
      if (!online) {
        throw AppException('أنت غير متصل بالإنترنت. أعد المحاولة عند توفر الشبكة.');
      }

      final List<MealSummaryModel> items =
          await _apiService.fetchMealsByCategory(categoryName);
      meals.assignAll(items);
    } on AppException catch (error) {
      errorMessage.value = error.message;
      meals.clear();
    } catch (_) {
      errorMessage.value = 'حدث خطأ غير متوقع أثناء تحميل وجبات التصنيف.';
      meals.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retry() async {
    if (currentCategoryName.value.isEmpty) {
      return;
    }

    await loadMealsByCategory(currentCategoryName.value);
  }
}