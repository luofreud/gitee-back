import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import '../../../widgets/refresh_loadmore.dart';
import 'draft_list_controller.dart';

class DraftListPage extends GetView<DraftListController> {
  const DraftListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DraftListController());
    return Scaffold(
      appBar: AppBar(
        title: Text('草稿箱'),
        backgroundColor: Colors.white,
        actions: [
          GestureDetector(
            onTap: () {
              DialogUtil.showConfirmDialog(
                context: context,
                title: '确定要清空草稿箱吗？',
                position: DialogPosition.center,
                onConfirm: (_context) {
                  Navigator.of(_context).pop();
                  controller.clearAll();
                },
              );
            },
            child: Text('清空'),
          ),
          const SizedBox(width: AppConst.PAGE_PADDING),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: RefreshLoadmore(
          controller: controller.refreshController,
          onRefresh: () async {
            await controller.listRefresh();
          },
          onLoad: () async {
            await controller.loadMore();
          },
          child: SlidableAutoCloseBehavior(
            child: Obx(() {
              if (controller.listData.isEmpty) {
                return Center(
                  child: Text(
                    '暂无草稿',
                    style: TextStyle(color: Color(0xffA6A6A6), fontSize: 14),
                  ),
                );
              }
              return ListView.separated(
                itemCount: controller.listData.length,
                separatorBuilder: (context, index) {
                  return Divider(
                    height: 1,
                    thickness: 1,
                    indent: 60,
                    color: Color(0xffF2F2F2),
                  );
                },
                itemBuilder: (context, index) {
                  var draft = controller.listData[index];
                  var itemWidget = ListTile(
                    onTap: () {
                      Get.back(result: draft);
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset('assets/images/ic_launcher.png'),
                    ),
                    title: Text(
                      draft['title'] ?? '无标题',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      draft['content'] ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    subtitleTextStyle: TextStyle(
                      fontSize: 12,
                      color: Color(0xffA6A6A6),
                    ),
                  );
                  return Slidable(
                    groupTag: 'message',
                    endActionPane: ActionPane(
                      extentRatio: 80 / MediaQuery.of(context).size.width,
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            DialogUtil.showConfirmDialog(
                              context: context,
                              title: '确定要删除该草稿吗？',
                              position: DialogPosition.center,
                              onConfirm: (__context) {
                                Navigator.of(__context).pop();
                                controller.deleteDraft(index);
                              },
                            );
                          },
                          backgroundColor: Color(0xFFF24444),
                          foregroundColor: Colors.white,
                          label: '删除',
                        ),
                      ],
                    ),
                    child: itemWidget,
                  );
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}
