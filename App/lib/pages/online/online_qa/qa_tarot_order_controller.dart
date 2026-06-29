import 'package:freud/api/live/question_api.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:get/get.dart';

class QaTarotOrderController extends GetxController {
  final cards = <Map<String, dynamic>>[].obs;
  final question = ''.obs;
  final selectedPrice = 2.obs;
  final showFull = false.obs;

  final priceData = [
    {'title': '1位咨询师', 'price': '18.00', 'originalPrice': '36.00', 'num': 1},
    {
      'title': '2位咨询师',
      'price': '28.00',
      'originalPrice': '36.00',
      'num': 2,
      'tips': '特惠x元',
    },
    {
      'title': '3位咨询师',
      'price': '38.00',
      'originalPrice': '56.00',
      'num': 3,
      'tips': '特惠',
    },
    {
      'title': '4位咨询师',
      'price': '48.00',
      'originalPrice': '66.00',
      'num': 4,
      'tips': '特惠',
    },
    {
      'title': '5位咨询师',
      'price': '58.00',
      'originalPrice': '76.00',
      'num': 5,
      'tips': '特惠',
    },
  ];

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
      final rawCards = args['cards'];
      if (rawCards is List) {
        cards.value = rawCards.cast<Map<String, dynamic>>();
      }
      question.value = args['question'] as String? ?? '';
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

  void toggleShowFull() => showFull.toggle();

  String getCardPosition(String negative) {
    return negative == '1' ? '正位' : '逆位';
  }

  submitQuestion() async {
    final text = question.value.trim();
    if (text.isEmpty) {
      ToastUtil.info('请输入您的问题');
      return;
    }

    var data = <String, dynamic>{
      'content': text,
      'ordertype': 2,
      'orderstate': 0,
      'price':
          priceData.firstWhere((e) => e['num'] == selectedPrice.value)['price'],
      'name': text.length > 50 ? text.substring(0, 50) : text,
    };

    var result = await QuestionApi().questionAdd(data);
    if (result != null) {
      ToastUtil.success('提交成功');
      Get.back();
    } else {
      ToastUtil.error('提交失败');
    }
  }
}
