import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/widgets/component/circle_checkbox.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import '../../../utils/dialog_util.dart';
import 'evaluation_publish_controller.dart';

class EvaluationPublishPage extends GetView<EvaluationPublishController> {
  const EvaluationPublishPage({super.key});

  _buildOrderInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              foregroundImage: const AssetImage(
                'assets/example/home_item_image.png',
              ),
            ),
            title: Text(
              '一个了不起的人',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            subtitle: Row(
              children: [
                Text(
                  '5.2星钻/分钟',
                  style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
                ),
                const Spacer(),
                Text(
                  '2025/12/25',
                  style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
                ),
              ],
            ),
            contentPadding: EdgeInsets.zero,
            minTileHeight: 0,
          ),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                style: TextStyle(fontSize: 12),
                TextSpan(
                  children: [
                    TextSpan(text: '免费：'),
                    TextSpan(text: '3', style: TextStyle(fontSize: 20)),
                    TextSpan(text: ' 分钟'),
                  ],
                ),
              ),
              Text.rich(
                style: TextStyle(fontSize: 12),
                TextSpan(
                  children: [
                    TextSpan(text: '付费：'),
                    TextSpan(text: '6', style: TextStyle(fontSize: 20)),
                    TextSpan(text: ' 分钟'),
                  ],
                ),
              ),
              Spacer(),
              Text.rich(
                style: TextStyle(fontSize: 12),
                TextSpan(
                  children: [
                    TextSpan(text: '消费 '),
                    TextSpan(
                      text: '32.1',
                      style: TextStyle(fontSize: 20, color: Color(0xffFF5733)),
                    ),
                    TextSpan(text: ' 星钻'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildRating() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        spacing: 15,
        children: [
          Text(
            '咨询评分',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(5, (index) {
                  final isSelected = index < controller.rating.value;
                  return GestureDetector(
                    onTap: () {
                      controller.rating.value = index + 1;
                    },
                    child: Image.asset(
                      'assets/icons/${isSelected ? 'icon_star2.png' : 'icon_star.png'}',
                      width: 26,
                      height: 26,
                    ),
                  );
                }),
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => EvaluationPublishController());
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop, result) async {
        CommonUtil.hideKeyShowUnfocus();
        if (canPop == false) {
          bool? isBack = await DialogUtil.showConfirmDialog(
            context: context,
            confirmText: '确认',
            child: Text(
              '你的评价对咨询师很重要确定离开吗？',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            position: DialogPosition.center,
          );
          if (isBack == true) {
            Get.back();
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          CommonUtil.hideKeyShowUnfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('评价'),
            backgroundColor: Colors.white,
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: AppConst.PAGE_PADDING,
                    right: AppConst.PAGE_PADDING,
                    top: AppConst.PAGE_PADDING,
                    bottom: AppConst.PAGE_PADDING + 10,
                  ),
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    spacing: 10,
                    children: [_buildOrderInfo(), _buildRating()],
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -10),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      left: 24,
                      top: 10,
                      right: 24,
                      bottom: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xffEBF2FF), Color(0xffF5F0FF)],
                      ),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      '填写评论达到5字以上可以获得星币奖励哦~',
                      style: TextStyle(fontSize: 14, color: Color(0xff6251A8)),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, -20),
                  child: Container(
                    padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      spacing: 15,
                      children: [
                        TextField(
                          maxLength: 100,
                          maxLines: 7,
                          obscureText: false,
                          decoration: InputDecoration(
                            hintText: '请给咨询师一个评价鼓励ta吧~',
                            hintStyle: TextStyle(color: Color(0xff808080)),
                            filled: true,
                            fillColor: Color(0xffF5F7F9),
                            counterText: '',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {},
                        ),
                        const SizedBox.shrink(),
                        Row(
                          children: [
                            Obx(() {
                              return CircleCheckbox(
                                fillColor: Colors.white,
                                value: controller.anonymous.value,
                                side: BorderSide(color: Color(0xff808080)),
                                onChanged: (value) {
                                  controller.anonymous.value = value ?? false;
                                },
                              );
                            }),
                            GestureDetector(
                              onTap: () {
                                controller.anonymous.value =
                                    !controller.anonymous.value;
                              },
                              child: Text('匿名评价'),
                            ),
                          ],
                        ),
                        GradientButton(
                          width: double.infinity,
                          height: 48,
                          onPressed: () async {},
                          child: Text('提交'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
