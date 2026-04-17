// Model خاص بالميزة لتجميع البيانات بشكل منظم.
class CategoryModel {
  const CategoryModel({required this.id, required this.name, this.thumb});

  final String id;
  final String name;
  final String? thumb;
}
