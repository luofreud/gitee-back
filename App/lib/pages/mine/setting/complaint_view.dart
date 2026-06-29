import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/widgets/common/fixed_tab_indicator.dart';
import 'package:freud/widgets/component/app_select_media.dart';
import 'package:freud/widgets/component/menu_list_tile.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import 'complaint_controller.dart';

class ComplaintPage extends GetView<ComplaintController> {
  const ComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ComplaintController());

    return GestureDetector(
      onTap: () {
        CommonUtil.hideKeyShowUnfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('投诉'),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                foregroundColor: Color(0xff383838),
                elevation: 0,
                overlayColor: Colors.transparent,
              ),
              child: Text('投诉记录'),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: TabBar(
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                dividerHeight: 0,
                unselectedLabelColor: Color(0xff7986B0),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                labelColor: Colors.black,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                indicator: FixedTabIndicator(
                  borderSide: BorderSide(color: Color(0Xff4D1FAE), width: 4),
                  borderRadius: BorderRadius.circular(2),
                  width: 16,
                ),
                indicatorPadding: EdgeInsets.symmetric(vertical: 2),
                tabs: controller.tabs.map((item) {
                  return Tab(text: item);
                }).toList(),
                controller: controller.tabController,
                onTap: (index) {
                  controller.tabIndex.value = index;
                  controller.question.value = '';
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
                child: Column(
                  spacing: 10,
                  children: [
                    _FormBaseContainer(),
                    Text(
                      '您的投诉将在3个工作日内受理，请耐心等待',
                      style: TextStyle(fontSize: 14, color: Color(0xff677CF5)),
                    ),
                    GradientButton(
                      onPressed: () {
                        controller.onUploadImage();
                      },
                      width: double.infinity,
                      child: Text('提交'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormBaseContainer extends StatelessWidget {
  const _FormBaseContainer({super.key});

  _buildFormLabel(String title, {bool? required}) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: title),
          if (required == true)
            TextSpan(
              text: '*',
              style: TextStyle(color: Colors.red),
            ),
        ],
      ),
      style: TextStyle(fontWeight: FontWeight.w500),
    );
  }

  _buildFormOrder(context) {
    final controller = Get.find<ComplaintController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        _buildFormLabel('投诉订单', required: true),
        MenuListTile(
          title: '选择要投诉的订单',
          titleColor: Color(0xff6B6BFF),
          tileColor: Color(0xffFAFAFF),
          contentPadding: const EdgeInsets.only(left: 12, right: 14),
          radiusPosition: RadiusPosition.both,
          onTap: () {
            CommonUtil.hideKeyShowUnfocus();
          },
        ),
        const SizedBox.shrink(),
        _buildFormLabel('反馈订单的问题', required: true),
        Obx(() {
          final selected = controller.question.value?.isNotEmpty ?? false;
          return MenuListTile(
            title: selected ? controller.question.value : '选择投诉订单存在的问题',
            titleColor: selected ? Color(0xff383838) : Color(0xffA6A6A6),
            tileColor: Color(0xffFAFAFF),
            contentPadding: const EdgeInsets.only(left: 12, right: 14),
            radiusPosition: RadiusPosition.both,
            onTap: () {
              CommonUtil.hideKeyShowUnfocus();
              DialogUtil.showMenuDialog(
                context: context,
                items: controller.orderQuestions.map((item) {
                  return DialogMenuItem(
                    title: item,
                    onTap: (_) {
                      controller.question.value = item;
                    },
                  );
                }).toList(),
              );
            },
          );
        }),
      ],
    );
  }

  _buildFormZxs(context) {
    final controller = Get.find<ComplaintController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        _buildFormLabel('要投诉的咨询师', required: true),
        MenuListTile(
          title: '选择要投诉的咨询师',
          titleColor: Color(0xff6B6BFF),
          tileColor: Color(0xffFAFAFF),
          contentPadding: const EdgeInsets.only(left: 12, right: 14),
          radiusPosition: RadiusPosition.both,
          onTap: () {
            CommonUtil.hideKeyShowUnfocus();
          },
        ),
        const SizedBox.shrink(),
        _buildFormLabel('反馈投诉的问题', required: true),
        Obx(() {
          final selected = controller.question.value?.isNotEmpty ?? false;
          return MenuListTile(
            title: selected ? controller.question.value : '选择投诉咨询师存在的问题',
            titleColor: selected ? Color(0xff383838) : Color(0xffA6A6A6),
            tileColor: Color(0xffFAFAFF),
            contentPadding: const EdgeInsets.only(left: 12, right: 14),
            radiusPosition: RadiusPosition.both,
            onTap: () {
              CommonUtil.hideKeyShowUnfocus();
              DialogUtil.showMenuDialog(
                context: context,
                items: controller.zxsQuestions.map((item) {
                  return DialogMenuItem(
                    title: item,
                    onTap: (_) {
                      controller.question.value = item;
                    },
                  );
                }).toList(),
              );
            },
          );
        }),
      ],
    );
  }

  _buildFormOther(context) {
    final controller = Get.find<ComplaintController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        _buildFormLabel('要投诉的问题', required: true),
        Obx(() {
          final selected = controller.question.value?.isNotEmpty ?? false;
          return MenuListTile(
            title: selected ? controller.question.value : '选择要投诉的问题类型',
            titleColor: selected ? Color(0xff383838) : Color(0xffA6A6A6),
            tileColor: Color(0xffFAFAFF),
            contentPadding: const EdgeInsets.only(left: 12, right: 14),
            radiusPosition: RadiusPosition.both,
            onTap: () {
              CommonUtil.hideKeyShowUnfocus();
              DialogUtil.showMenuDialog(
                context: context,
                items: controller.otherQuestions.map((item) {
                  return DialogMenuItem(
                    title: item,
                    onTap: (_) {
                      controller.question.value = item;
                    },
                  );
                }).toList(),
              );
            },
          );
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ComplaintController>();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Obx(() {
            final tabIndex = controller.tabIndex.value;
            if (tabIndex == 0) {
              return _buildFormOrder(context);
            } else if (tabIndex == 1) {
              return _buildFormZxs(context);
            } else {
              return _buildFormOther(context);
            }
          }),
          const SizedBox.shrink(),
          _buildFormLabel('反馈内容和建议', required: true),
          TextField(
            maxLines: 5,
            style: TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: '请输入您遇到的问题或者建议，填写尽可能详细的信息有助于工作人员更快的处理。',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Color(0xffFAFAFF),
              contentPadding: EdgeInsets.all(10),
            ),
          ),
          const SizedBox.shrink(),
          _buildFormLabel('上传图片'),
          AppSelectMedia(
            maxCount: 5,
            urls: [],
            controller: controller.appSelectMediaController,
            onUploadSuccess: (urls) {
              controller.isLoading = false;
              controller.images = urls ?? [];
              controller.onSubmit();
            },
            onUploadError: (error) {
              controller.isLoading = false;
            },
          ),
        ],
      ),
    );
  }
}
