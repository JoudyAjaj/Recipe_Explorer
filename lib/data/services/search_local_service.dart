// Service مسؤول عن حفظ/استرجاع آخر حالة بحث محليًا.
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal_summary_model.dart';

class SearchLocalService {
  const SearchLocalService();

  static const String _lastQueryKey = 'search_last_query';
  static const String _lastResultsKey = 'search_last_results';

  Future<String> loadLastQuery() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(_lastQueryKey) ?? '';
  }

  Future<List<MealSummaryModel>> loadLastResults() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<String> rawResults =
        preferences.getStringList(_lastResultsKey) ?? <String>[];

    return rawResults
        .map((String item) {
          try {
            return MealSummaryModel.fromJson(
              jsonDecode(item) as Map<String, dynamic>,
            );
          } catch (_) {
            return null;
          }
        })
        .whereType<MealSummaryModel>()
        .where((MealSummaryModel meal) => meal.id.trim().isNotEmpty)
        .toList();
  }

  Future<void> saveLastSearch({
    required String query,
    required List<MealSummaryModel> results,
  }) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<String> encodedResults = results
        .map((MealSummaryModel meal) => jsonEncode(meal.toJson()))
        .toList();

    await preferences.setString(_lastQueryKey, query);
    await preferences.setStringList(_lastResultsKey, encodedResults);
  }

  Future<void> clearLastSearch() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(_lastQueryKey);
    await preferences.remove(_lastResultsKey);
  }
}