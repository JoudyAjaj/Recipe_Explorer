// Service مسؤول عن جلب/حفظ البيانات بعيدًا عن الواجهة.
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_endpoints.dart';
import '../../core/errors/app_exceptions.dart';
import '../models/category_model.dart';
import '../models/meal_detail_model.dart';
import '../models/meal_summary_model.dart';

class MealApiService {
  const MealApiService();

  // نجلب قائمة تصنيفات TheMealDB من الشبكة.
  Future<List<CategoryModel>> fetchCategories() async {
    final Uri url = Uri.parse(ApiEndpoints.categories);

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode != 200) {
        throw AppException('تعذر جلب التصنيفات الآن. حاول مرة أخرى.');
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> rawCategories =
          data['categories'] as List<dynamic>? ?? <dynamic>[];

      return rawCategories
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .toList();
    } catch (error) {
      if (error is AppException) {
        rethrow;
      }

      throw AppException('حدث خطأ أثناء الاتصال بالخدمة. تأكد من الإنترنت.');
    }
  }

  // نجلب الوجبات ضمن تصنيف محدد من TheMealDB.
  Future<List<MealSummaryModel>> fetchMealsByCategory(
    String categoryName,
  ) async {
    final Uri url = Uri.parse(
      '${ApiEndpoints.filterByCategory}${Uri.encodeQueryComponent(categoryName)}',
    );

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode != 200) {
        throw AppException('تعذر جلب الوجبات لهذا التصنيف. حاول مرة أخرى.');
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> rawMeals =
          data['meals'] as List<dynamic>? ?? <dynamic>[];

      return rawMeals.whereType<Map<String, dynamic>>().map((
        Map<String, dynamic> meal,
      ) {
        return MealSummaryModel(
          id: (meal['idMeal'] ?? '').toString(),
          name: (meal['strMeal'] ?? '').toString(),
          thumb: (meal['strMealThumb'] as String?)?.trim().isEmpty ?? true
              ? null
              : (meal['strMealThumb'] as String).trim(),
        );
      }).toList();
    } catch (error) {
      if (error is AppException) {
        rethrow;
      }

      throw AppException('حدث خطأ أثناء جلب وجبات التصنيف. تأكد من الإنترنت.');
    }
  }

  // نجلب نتائج البحث بالاسم من TheMealDB.
  Future<List<MealSummaryModel>> searchMealsByName(String query) async {
    final Uri url = Uri.parse(
      '${ApiEndpoints.search}${Uri.encodeQueryComponent(query)}',
    );

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode != 200) {
        throw AppException('تعذر تنفيذ البحث الآن. حاول مرة أخرى.');
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> rawMeals = data['meals'] as List<dynamic>? ?? <dynamic>[];

      return rawMeals.whereType<Map<String, dynamic>>().map((
        Map<String, dynamic> meal,
      ) {
        return MealSummaryModel(
          id: (meal['idMeal'] ?? '').toString(),
          name: (meal['strMeal'] ?? '').toString(),
          thumb: (meal['strMealThumb'] as String?)?.trim().isEmpty ?? true
              ? null
              : (meal['strMealThumb'] as String).trim(),
        );
      }).toList();
    } catch (error) {
      if (error is AppException) {
        rethrow;
      }

      throw AppException('حدث خطأ أثناء البحث. تأكد من الإنترنت.');
    }
  }

  // نجلب تفاصيل وجبة واحدة عبر id.
  Future<MealDetailModel> fetchMealDetailById(String mealId) async {
    final Uri url = Uri.parse(
      '${ApiEndpoints.mealById}${Uri.encodeQueryComponent(mealId)}',
    );

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode != 200) {
        throw AppException('تعذر جلب تفاصيل الوجبة الآن. حاول مرة أخرى.');
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> rawMeals =
          data['meals'] as List<dynamic>? ?? <dynamic>[];

      if (rawMeals.isEmpty) {
        throw AppException('لا توجد تفاصيل لهذه الوجبة.');
      }

      final Map<String, dynamic> meal = rawMeals.first as Map<String, dynamic>;

      return MealDetailModel(
        id: (meal['idMeal'] ?? '').toString(),
        name: (meal['strMeal'] ?? '').toString(),
        image: _safeTrim(meal['strMealThumb']),
        category: _safeTrim(meal['strCategory']),
        area: _safeTrim(meal['strArea']),
        instructions: _safeTrim(meal['strInstructions']),
        ingredients: _extractIngredients(meal),
      );
    } catch (error) {
      if (error is AppException) {
        rethrow;
      }

      throw AppException('حدث خطأ أثناء جلب تفاصيل الوجبة. تأكد من الإنترنت.');
    }
  }

  String? _safeTrim(dynamic value) {
    final String text = (value ?? '').toString().trim();
    if (text.isEmpty) {
      return null;
    }
    return text;
  }

  List<String> _extractIngredients(Map<String, dynamic> meal) {
    final List<String> result = <String>[];

    for (int i = 1; i <= 20; i++) {
      final String ingredient = _safeTrim(meal['strIngredient$i']) ?? '';
      final String measure = _safeTrim(meal['strMeasure$i']) ?? '';

      if (ingredient.isEmpty) {
        continue;
      }

      if (measure.isEmpty) {
        result.add(ingredient);
      } else {
        result.add('$ingredient - $measure');
      }
    }

    return result;
  }
}
