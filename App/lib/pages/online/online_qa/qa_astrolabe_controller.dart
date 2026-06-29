import 'package:freud/api/live/question_api.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:get/get.dart';

class QaAstrolabeController extends GetxController {
  final question = ''.obs;
  final Rx<Archive?> archive = Rx<Archive?>(null);

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
      archive.value = args['archive'] as Archive?;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  submitQuestion() async {
    final text = question.value.trim();
    if (text.isEmpty) {
      ToastUtil.info('请输入您的问题');
      return;
    }
    if (archive.value == null) {
      ToastUtil.info('请选择档案');
      return;
    }

    var data = <String, dynamic>{
      'content': text,
      'ordertype': 1,
      'orderstate': 0,
      'price': priceData.firstWhere((e) => e['num'] == selectedPrice.value)['price'],
      'name': text.length > 50 ? text.substring(0, 50) : text,
    };
    if (archive.value?.id != null) {
      data['aid1'] = archive.value!.id;
    }

    var result = await QuestionApi().questionAdd(data);
    if (result != null) {
      ToastUtil.success('提交成功');
      Get.back();
    } else {
      ToastUtil.error('提交失败');
    }
  }
}
