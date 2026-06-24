// Service مسؤول عن جلب/حفظ البيانات بعيدًا عن الواجهة.
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal_summary_model.dart';

class FavouritesLocalService {
  const FavouritesLocalService();

  static const String _favouriteMealIdsKey = 'favourite_meal_ids';
  static const String _favouriteMealsKey = 'favourite_meals';

  Future<List<String>> loadFavouriteMealIds() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getStringList(_favouriteMealIdsKey) ?? <String>[];
  }

  Future<void> saveFavouriteMealIds(List<String> ids) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(_favouriteMealIdsKey, ids);
  }

  Future<List<MealSummaryModel>> loadFavouriteMeals() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<String> rawMeals =
        preferences.getStringList(_favouriteMealsKey) ?? <String>[];

    final List<MealSummaryModel> parsedMeals = rawMeals
        .map((String rawItem) {
          try {
            final Map<String, dynamic> json =
                jsonDecode(rawItem) as Map<String, dynamic>;
            return MealSummaryModel.fromJson(json);
          } catch (_) {
            return null;
          }
        })
        .whereType<MealSummaryModel>()// بتصفية أي عناصر غير صالحة (null) بعد محاولة التحويل من JSON إلى كائن MealSummaryModel.
        .where((MealSummaryModel meal) => meal.id.trim().isNotEmpty)// بتصفية أي وجبات تحتوي على معرف فارغ أو فقط مسافات.
        .toList();// بتحول كل عنصر صالح إلى كائن MealSummaryModel وتجمعهم في قائمة.

    if (parsedMeals.isNotEmpty) { //إذا كانت هناك وجبات صالحة تم تحميلها من SharedPreferences، يتم إرجاعها مباشرة. هذا يعني أن التطبيق سيستخدم البيانات الجديدة المخزنة بشكل كامل (ID، الاسم، الصورة) بدلاً من الاعتماد فقط على IDs القديمة.
      return parsedMeals;
    }

    // fallback للبيانات القديمة التي كانت تحفظ IDs فقط.
    final List<String> ids = await loadFavouriteMealIds();
    return ids
        .where((String id) => id.trim().isNotEmpty)// بتصفية أي معرفات فارغة أو تحتوي فقط على مسافات.
        .map((String id) => MealSummaryModel(id: id, name: 'Meal #$id'))// بتحويل كل معرف صالح إلى كائن MealSummaryModel بسيط يحتوي فقط على ID واسم افتراضي (مثل "Meal #123"). هذا يسمح للتطبيق بالاستمرار في العمل مع البيانات القديمة حتى يتم تحديثها بالبيانات الجديدة.
        .toList();
  }

  Future<void> saveFavouriteMeals(List<MealSummaryModel> meals) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<String> encodedMeals = meals
        .map((MealSummaryModel meal) => jsonEncode(meal.toJson()))
        .toList();

    await preferences.setStringList(_favouriteMealsKey, encodedMeals);
    await saveFavouriteMealIds(
      meals.map((MealSummaryModel meal) => meal.id).toList(),
    );
  }
}
