import 'package:freud/service/fortune_service.dart';
import 'package:get/get.dart';

class FortuneYearController extends GetxController {
  final yearTabs = [].obs;
  List<DateTime> tabsDate = [];
  final selectedYearIndex = 0.obs;

  int? currentArchiveId;
  final typeTabs = <String>[].obs;
  final selectedTypeIndex = 0.obs;

  final todayFortune = Rx<Map<String, dynamic>?>(null);

  @override
  void onInit() {
    super.onInit();
    final today = DateTime.now();

    tabsDate = List.generate(5, (index) {
      return DateTime(today.year + index - 2, 1, 1);
    });

    yearTabs.value.addAll(
      tabsDate.map((item) => '${(item.year == today.year ? '本' : item.year)}年'),
    );
    selectedYearIndex.value = 2;
  }

  int? _loadedArchiveId;

  Future<void> loadFortuneForArchive(int archiveId) async {
    if (_loadedArchiveId == archiveId) return;
    _loadedArchiveId = archiveId;
    currentArchiveId = archiveId;
    todayFortune.value =
        await Get.find<FortuneService>().loadLuckYear(archiveId);
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

  onDayChange(String year) {
    selectedYearIndex.value = yearTabs.indexOf(year);
  }

  onTypeChange(String type) {
    selectedTypeIndex.value = typeTabs.indexOf(type);
  }
}
