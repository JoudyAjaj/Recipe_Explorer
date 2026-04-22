// Model يمثل شكل البيانات القادمة من API أو المخزنة محليًا.
class CategoryModel {
  const CategoryModel({
    required this.id, // معرف التصنيف (مثل "Seafood").
    required this.name, // اسم التصنيف (مثل "Seafood").
    this.thumb, // رابط الصورة المصغرة للتصنيف (قد يكون null).
    this.description, // وصف للتصنيف (قد يكون null).
  });

  final String id;
  final String name; 
  final String? thumb; // رابط الصورة المصغرة (قد يكون null إذا لم يتوفر).
  final String? description;

  // نحول JSON الخاص بالتصنيف إلى Model واضح داخل التطبيق.
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: (json['strCategory'] ?? '').toString(),
      name: (json['strCategory'] ?? '').toString(),
      thumb: json['strCategoryThumb']?.toString(),
      description: json['strCategoryDescription']?.toString(),
    );
  }
}
