import 'package:get/get.dart';

class ConstellationController extends GetxController {
  final List<String> tabs = ['今天', '明天', '本周', '本月', '今年', '爱情'];
  final tabIndex = 0.obs;

  changeTab(int index) {
    tabIndex.value = index;
  }
}
