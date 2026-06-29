import 'package:flutter/material.dart';
import 'package:freud/api/live/question_api.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:get/get.dart';

class OnlineQaController extends GetxController {
  final tabs = [
    {'title': '星盘', 'image': 'qa_tab_xp1.png', 'active': 'qa_tab_xp2.png'},
    {'title': '骰子', 'image': 'qa_tab_tz1.png', 'active': 'qa_tab_tz2.png'},
    {'title': '合盘', 'image': 'qa_tab_hp1.png', 'active': 'qa_tab_hp2.png'},
    {'title': '智慧牌', 'image': 'qa_tab_zhp1.png', 'active': 'qa_tab_zhp2.png'},
  ];
  final tabIndex = '星盘'.obs;

  late final TextEditingController contentController;

  final Rx<Archive?> archive1 = Rx<Archive?>(null);
  final Rx<Archive?> archive2 = Rx<Archive?>(null);

  // 智慧牌选择牌阵
  final pz = 0.obs;

  @override
  void onInit() {
    super.onInit();
    contentController = TextEditingController();
  }

  @override
  void onClose() {
    contentController.dispose();
    super.onClose();
  }

  static const _ordertypeMap = {'骰子': 0, '星盘': 1, '智慧牌': 2, '合盘': 3};

  submitQuestion() async {
    final ordertype = _ordertypeMap[tabIndex.value] ?? 0;

    if (ordertype == 1 || ordertype == 3) {
      if (archive1.value == null) {
        ToastUtil.info('请选择档案');
        return;
      }
    }
    if (ordertype == 3 && archive2.value == null) {
      ToastUtil.info('请选择第二个档案');
      return;
    }

    final text = contentController.text.trim();
    if (text.isEmpty) {
      ToastUtil.info('请输入您的问题');
      return;
    }

    if (tabIndex.value == '星盘') {
      Get.toNamed(AppRoutes.QA_ASTROLABE, arguments: {
        'content': text,
        'archive': archive1.value,
      });
      return;
    }

    if (tabIndex.value == '骰子') {
      Get.toNamed(AppRoutes.QA_DICE, arguments: {
        'content': text,
      });
      return;
    }

    if (tabIndex.value == '智慧牌') {
      Get.toNamed(AppRoutes.QA_TAROT_DETAIL, arguments: {
        'content': text,
        'pz': pz.value,
      });
      return;
    }

    if (tabIndex.value == '合盘') {
      Get.toNamed(AppRoutes.QA_SYNASTRY, arguments: {
        'content': text,
        'archive1': archive1.value,
        'archive2': archive2.value,
      });
      return;
    }

    var data = <String, dynamic>{
      'content': text,
      'ordertype': ordertype,
      'orderstate': 0,
      'name': text.length > 50 ? text.substring(0, 50) : text,
    };
    if (archive1.value?.id != null) {
      data['aid1'] = archive1.value!.id;
    }
    if (archive2.value?.id != null) {
      data['aid2'] = archive2.value!.id;
    }

    var result = await QuestionApi().questionAdd(data);
    if (result != null) {
      ToastUtil.success('提交成功');
      contentController.clear();
      archive1.value = null;
      archive2.value = null;
    } else {
      ToastUtil.error('提交失败');
    }
  }
}
