import 'package:get/get.dart';

class DiscoverTestController extends GetxController {
  List<int> listData = <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].obs;
  RxBool isLoading = false.obs;

  listRefresh() {
    listData.clear();
    return loadMore();
  }

  loadMore() {
    if (isLoading.value) return;
    int length = listData.length;
    isLoading.value = true;
    return Future.delayed(Duration(seconds: 1), () {
      listData.addAll(List.generate(10, (index) => length + index));
      isLoading.value = false;
    });
  }
}
