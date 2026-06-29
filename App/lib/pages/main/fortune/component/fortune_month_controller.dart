import 'package:freud/service/fortune_service.dart';
import 'package:get/get.dart';

class FortuneMonthController extends GetxController {
  final monthTabs = [].obs;
  List<DateTime> tabsDate = [];
  final selectedMonthIndex = 0.obs;

  int? currentArchiveId;
  final typeTabs = <String>[].obs;
  final selectedTypeIndex = 0.obs;

  final todayFortune = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    final today = DateTime.now();

    tabsDate = List.generate(7, (index) {
      return DateTime(today.year, today.month + index, 1);
    });

    monthTabs.value.addAll(
      tabsDate.map(
        (item) => '${(item.month == today.month ? '本' : item.month)}月',
      ),
    );
  }

  int? _loadedArchiveId;

  Future<void> loadFortuneForArchive(int archiveId) async {
    if (_loadedArchiveId == archiveId) return;
    _loadedArchiveId = archiveId;
    currentArchiveId = archiveId;
    todayFortune.value =
        await Get.find<FortuneService>().loadLuckMoon(archiveId);
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

  onDayChange(String month) {
    selectedMonthIndex.value = monthTabs.indexOf(month);
  }

  onTypeChange(String type) {
    selectedTypeIndex.value = typeTabs.indexOf(type);
  }
}
