// ثوابت مركزية يستخدمها التطبيق (مثل روابط API).
class ApiEndpoints {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  static const String categories = '$baseUrl/categories.php';
  static const String filterByCategory = '$baseUrl/filter.php?c=';
  static const String mealById = '$baseUrl/lookup.php?i=';
  static const String search = '$baseUrl/search.php?s=';
  static const String random = '$baseUrl/random.php';

  const ApiEndpoints._();
}