class MealDetailModel {
  const MealDetailModel({
    required this.id,
    required this.name,
    this.image,
    this.category,
    this.area,
    this.instructions,
    this.ingredients = const [],
  });

  final String id;
  final String name;
  final String? image;
  final String? category;
  final String? area;
  final String? instructions;
  final List<String> ingredients;
}
