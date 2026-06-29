import 'package:freud/pages/main/astrolabe/astrolabe_analysis_controller.dart';
import 'package:freud/pages/main/astrolabe/utils/parsing.dart';
import 'package:get/get.dart';

class AstrolabeDetailController extends GetxController {
  final _analysisCtrl = Get.find<AstrolabeAnalysisController>();

  final birthChartTabs = ['星座解读', '落宫分析']; //, '相位解析'
  final birthChartTabStr = '星座解读'.obs;

  List get xzjdList => _analysisCtrl.xzjdList;

  List get lgfxList => _analysisCtrl.lgfxList;

  List<PhaseEntry> get phaseList {
    final chartData =
        _analysisCtrl.chartData[_analysisCtrl.currentChartType.value]?.value;
    if (chartData == null) return [];
    final planetData = chartData['planet'];
    if (planetData == null) return [];
    return parseChartData(planetData).phases;
  }

  @override
  void onInit() {
    super.onInit();
    final tab = Get.arguments?['tab'] as String?;
    if (tab != null && birthChartTabs.contains(tab)) {
      birthChartTabStr.value = tab;
    }
  }

  void changeBirthChartTab(String item) {
    birthChartTabStr.value = item;
  }
}
