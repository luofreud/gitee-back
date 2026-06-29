import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import '../../../widgets/refresh_loadmore.dart';
import 'topic_list_controller.dart';

class TopicListPage extends GetView<TopicListController> {
  const TopicListPage({super.key});

  /// 副标题和浏览数文字样式
  TextStyle get subStyle => TextStyle(fontSize: 12, color: Color(0xffA6A6A6));

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => TopicListController());
    return Scaffold(
      appBar: AppBar(title: Text('话题广场'), backgroundColor: Colors.white),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(AppConst.PAGE_PADDING),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: SearchBar(
                hintText: "搜索话题",
                onChanged: (v) => controller.search(v),
                onSubmitted: (v) => controller.search(v),
                hintStyle: WidgetStateProperty.all(TextStyle(fontSize: 14)),
                leading: Icon(Icons.search, color: Color(0xffC4C4C4), size: 16),
                // 背景色
                backgroundColor: WidgetStateProperty.all(Color(0xffF5F7F9)),
                // 内边距
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 10),
                ),
                scrollPadding: EdgeInsets.zero,
                constraints: BoxConstraints(maxHeight: 32, minHeight: 32),
                elevation: WidgetStateProperty.all(0),
              ),
            ),
            Expanded(
              child: RefreshLoadmore(
                controller: controller.refreshController,
                onRefresh: () async {
                  await controller.listRefresh();
                },
                onLoad: () async {
                  await controller.loadMore();
                },
                child: Obx(() {
                  return ListView.builder(
                    itemCount: controller.listData.length,
                    itemBuilder: (context, index) {
                      var item = controller.listData[index];
                      return Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.TOPIC_DETAIL,
                              arguments: item.id,
                            );
                          },
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: item.image != null
                                ? Image.network(
                                    item.image!,
                                    width: 38,
                                    height: 38,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    width: 38,
                                    height: 38,
                                    color: Color(0xffF5F7F9),
                                  ),
                          ),
                          title: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  item.title ?? '',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              if (item.ishot == 1) _TopicItemLabel(label: '热'),
                              if (item.isnew == 1)
                                _TopicItemLabel(
                                  label: '新',
                                  color: Color(0xff75B6FF),
                                ),
                            ],
                          ),
                          subtitle: Text(
                            item.content ?? '',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          subtitleTextStyle: subStyle,
                          trailing: Text(
                            '${item.count ?? 0}条帖子',
                            style: subStyle,
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopicItemLabel extends StatelessWidget {
  final String? label;
  final Color? color;

  const _TopicItemLabel({super.key, this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      height: 15,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: color ?? Color(0xffFF7E33),
      ),
      child: Text(
        label ?? '',
        style: TextStyle(fontSize: 10, color: Colors.white, height: 1),
      ),
    );
  }
}
