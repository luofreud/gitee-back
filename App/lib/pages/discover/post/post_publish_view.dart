import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/widgets/component/app_select_media.dart';
import 'package:freud/widgets/component/circle_checkbox.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import '../../../widgets/gradient_button.dart';
import 'post_publish_controller.dart';

class PostPublishPage extends GetView<PostPublishController> {
  const PostPublishPage({super.key});

  _showSaveDraft(context) async {
    var result = await DialogUtil.showMenuDialog(
      context: context,
      header: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(
          '是否保存为草稿？',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      items: [
        DialogMenuItem(
          title: '保存',
          onTap: (_) {
            controller.saveDraft();
            Get.back(result: true);
          },
        ),
        DialogMenuItem(
          title: '不保存',
          color: Colors.red,
          onTap: (_) {
            Get.back(result: true);
          },
        ),
      ],
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => PostPublishController());
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop, result) async {
        if (controller.titleController.text.isEmpty &&
            controller.contentController.text.isEmpty) {
          Get.back();
        } else {
          if (canPop == false) {
            bool? isBack = await _showSaveDraft(context);
            if (isBack == true) {
              Get.back();
            }
          }
        }
      },
      child: GestureDetector(
        onTap: () {
          CommonUtil.hideKeyShowUnfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('发贴'),
            backgroundColor: Colors.white,
            actions: [
              Obx(() {
                return GradientButton(
                  onPressed: controller.allowPublish
                      ? () {
                          controller.onUpload();
                        }
                      : null,
                  gradient: const LinearGradient(
                    colors: [Color(0xff945EFF), Color(0xff2E2EB8)],
                  ),
                  height: 32,
                  textStyle: const TextStyle(fontSize: 14),
                  isRadius: true,
                  child: Row(
                    children: [
                      Text('发布', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                );
              }),
              const SizedBox(width: AppConst.PAGE_PADDING),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
            child: GestureDetector(
              onTap: () {
                CommonUtil.hideKeyShowUnfocus();
              },
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '首次发布帖子后可以获得30星币奖励~',
                      style: TextStyle(color: Color(0xff807DD4)),
                    ),
                  ),
                  Card(
                    elevation: 0,
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: controller.titleController,
                            maxLength: 30,
                            style: TextStyle(fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              hintText: '填写标题',
                              hintStyle: TextStyle(
                                color: Color(0xffA6A6A6),
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              counterText: '',
                            ),
                          ),
                          Divider(
                            color: Color(0xffF5F5F5),
                            height: 1,
                            thickness: 1,
                          ),
                          TextField(
                            controller: controller.contentController,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: '可以填入星座、星盘、烦恼等话题与大家一起讨论~',
                              hintStyle: TextStyle(
                                color: Color(0xffA6A6A6),
                                fontSize: 14,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                          AppSelectMedia(
                            controller: controller.selectMediaController,
                            onUploadSuccess: (urls) {
                              controller.isUploading = false;
                              controller.imgs = urls ?? [];
                              controller.publish(context);
                            },
                            onUploadError: (error) {
                              controller.isUploading = false;
                            },
                          ),
                          _TopicWidget(controller: controller),
                          Divider(
                            color: Color(0xffF5F5F5),
                            height: 30,
                            thickness: 1,
                          ),
                          _CategoryWidget(controller: controller),
                          Divider(
                            color: Color(0xffF5F5F5),
                            height: 30,
                            thickness: 1,
                          ),
                          Row(
                            children: [
                              Obx(() {
                                return CircleCheckbox(
                                  value: controller.anonymous.value,
                                  fillColor: Colors.white,
                                  checkColor: Color(0xff0E2067),
                                  side: BorderSide(
                                    width: 1,
                                    color: Color(0xffA6A6A6),
                                  ),
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
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text('匿名'),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  var result = await Get.toNamed(
                                    AppRoutes.DRAFT_LIST,
                                  );
                                  if (result is Map<String, dynamic>) {
                                    controller.fillDraft(result);
                                  }
                                },
                                child: Text('草稿箱'),
                              ),
                            ],
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
      ),
    );
  }
}

/// 话题
class _TopicWidget extends StatelessWidget {
  final PostPublishController controller;

  const _TopicWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        //跳转话题选择
        var result = await Get.toNamed(AppRoutes.TOPIC_SELECT);
        if (result != null) {
          controller.topicText.value = '${result.title}';
          controller.topicId.value = result.id;
        }
      },
      child: Container(
        height: 32,
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xffF5F7F9),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Text('#', style: TextStyle(color: Color(0xff808080))),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 200.0, // 设置最大宽度
              ),
              child: IntrinsicWidth(
                child: Obx(() {
                  if (controller.topicText.value.isNotEmpty) {
                    return Text(controller.topicText.value);
                  }
                  return Text(
                    '添加话题',
                    style: TextStyle(
                      color: Color(0xffA6A6A6),
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }),
              ),
            ),
            Obx(() {
              if (controller.topicText.value.isNotEmpty) {
                return GestureDetector(
                  onTap: () {
                    controller.topicText.value = '';
                  },
                  child: Icon(Icons.close, size: 18, color: Color(0xff808080)),
                );
              } else {
                return SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}

/// 分类板块
class _CategoryWidget extends StatelessWidget {
  final PostPublishController controller;

  const _CategoryWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.translate(offset: Offset(0, 2), child: Text('选择板块')),
        Transform.translate(
          offset: Offset(-5, 2),
          child: Icon(Icons.arrow_right_outlined),
        ),
        Expanded(
          child: Obx(() {
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: controller.plateList.map((plate) {
                bool isSelected =
                    plate.id == controller.selectedPlate.value?.id;
                return GestureDetector(
                  onTap: () {
                    controller.selectedPlate.value = plate;
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xffDFDEFF) : Color(0xffF5F7F9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(
                      plate.title ?? '',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ),
      ],
    );
  }
}
