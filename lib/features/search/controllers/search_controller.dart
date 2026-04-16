import 'package:get/get.dart';

class SearchController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString query = ''.obs;
  final RxList<String> results = <String>[].obs;
}
