import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'creation_content_controller.dart';

class CreationContentPage extends GetView<CreationContentController> {
  const CreationContentPage({super.key});

  _showSaveDraft(context) {
    return DialogUtil.showMenuDialog(
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
            // 保存草稿
          },
        ),
        DialogMenuItem(title: '不保存', color: Colors.red, onTap: (_) {}),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CreationContentController());
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (canPop, result) async {
        if (canPop == false) {
          bool? isBack = await _showSaveDraft(context);
          if (isBack == true) {
            Get.back();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('创作'),
          backgroundColor: Colors.white,
          actions: [
            Obx(() {
              return GradientButton(
                onPressed: controller.allowPublish
                    ? () {
                        controller.publish(context);
                      }
                    : null,
                gradient: const LinearGradient(
                  colors: [Color(0xff945EFF), Color(0xff2E2EB8)],
                ),
                isRadius: true,
                child: Row(
                  children: [Text('发布', style: TextStyle(color: Colors.white))],
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
                Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
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
                          onChanged: (value) {
                            controller.title.value = value;
                          },
                        ),
                        Divider(
                          color: Color(0xffF5F5F5),
                          height: 1,
                          thickness: 1,
                        ),
                        TextField(
                          maxLines: 10,
                          decoration: InputDecoration(
                            hintText: '开始你的创作吧~',
                            hintStyle: TextStyle(
                              color: Color(0xffA6A6A6),
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            controller.content.value = value;
                          },
                        ),
                        _ImageSelectWidget(controller: controller),
                        Row(
                          spacing: 10,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                controller.isTest.value =
                                    !controller.isTest.value;
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
                                  children: [
                                    Obx(() {
                                      return Checkbox(
                                        value: controller.isTest.value,
                                        side: BorderSide(
                                          width: 1,
                                          color: Color(0xff808080),
                                        ),
                                        fillColor: WidgetStateProperty.all(
                                          Colors.white,
                                        ),
                                        checkColor: Color(0xff808080),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                        onChanged: (value) {
                                          controller.isTest.value =
                                              value ?? false;
                                        },
                                      );
                                    }),
                                    Text(
                                      '测试题',
                                      style: TextStyle(
                                        color: Color(0xffA6A6A6),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            _TopicWidget(controller: controller),
                          ],
                        ),

                        // Divider(
                        //   color: Color(0xffF5F5F5),
                        //   height: 30,
                        //   thickness: 1,
                        // ),
                        // _CategoryWidget(controller: controller),
                        Divider(
                          color: Color(0xffF5F5F5),
                          height: 30,
                          thickness: 1,
                        ),
                        Row(children: [Container(child: Text('所有人可见'))]),
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

/// 图片视频选择
class _ImageSelectWidget extends StatelessWidget {
  final CreationContentController controller;

  const _ImageSelectWidget({super.key, required this.controller});

  _buildAddImage(context) {
    return GestureDetector(
      onTap: () async {
        CommonUtil.hideKeyShowUnfocus();
        var result = await CommonUtil.selectImage(
          context,
          maxCount: 9 - controller.selectFilePaths.length,
          requestType: RequestType.image,
        );
        if (result != null && result.isNotEmpty) {
          result.forEach((item) async {
            controller.selectFilePaths.add((await item.file)?.path);
          });
          controller.selectAssets.addAll(result);
        }
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Color(0xffF5F7F9)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 32, color: Color(0xffcccccc)),
            Text(
              '图片/视频',
              style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
            ),
          ],
        ),
      ),
    );
  }

  _buildImageItem(int index) {
    var path = controller.selectFilePaths[index];
    return Stack(
      children: [
        ImageView.file(
          path,
          paths: controller.selectFilePaths
              .map((item) => item as String)
              .toList(),
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          heroTag: controller.selectFileHerTags[index],
          heroTags: controller.selectFileHerTags,
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              controller.selectAssets.removeAt(index);
              controller.selectFilePaths.removeAt(index);
            },
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Color(0xff262626).withAlpha(100),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                ),
              ),
              child: Icon(Icons.close, size: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controller.selectFilePaths.length == 9
            ? 9
            : controller.selectFilePaths.length + 1,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 120,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (_, index) {
          Widget child;
          if (index <= controller.selectFilePaths.length - 1) {
            child = _buildImageItem(index);
          } else {
            child = _buildAddImage(context);
          }
          return ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Container(alignment: Alignment.center, child: child),
          );
        },
      );
    });
  }
}

/// 话题
class _TopicWidget extends StatelessWidget {
  final CreationContentController controller;

  const _TopicWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (controller.topicText.value.isEmpty) {
          //跳转话题选择
          var result = await Get.toNamed(AppRoutes.TOPIC_SELECT);
          if (result != null) {
            controller.topicText.value = '话题$result';
          }
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
  final CreationContentController controller;

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
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: controller.categorys.map((item) {
              return GestureDetector(
                onTap: () {
                  controller.category.value = item;
                },
                child: Obx(() {
                  bool isSelected = item == controller.category.value;
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xffDFDEFF) : Color(0xffF5F7F9),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Text(item, style: TextStyle(fontSize: 14)),
                  );
                }),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
