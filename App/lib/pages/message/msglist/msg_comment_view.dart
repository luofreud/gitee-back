import 'package:flutter/material.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

import 'msg_comment_controller.dart';

class MsgCommentPage extends GetView<MsgCommentController> {
  const MsgCommentPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => MsgCommentController());
    return Scaffold(
      appBar: AppBar(title: Text('评论与回复'), backgroundColor: Colors.white),
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
                    Text('回复', style: TextStyle(color: Color(0xffA6A6A6))),
                    Text('2小时前', style: TextStyle(color: Color(0xffA6A6A6))),
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
