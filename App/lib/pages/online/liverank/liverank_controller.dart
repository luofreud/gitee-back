import 'package:get/get.dart';

class LiverankController extends GetxController {
  final List<String> tabs = ['热度榜', '好评榜', '新人榜'];
  final tabActive = '热度榜'.obs;

  @override
  void onInit() {
    print('oninit');
    super.onInit();
  }

  void changeTab(String tab) {
    tabActive.value = tab;
  }
}
