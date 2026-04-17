// Model يمثل شكل البيانات القادمة من API أو المخزنة محليًا.
class CategoryModel {
  const CategoryModel({required this.id, required this.name, this.thumb});

  final String id;
  final String name;
  final String? thumb;
}
