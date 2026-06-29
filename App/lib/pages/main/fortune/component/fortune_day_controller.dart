import 'package:freud/service/fortune_service.dart';
import 'package:get/get.dart';

class FortuneDayController extends GetxController {
  final dayTabs = ['今日', '明日'].obs;
  List<DateTime> tabsDate = [];
  final selectedDayIndex = 0.obs;

  int? currentArchiveId;
  final typeTabs = <String>[].obs;
  final selectedTypeIndex = 0.obs;

  final todayFortune = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    final today = DateTime.now();
    dayTabs.value.addAll(
      List.generate(
        5,
        (index) => '${today.add(Duration(days: index + 2)).day}日',
      ),
    );
    tabsDate = List.generate(7, (index) => today.add(Duration(days: index)));
  }

  int? _loadedArchiveId;

  Future<void> loadFortuneForArchive(int archiveId) async {
    print('=============================');
    print(archiveId);
    if (_loadedArchiveId == archiveId) return;
    _loadedArchiveId = archiveId;
    currentArchiveId = archiveId;
    todayFortune.value = await Get.find<FortuneService>().loadLuckDay(
      archiveId,
    );
    _updateTypeTabs();
  }

  void _updateTypeTabs() {
    final corpus = todayFortune.value?['corpus'] as List<dynamic>?;
    if (corpus == null || corpus.isEmpty) {
      typeTabs.value = ['综合'];
      return;
    }
    final hasGeneral = corpus.any((item) {
      final cat = (item['category'] as String?) ?? '';
      return cat.isEmpty;
    });
    final categories = <String>[];
    if (hasGeneral) categories.add('综合');
    for (final item in corpus) {
      final cat = (item['category'] as String?) ?? '';
      if (cat.isEmpty) continue;
      if (!categories.contains(cat)) {
        categories.add(cat);
      }
    }
    typeTabs.value = categories;
    if (selectedTypeIndex.value >= typeTabs.length) {
      selectedTypeIndex.value = 0;
    }
  }

  onDayChange(String day) {
    selectedDayIndex.value = dayTabs.indexOf(day);
  }

  onTypeChange(String type) {
    selectedTypeIndex.value = typeTabs.indexOf(type);
  }
}
