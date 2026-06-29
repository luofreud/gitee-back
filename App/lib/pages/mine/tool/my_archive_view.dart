import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/utils.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:freud/widgets/empty_tips.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:freud/widgets/page_background.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

import 'my_archive_controller.dart';

class MyArchivePage extends GetView<MyArchiveController> {
  const MyArchivePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => MyArchiveController());
    return PageBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('我的档案'),
          backgroundColor: Colors.white.withAlpha(0),
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Obx(() {
              if (controller.listData.isEmpty &&
                  controller.isLoading.value == false) {
                return EmptyTips(
                  title: '暂无档案',
                  subTitle: '点击下方按钮创建档案',
                  child: SizedBox(height: 100),
                );
              }
              return RefreshLoadmore(
                onLoad: () async {
                  await controller.listLoadMore();
                },
                onRefresh: () async {
                  await controller.listRefresh();
                },
                controller: controller.refreshController,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Obx(() {
                        if (!controller.showTips.value) {
                          return SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsetsGeometry.only(
                            left: AppConst.PAGE_PADDING,
                            right: AppConst.PAGE_PADDING,
                            bottom: 10,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '向左滑动可以删除档案',
                                    style: TextStyle(color: Color(0xffFF9C9C)),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    controller.hideDeleteTips();
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Icon(
                                    Icons.close,
                                    color: Color(0xff696969),
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    SliverPadding(
                      padding: const EdgeInsetsGeometry.only(
                        left: AppConst.PAGE_PADDING,
                        right: AppConst.PAGE_PADDING,
                        bottom: 150 + AppConst.PAGE_PADDING,
                      ),
                      sliver: SlidableAutoCloseBehavior(
                        child: SliverList.separated(
                          itemCount: controller.listData.length,
                          separatorBuilder: (_, index) =>
                              const SizedBox(height: 10),
                          itemBuilder: (_, index) {
                            return Stack(
                              children: [
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Slidable(
                                  groupTag: 'profile',
                                  endActionPane: ActionPane(
                                    extentRatio:
                                        80 / MediaQuery.of(context).size.width,
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (_) async {
                                          final result =
                                              await DialogUtil.showConfirmDialog(
                                                context: context,
                                                position: DialogPosition.center,
                                                title: '确定要删除该档案吗？',
                                              );
                                          if (result == true) {
                                            await controller.archiveDel(
                                              controller.listData[index].id!,
                                            );
                                          }
                                        },
                                        backgroundColor: Color(0xFFF24444),
                                        foregroundColor: Colors.white,
                                        borderRadius: BorderRadius.horizontal(
                                          right: Radius.circular(10),
                                        ),
                                        label: '删除',
                                      ),
                                    ],
                                  ),
                                  child: _ProfileItem(
                                    archive: controller.listData[index],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 120,
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.only(
                  top: 20,
                  left: AppConst.PAGE_PADDING,
                  right: AppConst.PAGE_PADDING,
                ),
                decoration: BoxDecoration(
                  // color: Colors.red,
                  gradient: LinearGradient(
                    colors: [Colors.white.withAlpha(0), Colors.white],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0, 0.8],
                  ),
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: GradientButton(
                        height: 52,
                        onPressed: () {},
                        foregroundColor: Color(0xff43CF7C),
                        gradient: LinearGradient(
                          colors: [Color(0xffFFFFFF), Color(0xffE3FFE4)],
                        ),
                        side: BorderSide(color: Color(0xff43CF7C)),
                        child: Text('邀请好友填写档案'),
                      ),
                    ),
                    Expanded(
                      child: GradientButton(
                        height: 52,
                        onPressed: () async {
                          final result = await Get.toNamed(
                            AppRoutes.TOOL_ARCHIVEADD,
                          );
                          if (result == true) {
                            //需要刷新数据
                            controller.listRefresh();
                          }
                        },
                        child: Text('添加档案'),
                      ),
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

class _ProfileItem extends StatelessWidget {
  final Archive archive;

  static Map<String, String> constellationIcons = {
    '白羊座': 'constellation/icon_tag_by.png',
    '金牛座': 'constellation/icon_tag_jn.png',
    '双子座': 'constellation/icon_tag_sz.png',
    '巨蟹座': 'constellation/icon_tag_jx.png',
    '狮子座': 'constellation/icon_tag_shizi.png',
    '处女座': 'constellation/icon_tag_cn.png',
    '天秤座': 'constellation/icon_tag_tc.png',
    '天蝎座': 'constellation/icon_tag_tx.png',
    '射手座': 'constellation/icon_tag_ss.png',
    '摩羯座': 'constellation/icon_tag_mj.png',
    '水瓶座': 'constellation/icon_tag_sp.png',
    '双鱼座': 'constellation/icon_tag_sy.png',
  };

  const _ProfileItem({super.key, required this.archive});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyArchiveController>();
    //处理星座图片
    Widget tagWidget = SizedBox.shrink();
    if (archive.birthday != null && archive.birthday!.isNotEmpty) {
      final birthday = DateTime.parse(archive.birthday!);
      final constellation = CommonUtil.getConstellationName(birthday);
      if (constellationIcons.containsKey(constellation)) {
        final iconPath = constellationIcons[constellation] ?? '';
        tagWidget = IconWidget(icon: iconPath, width: 58, height: 16);
      }
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Row(
                  children: [
                    Text(
                      archive.name ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    if (archive.relation != null &&
                        archive.relation!.isNotEmpty)
                      Text(
                        '(${archive.relation ?? ''})',
                        style: TextStyle(
                          color: Color(0xffA6A6A6),
                          fontSize: 16,
                        ),
                      ),
                    const SizedBox(width: 10),
                    tagWidget,
                    // UserTag(
                    //   title: '摩羯座',
                    //   icon: Image.asset(
                    //     'assets/icons/constellation/icon_mj.png',
                    //     width: 12,
                    //     height: 12,
                    //     fit: BoxFit.contain,
                    //     color: Color(0xff4CD4E0),
                    //   ),
                    //   color: Color(0xff4CD4E0),
                    //   gradient: LinearGradient(
                    //     colors: [Color(0xffF2FEFF), Color(0xffDBFCFF)],
                    //   ),
                    // ),
                  ],
                ),
                Text(
                  archive.birthday ?? '',
                  style: TextStyle(color: Color(0xffA6A6A6), fontSize: 14),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () async {
              final result = await Get.toNamed(
                AppRoutes.TOOL_ARCHIVEADD,
                arguments: archive,
              );
              if (result != null) {
                //需要刷新数据
                controller.listRefresh();
              }
            },
            behavior: HitTestBehavior.opaque,
            child: Image.asset(
              'assets/icons/icon_edit.png',
              width: 22,
              height: 22,
            ),
          ),
        ],
      ),
    );
  }
}
