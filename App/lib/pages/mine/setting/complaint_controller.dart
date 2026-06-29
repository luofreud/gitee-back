import 'package:flutter/material.dart';
import 'package:freud/widgets/component/app_select_media.dart';
import 'package:get/get.dart';

class ComplaintController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final tabs = ['订单投诉', '咨询师投诉', '其他投诉'];
  final tabIndex = 0.obs;
  late AppSelectMediaController appSelectMediaController;
  List<String> images = [];
  bool isLoading = false;
  final orderQuestions = ['无人接单', '咨询师未回复', '计费不准确', '其他（请在下方填写）'];
  final zxsQuestions = ['人身威胁', '咨询师未回复', '计费不准确', '其他（请在下方填写）'];
  final otherQuestions = ['功能异常', '平台人员服务', '内容版权', '其他（请在下方填写）'];
  final question = ''.obs;

  @override
  void onInit() {
    tabController = TabController(
      initialIndex: tabIndex.value,
      length: tabs.length,
      vsync: this,
    );
    appSelectMediaController = AppSelectMediaController();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    appSelectMediaController.dispose();
    super.onClose();
  }

  onUploadImage() {
    if (isLoading) return;
    isLoading = true;
    appSelectMediaController.upload();
  }

  onSubmit() async {
    if (isLoading) return;
    isLoading = true;
  }
}
