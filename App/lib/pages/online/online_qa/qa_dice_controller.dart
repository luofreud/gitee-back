import 'package:freud/api/live/question_api.dart';
import 'package:freud/api/xingpan/xingpan_api.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:get/get.dart';

class QaDiceController extends GetxController {
  final question = ''.obs;
  final loading = false.obs;
  final diceItems = <Map<String, dynamic>>[].obs;

  final selectedPrice = 2.obs;

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

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      question.value = args['content'] as String? ?? '';
    }
    fetchDiceData();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchDiceData() async {
    loading.value = true;
    try {
      final result = await XingpanApi().diceGenerate();
      if (result == null) return;
      final parse = (Map m, String type) {
        final id = m['id'] as int;
        final c = List<String>.from(m['content'] as List);
        return <String, dynamic>{
          'type': type,
          'id': id,
          'title': c[0],
          'desc': c.sublist(1),
        };
      };
      diceItems.value = [
        parse(result['planet'], 'planet'),
        parse(result['house'], 'house'),
        parse(result['constellation'], 'constellation'),
      ];
    } finally {
      loading.value = false;
    }
  }

  submitQuestion() async {
    final text = question.value.trim();
    if (text.isEmpty) {
      ToastUtil.info('请输入您的问题');
      return;
    }

    var data = <String, dynamic>{
      'content': text,
      'ordertype': 0,
      'orderstate': 0,
      'price': priceData.firstWhere((e) => e['num'] == selectedPrice.value)['price'],
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
