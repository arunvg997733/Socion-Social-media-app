import 'package:get/get.dart';

class NavBarController extends GetxController {
  var currentIndex = 0.obs;

  onSelected(int value) {
    currentIndex.value = value;
  }
}
