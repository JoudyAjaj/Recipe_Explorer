// Controller في GetX: يدير الحالة والمنطق ويحدّث الواجهة.
import 'package:get/get.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../data/models/category_model.dart';
import '../../../data/services/meal_api_service.dart';

class HomeController extends GetxController {
  HomeController({MealApiService? apiService, ConnectivityService? connectivityService})
      : _apiService = apiService ?? Get.find<MealApiService>(),  // نستخدم Get.find لجلب الـ Service المسجل في AppBindings إذا ما تم تمريره مباشرة.
        _connectivityService =
            connectivityService ?? Get.find<ConnectivityService>(); // نفس الشيء للـ ConnectivityService.

  final MealApiService _apiService;
  final ConnectivityService _connectivityService;

  // isLoading: حالة التحميل أثناء طلب البيانات من API.
  final RxBool isLoading = false.obs;

  // errorMessage: نص الخطأ لعرضه في الواجهة عند فشل الطلب.
  final RxString errorMessage = ''.obs;

  // isOnline: نستخدمه لإظهار تنبيه الشبكة في الواجهة.
  final RxBool isOnline = true.obs;

  // categories: قائمة التصنيفات القادمة من TheMealDB.
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  // selectedCategory: التصنيف الحالي المختار من المستخدم.
  final RxString selectedCategory = ''.obs;

  // selectedMealId: رقم الوجبة الحالي المختار.
  final RxString selectedMealId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // أول ما يجهز الـ Controller نبدأ جلب التصنيفات.
    loadCategories();
  }

  // هذه الدالة تستدعي الـ API وتحدّث الحالة بشكل reactive.
  Future<void> loadCategories() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      isOnline.value = await _connectivityService.isOnline();

      if (!isOnline.value) {
        throw AppException('أنت غير متصل بالإنترنت. أعد المحاولة عند توفر الشبكة.');
      }

      final List<CategoryModel> items = await _apiService.fetchCategories();
      categories.assignAll(items);
    } on AppException catch (error) {
      errorMessage.value = error.message;
      categories.clear();
    } catch (_) {
      errorMessage.value = 'حدث خطأ غير متوقع أثناء تحميل التصنيفات.';
      categories.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // نعيد استخدام نفس منطق التحميل عند الضغط على زر Retry.
  Future<void> retryLoadCategories() => loadCategories();
}
