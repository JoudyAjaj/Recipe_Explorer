import 'package:get/get.dart';

class FavouritesController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<String> favouriteMealIds = <String>[].obs;
}
