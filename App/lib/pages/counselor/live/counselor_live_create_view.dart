import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:get/get.dart';

import 'counselor_live_create_controller.dart';

class CounselorLiveCreatePage extends GetView<CounselorLiveCreateController> {
  const CounselorLiveCreatePage({super.key});

  _buildCoverImage(context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Obx(() {
            final coverImage = controller.coverImage.value;
            if (coverImage.isNotEmpty) {
              return Image.file(
                File(coverImage),
                width: 68,
                height: 91,
                fit: BoxFit.cover,
              );
            }
            return GestureDetector(
              onTap: () {
                controller.selectCoverImage(context);
              },
              child: Container(
                width: 68,
                height: 91,
                decoration: BoxDecoration(
                  color: Color(0xffF5F7F9),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_outlined,
                      size: 32,
                      color: Color(0xffcccccc),
                    ),
                    Text(
                      '选择封面',
                      style: TextStyle(fontSize: 10, color: Color(0xffcccccc)),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
        Obx(() {
          if (controller.coverImage.value.isEmpty) {
            return SizedBox.shrink();
          }
          return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                controller.selectCoverImage(context);
              },
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(6),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff242424).withAlpha(0),
                      Colors.black.withAlpha(100),
                    ],
                  ),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '更换封面',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  _buildTitle(context) {
    return Obx(() {
      if (controller.titleEditing.value == true) {
        return TextField(
          controller: controller.titleController,
          style: TextStyle(color: Colors.white, fontSize: 14),
          autofocus: true,
          decoration: InputDecoration(
            hintText: '请输入直播标题',
            hintStyle: TextStyle(color: Color(0xffE3E3E3), fontSize: 14),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense: true,
          ),
          onChanged: (value) {
            controller.title.value = value;
          },
          onSubmitted: (value) {
            controller.titleEditing.value = false;
          },
        );
      }
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: double.infinity),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            Flexible(
              child: Obx(() {
                return Text(
                  controller.title.value,
                  style: TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                );
              }),
            ),
            GestureDetector(
              onTap: () {
                controller.titleEditing.value = true;
              },
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: IconWidget(icon: 'icon_edit.png', size: 20),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CounselorLiveCreateController());
    return GestureDetector(
      onTap: () {
        controller.titleEditing.value = false;
        FocusScope.of(context).unfocus();
      },
      child: Obx(() {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: ImageView.provider(controller.themeUrl.value),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            appBar: AppBar(
              title: const Text(
                '咨询师直播间',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.black.withAlpha(0),
              foregroundColor: Colors.white,
            ),
            backgroundColor: controller.themeUrl.value.isEmpty
                ? Color(0xff4F4F4F)
                : Colors.transparent,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCoverImage(context),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              _buildTitle(context),
                              Divider(
                                color: Color(0xff6B6B6B),
                                thickness: 0.5,
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  DialogUtil.showMenuDialog(
                                    context: context,
                                    items: [
                                      DialogMenuItem(
                                        title: '所有人可见',
                                        onTap: (_) {},
                                      ),
                                      // DialogMenuItem(title: '不给谁看', onTap: (_) {}),
                                    ],
                                  );
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '所有人可见',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xffE3E3E3),
                                        height: 1,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 10,
                                      color: Color(0xffE3E3E3),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        DialogUtil.showModalBottom(
                          context: context,
                          backgroundColor: Color(0xff383838),
                          title: '更换主题',
                          titleStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          enableDrag: false,
                          child: const SizedBox(height: 10),
                          builder: (context) {
                            return _ChangeTheme();
                          },
                        );
                      },
                      child: Column(
                        children: [
                          IconWidget(icon: 'icon_live_theme.png', size: 24),
                          Text(
                            '更换背景',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        DialogUtil.showModalBottom(
                          context: context,
                          backgroundColor: Color(0xff383838),
                          title: '直播公告',
                          titleStyle: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          enableDrag: false,
                          child: const SizedBox(height: 10),
                          builder: (context) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 10,
                              children: [
                                TextField(
                                  autofocus: true,
                                  style: TextStyle(fontSize: 14, height: 1),
                                  maxLines: 4,
                                  textInputAction: TextInputAction.done,
                                  cursorHeight: 18,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(4),
                                      borderSide: BorderSide.none,
                                    ),
                                    hintText: '请输入直播公告',
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 10,
                                    ),
                                    isDense: true,
                                  ),
                                  controller: controller.noticeController,
                                  onChanged: (value) {
                                    controller.notice.value = value;
                                  },
                                  onSubmitted: (value) {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                Text(
                                  '直播注意事项',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  '请自觉遵守直播发言准则、禁止在直播中诋毁、辱骂他人。维护直播环境，违者封禁直播间。',
                                  style: TextStyle(color: Color(0xff808080)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Column(
                        children: [
                          IconWidget(icon: 'icon_live_notice.png', size: 24),
                          Text(
                            '直播公告',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: OutlinedButton(
                    onPressed: () {
                      controller.createLiveRoom();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xffFF5959),
                      foregroundColor: Colors.white,
                      side: BorderSide.none,
                    ),
                    child: Text('开启直播'),
                  ),
                ),
                const SizedBox(height: 150),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _ChangeTheme extends StatelessWidget {
  const _ChangeTheme({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CounselorLiveCreateController>();
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        separatorBuilder: (_, index) {
          return const SizedBox(width: 10);
        },
        itemBuilder: (_, index) {
          return Obx(() {
            final bool isSelected =
                controller.themeUrl.value ==
                'https://picsum.photos/1024/768?t=$index';
            return Column(
              spacing: 5,
              children: [
                GestureDetector(
                  onTap: () {
                    controller.themeUrl.value =
                        'https://picsum.photos/1024/768?t=$index';
                  },
                  child: Container(
                    width: 70,
                    height: 105,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Color(0xff383838),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                            ? Color(0xffFFC300)
                            : Colors.transparent,
                      ),
                    ),
                    child: ImageView.network(
                      'https://picsum.photos/1024/768?t=$index',
                      isPreview: false,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
                // Text(
                //   'data',
                //   style: TextStyle(color: Colors.white.withAlpha(100)),
                // ),
              ],
            );
          });
        },
      ),
    );
  }
}
