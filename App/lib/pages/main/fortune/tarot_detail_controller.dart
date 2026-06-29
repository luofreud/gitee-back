import 'package:freud/api/xingpan/xingpan_api.dart';
import 'package:freud/constants/app_const.dart';
import 'package:get/get.dart';

class TarotDetailController extends GetxController {
  final loading = false.obs;
  final cards = <Map<String, dynamic>>[].obs;

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

  /// 根据塔罗牌 ID 获取对应的图片资源路径
  String getCardImagePath(int id) {
    final name = AppConst.TAROT_CARD_NAMES[id - 1];
    return 'assets/images/taluopai/$name.jpg';
  }

  /// 获取英文字段名对应的中文标签
  String getFieldLabel(String key) {
    return _fieldLabels[key] ?? key;
  }

  /// 获取除了 id/title/explain/negative 之外的非空扩展字段
  List<MapEntry<String, dynamic>> getExtraFields(Map<String, dynamic> card) {
    return card.entries
        .where((e) =>
            !_excludedKeys.contains(e.key) &&
            e.value != null &&
            (e.value as String).isNotEmpty)
        .toList();
  }

  /// 将 negative 值转为正位/逆位
  String getCardPosition(String negative) {
    return negative == '1' ? '正位' : '逆位';
  }
}
