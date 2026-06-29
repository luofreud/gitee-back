import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:get/get.dart';

import '../../../utils/dialog_util.dart';
import '../../../widgets/refresh_loadmore.dart';
import 'counselor_comment_controller.dart';

class CounselorCommentPage extends GetView<CounselorCommentController> {
  const CounselorCommentPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CounselorCommentController());
    return Scaffold(
      appBar: AppBar(
        title: Text('互动管理'),
        backgroundColor: Colors.white,
        shape: Border(bottom: BorderSide(color: Color(0xffF5F7F9), width: 1)),
      ),
      backgroundColor: Colors.white,
      body: RefreshLoadmore(
        controller: controller.refreshController,
        onLoad: () async {
          await controller.loadMore();
        },
        child: Obx(() {
          return ListView.separated(
            itemCount: controller.listData.length,
            separatorBuilder: (_, index) {
              return SizedBox.shrink();
            },
            itemBuilder: (_, index) {
              return ListTile(
                titleAlignment: ListTileTitleAlignment.top,
                leading: CircleAvatar(radius: 16),
                minLeadingWidth: 0,
                minVerticalPadding: 15,
                title: Row(
                  spacing: 5,
                  children: [
                    Text('${index}用户26*****5'),
                    Image.asset(
                      'assets/icons/icon_comment.png',
                      width: 13,
                      height: 13,
                    ),
                    //回复或者评论
                    Text(
                      '回复',
                      style: TextStyle(color: Color(0xffA6A6A6), fontSize: 12),
                    ),
                    Text(
                      '2小时前',
                      style: TextStyle(color: Color(0xffA6A6A6), fontSize: 12),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        DialogUtil.showMenuDialog(
                          context: context,
                          items: [
                            DialogMenuItem(title: '置顶', onTap: (_) {}),
                            DialogMenuItem(title: '删除', onTap: (_) {}),
                            DialogMenuItem(
                              title: '举报',
                              onTap: (_) {
                                Get.toNamed(
                                  AppRoutes.COUNSELOR_COMMENT_COMPLAINT,
                                );
                              },
                            ),
                          ],
                        );
                      },
                      child: Icon(Icons.more_horiz, size: 16),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text('昨夜雨疏风骤，浓睡不消残酒，兴尽晚回舟，误入藕花深处。争渡，争渡，'),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Color(0xffF7FAFC),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Image.asset(
                                    'assets/icons/icon_yh.png',
                                    width: 16,
                                    height: 16,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      ' 昨夜雨疏风骤，浓睡不消残酒，兴尽晚回舟，误入藕花深处。争渡，争渡，近期一争渡，争渡，近期一',
                                ),
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Divider(color: Color(0xffEDF2F5)),
                          Text(
                            '评论 · 天下最白的乌鸦 的动态',
                            style: TextStyle(color: Color(0xffA6A6A6)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
