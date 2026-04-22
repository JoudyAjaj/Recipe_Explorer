// Model يمثل شكل البيانات القادمة من API أو المخزنة محليًا.
class MealSummaryModel {
  const MealSummaryModel({required this.id, required this.name, this.thumb});

  final String id;
  final String name;
  final String? thumb;

  factory MealSummaryModel.fromJson(Map<String, dynamic> json) {
    return MealSummaryModel(
      id: (json['idMeal'] ?? json['id'] ?? '').toString(),
      name: (json['strMeal'] ?? json['name'] ?? '').toString(),
      thumb: (json['strMealThumb'] ?? json['thumb'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'thumb': thumb,
    };
  }
}
