// Model يمثل شكل البيانات القادمة من API أو المخزنة محليًا.
class MealSummaryModel { //يعني كلاس بيستخدم لتمثيل بيانات الوجبة داخل التطبيق بدل ما تتعامل مع JSON مباشرة.
  const MealSummaryModel({required this.id, required this.name, this.thumb});

  final String id;
  final String name;
  final String? thumb; //thumb 👉 صورة الوجبة (ممكن تكون null لذلك فيها ?)

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
// }
// هذا الكلاس بيعمل شغلتين مهمات:
// ✅ يستقبل بيانات من API ويحولها لكائن
// ✅ يحول الكائن إلى JSON للتخزين أو الإرسال 