import 'package:get/get.dart';

import 'astrolabe_analysis_controller.dart';

class AstrolabeParameterController extends GetxController {
  late final AstrolabeAnalysisController analysisCtrl;

  final currentTabIndex = 0.obs;
  final currentChartData = Rx<dynamic>(null);

  @override
  void onInit() {
    super.onInit();
    analysisCtrl = Get.find<AstrolabeAnalysisController>();
    currentTabIndex.value = analysisCtrl.currentChartType.value;
    currentChartData.value =
        analysisCtrl.chartData[currentTabIndex.value]?.value;
  }
}
