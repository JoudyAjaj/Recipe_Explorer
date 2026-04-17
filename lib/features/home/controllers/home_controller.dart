// Controller في GetX: يدير الحالة والمنطق ويحدّث الواجهة.
import 'package:get/get.dart';

class HomeController extends GetxController {
  // isLoading: حالة التحميل أثناء طلب البيانات من API.
  final RxBool isLoading = false.obs;

  // errorMessage: نص الخطأ لعرضه في الواجهة عند فشل الطلب.
  final RxString errorMessage = ''.obs;

  // categories: قائمة أسماء التصنيفات (مؤقتًا String إلى أن نربط Model/API).
  final RxList<String> categories = <String>[].obs;

  // selectedCategory: التصنيف الحالي المختار من المستخدم.
  final RxString selectedCategory = ''.obs;

  // selectedMealId: رقم الوجبة الحالي المختار.
  final RxString selectedMealId = ''.obs;
}
