// Model يمثل شكل البيانات القادمة من API أو المخزنة محليًا.
class MealDetailModel {
  const MealDetailModel({
    required this.id, // معرف الوجبة (مثل "52772").
    required this.name, // اسم الوجبة (مثل "Spaghetti Carbonara").
    this.image, // رابط الصورة الكبيرة للوجبة (قد يكون null إذا لم يتوفر).
    this.category, // تصنيف الوجبة (مثل "Seafood").
    this.area, // منطقة أو أصل الوجبة (مثل "Italian").
    this.instructions, // تعليمات التحضير (قد تكون null إذا لم تتوفر).
    this.ingredients = const [], // قائمة المكونات (قد تكون فارغة إذا لم تتوفر).
  });

  final String id;
  final String name;
  final String? image;
  final String? category;
  final String? area;
  final String? instructions;
  final List<String> ingredients;
}
