// Controller في GetX: يدير الحالة والمنطق ويحدّث الواجهة.
import 'package:get/get.dart';

class CategoryMealsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<String> meals = <String>[].obs;
}