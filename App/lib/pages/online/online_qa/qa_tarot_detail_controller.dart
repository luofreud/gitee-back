import 'package:freud/api/xingpan/xingpan_api.dart';
import 'package:freud/constants/app_const.dart';
import 'package:get/get.dart';

class QaTarotDetailController extends GetxController {
  final loading = false.obs;
  final cards = <Map<String, dynamic>>[].obs;
  final question = ''.obs;
  final pz = 0.obs;

  static const _excludedKeys = {'id', 'title', 'explain', 'negative'};
  static const _fieldLabels = {
    'work': '工作',
    'love': '感情',
    'friend': '朋友',
    'affection': '亲情',
    'figure': '个性',
    'health': '健康',
    'money': '财运',
    'career': '事业',
  };

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      question.value = args['content'] as String? ?? '';
      pz.value = args['pz'] as int? ?? 0;
    }
    fetchCards();
  }

  Future<void> fetchCards() async {
    loading.value = true;
    try {
      final result = await XingpanApi().tarotGenerate();
      if (result is List) {
        cards.value = result.cast<Map<String, dynamic>>();
      }
    } finally {
      loading.value = false;
    }
  }

  String getCardImagePath(int id) {
    final name = AppConst.TAROT_CARD_NAMES[id - 1];
    return 'assets/images/taluopai/$name.jpg';
  }

  String getFieldLabel(String key) {
    return _fieldLabels[key] ?? key;
  }

  List<MapEntry<String, dynamic>> getExtraFields(Map<String, dynamic> card) {
    return card.entries
        .where((e) =>
            !_excludedKeys.contains(e.key) &&
            e.value != null &&
            (e.value as String).isNotEmpty)
        .toList();
  }

  String getCardPosition(String negative) {
    return negative == '1' ? '正位' : '逆位';
  }
}
