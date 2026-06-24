// Controller في GetX: يدير الحالة والمنطق ويحدّث الواجهة.
import 'package:get/get.dart';

import '../../../core/errors/app_exceptions.dart';
import '../../../core/utils/debounce.dart';
import '../../../data/models/meal_summary_model.dart';
import '../../../data/services/meal_api_service.dart';
import '../../../data/services/search_local_service.dart';

class SearchController extends GetxController {
  SearchController({
    MealApiService? apiService,
    SearchLocalService? localService,
  }) : _apiService = apiService ?? Get.find<MealApiService>(),
       _localService = localService ?? Get.find<SearchLocalService>();

  static const int minQueryLength = 2;

  final MealApiService _apiService;
  final SearchLocalService _localService;
  final Debouncer _debouncer = Debouncer(
    delay: const Duration(milliseconds: 400),
  );

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString query = ''.obs;
  final RxList<MealSummaryModel> results = <MealSummaryModel>[].obs;

  bool get hasEnoughCharacters => query.value.trim().length >= minQueryLength;

  @override
  void onInit() {
    super.onInit();
    _restoreLastSearch();
  }

  Future<void> _restoreLastSearch() async {
    final String lastQuery = await _localService.loadLastQuery();
    final List<MealSummaryModel> lastResults = await _localService
        .loadLastResults();

    query.value = lastQuery;
    results.assignAll(lastResults);
  }

  void onQueryChanged(String value) {
    query.value = value;
    errorMessage.value = '';

    final String trimmedValue = value.trim();

    if (trimmedValue.isEmpty) {
      isLoading.value = false;
      return;
    }

    if (!hasEnoughCharacters) {
      isLoading.value = false;
      results.clear();
      return;
    }

    _debouncer(() {
      searchNow(value);
    });
  }

  Future<void> searchNow(String rawQuery) async {
    final String trimmedQuery = rawQuery.trim();

    if (trimmedQuery.length < minQueryLength) {
      // هذا تحقق إضافي للتأكد من أن البحث لا يتم إذا كان عدد الأحرف أقل من الحد الأدنى، حتى لو تم تجاوز الـ Debouncer.
      isLoading.value = false;
      errorMessage.value = '';
      results.clear();
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final List<MealSummaryModel> items = await _apiService.searchMealsByName(
        trimmedQuery,
      );
      results.assignAll(items);
      await _localService.saveLastSearch(query: trimmedQuery, results: items);
    } on AppException catch (error) {
      errorMessage.value = error.message;
      results.clear();
    } catch (_) {
      errorMessage.value = 'An unexpected error occurred while searching.';
      results.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> retry() async {
    await searchNow(query.value);
  }

  void clearQuery() {
    // هذا يستخدم عندما يضغط المستخدم على زر مسح النص في حقل البحث، لإعادة تعيين كل الحالات إلى الوضع الافتراضي.
    query.value = ''; // إعادة تعيين الاستعلام إلى نص فارغ.
    errorMessage.value = ''; // مسح أي رسالة خطأ موجودة.
    isLoading.value = false; // إيقاف حالة التحميل إذا كانت نشطة.
    // نترك النتائج كما هي لعرض آخر نتائج محفوظة عند رجوع المستخدم لشاشة البحث.
  }

  @override
  void onClose() {
    _debouncer.dispose();
    super.onClose();
  }
}
