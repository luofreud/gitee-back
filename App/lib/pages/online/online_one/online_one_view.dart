import 'package:flutter/material.dart';
import 'package:freud/widgets/common/list_filter_overlay.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import '../../../widgets/component/tutor_item.dart';
import '../../../widgets/empty_tips.dart';
import '../../../widgets/refresh_loadmore.dart';
import 'online_one_controller.dart';

class OnlineOnePage extends GetView<OnlineOneController> {
  const OnlineOnePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => OnlineOneController());
    return Stack(
      children: [
        Column(
          children: [
            _OnlineFilterWidget(),
            Expanded(
              child: Obx(() {
                if (controller.listData.isEmpty) {
                  return Center(
                    child: controller.isLoading.value
                        ? CircularProgressIndicator()
                        : EmptyTips(title: '暂无数据'),
                  );
                }
                return RefreshLoadmore(
                  controller: controller.refreshController,
                  onRefresh: () async {
                    await controller.listRefresh();
                  },
                  onLoad: () async {
                    await controller.loadMore();
                  },
                  child: Obx(
                    () => ListView.separated(
                      padding: const EdgeInsets.only(
                        left: AppConst.PAGE_PADDING,
                        right: AppConst.PAGE_PADDING,
                        bottom: AppConst.PAGE_PADDING,
                      ),
                      itemCount: controller.listData.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10);
                      },
                      itemBuilder: (context, index) {
                        return TutorItem(teacher: controller.listData[index]);
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        Positioned(
          left: AppConst.PAGE_PADDING,
          right: AppConst.PAGE_PADDING,
          bottom: 10,
          child: Image.asset('assets/example/online_ad2.png', fit: BoxFit.fill),
        ),
      ],
    );
  }
}

class _OnlineFilterWidget extends StatelessWidget {
  const _OnlineFilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    OnlineOneController controller = Get.find();
    return Container(
      height: 36,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: AppConst.PAGE_PADDING),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              controller.filterActiveKey.value = 'order';
              ListFilterOverlay.showFilterOverlay(
                context: context,
                values: controller.filterOrder,
                value: controller.filterQuery["order"],
                onTap: (value) {
                  controller.setFilter("order", value);
                },
                onClose: () {
                  controller.filterActiveKey.value = "";
                },
              );
            },
            child: Obx(() {
              bool isActive = controller.filterActiveKey.value == "order";
              var item = controller.filterOrder.firstWhere(
                (item) => item["key"] == controller.filterQuery["order"],
              );
              return Row(
                children: [
                  Text(
                    item["title"].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: isActive ? Color(0xff4B65CC) : Color(0xff383838),
                    ),
                  ),
                  Icon(
                    isActive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: isActive ? Color(0xff4B65CC) : Color(0xffDBDBDB),
                    size: 20,
                  ),
                ],
              );
            }),
          ),
          Expanded(
            child: Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.end,
              children: controller.filterList.map((item) {
                return GestureDetector(
                  onTap: () {
                    controller.filterActiveKey.value = item["key"];
                    ListFilterOverlay.showFilterOverlay(
                      context: context,
                      padding: EdgeInsets.only(
                        left: AppConst.PAGE_PADDING,
                        right: AppConst.PAGE_PADDING,
                        bottom: AppConst.PAGE_PADDING,
                        top: 10,
                      ),
                      values: item["values"],
                      value: controller.filterQuery[item["key"]],
                      onTap: (value) {
                        controller.setFilter(item["key"], value);
                      },
                      onClose: () {
                        controller.filterActiveKey.value = "";
                      },
                    );
                  },
                  child: Obx(() {
                    bool isActive =
                        controller.filterActiveKey.value == item["key"];
                    return Row(
                      children: [
                        Text(
                          item["title"],
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isActive
                                ? Color(0xff4B65CC)
                                : Color(0xff383838),
                          ),
                        ),
                        Icon(
                          isActive
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          color: isActive
                              ? Color(0xff4B65CC)
                              : Color(0xffDBDBDB),
                          size: 20,
                        ),
                      ],
                    );
                  }),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
