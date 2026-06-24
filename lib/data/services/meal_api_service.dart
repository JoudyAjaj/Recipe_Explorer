// Service responsible for fetching and storing data away from the UI.
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants/api_endpoints.dart';
import '../../core/errors/app_exceptions.dart';
import '../models/category_model.dart';
import '../models/meal_detail_model.dart';
import '../models/meal_summary_model.dart';

class MealApiService {
  const MealApiService();

  // Fetch categories from TheMealDB.
  Future<List<CategoryModel>> fetchCategories() async {
    final Uri url = Uri.parse(ApiEndpoints.categories);

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode != 200) {
        throw AppException('Could not load categories right now. Try again.');
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

      throw AppException('A network error occurred. Check your internet connection.');
    }
  }

  // Fetch meals for a specific category from TheMealDB.
  Future<List<MealSummaryModel>> fetchMealsByCategory(
    String categoryName,
  ) async {
    final Uri url = Uri.parse(
      '${ApiEndpoints.filterByCategory}${Uri.encodeQueryComponent(categoryName)}',
    );

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode != 200) {
        throw AppException('Could not load meals for this category. Try again.');
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

      throw AppException('A network error occurred while loading category meals. Check your internet connection.');
    }
  }

  // Fetch search results by name from TheMealDB.
  Future<List<MealSummaryModel>> searchMealsByName(String query) async {
    final Uri url = Uri.parse(
      '${ApiEndpoints.search}${Uri.encodeQueryComponent(query)}',
    );

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode != 200) {
        throw AppException('Could not perform the search right now. Try again.');
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

      throw AppException('A network error occurred while searching. Check your internet connection.');
    }
  }

  // Fetch a single meal by id.
  Future<MealDetailModel> fetchMealDetailById(String mealId) async {
    final Uri url = Uri.parse(
      '${ApiEndpoints.mealById}${Uri.encodeQueryComponent(mealId)}',
    );

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode != 200) {
        throw AppException('Could not load meal details right now. Try again.');
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> rawMeals =
          data['meals'] as List<dynamic>? ?? <dynamic>[];

      if (rawMeals.isEmpty) {
        throw AppException('No details were found for this meal.');
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

      throw AppException('A network error occurred while loading meal details. Check your internet connection.');
    }
  }

  // Fetch a random meal from TheMealDB.
  Future<MealDetailModel> fetchRandomMeal() async {
    final Uri url = Uri.parse(ApiEndpoints.random);

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode != 200) {
        throw AppException('Could not load a surprise meal right now. Try again.');
      }

      final Map<String, dynamic> data =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> rawMeals =
          data['meals'] as List<dynamic>? ?? <dynamic>[];

      if (rawMeals.isEmpty) {
        throw AppException('No surprise meal was returned. Please try again.');
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

      throw AppException('A network error occurred while loading a surprise meal. Check your internet connection.');
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
