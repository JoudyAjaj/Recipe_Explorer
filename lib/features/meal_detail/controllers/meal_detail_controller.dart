// Controller في GetX: يدير الحالة والمنطق ويحدّث الواجهة.
import 'package:get/get.dart';

class MealDetailController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString mealId = ''.obs;
}
