import 'package:get/get.dart';

class CounselorReportController extends GetxController {
  final trafficItems = [
    {"title": "浏览量", "value": 123, "compare": -100},
    {"title": "空间访客", "value": 123, "compare": 100},
    {"title": "新增粉丝", "value": 123, "compare": -100},
  ];
  final trafficIndex = 0.obs;

  traficChange(int index) {
    trafficIndex.value = index;
  }
}
