import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/widgets/page_background.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

import 'revenue_datepicker.dart';
import 'revenue_index_controller.dart';

class RevenueIndexPage extends GetView<RevenueIndexController> {
  const RevenueIndexPage({super.key});

  /// 构建收益类型选择容器
  ///
  /// 创建顶部横向滚动的收益类型选择器，支持点击切换不同的收益类型。
  /// 容器背景使用预设图片，并根据 AppBar 高度和状态栏高度设置顶部间距，
  /// 确保内容不会被 AppBar 遮挡。
  ///
  /// 每个类型项采用白色卡片样式，选中时文字颜色加深以突出显示。
  ///
  /// [context] 构建上下文
  ///
  /// Returns: 收益类型选择容器 Widget
  _buildTypeContainer(context) {
    // 计算 AppBar 和状态栏的总高度，用于设置容器顶部间距
    final appBarHeight =
        AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(
        left: AppConst.PAGE_PADDING,
        right: AppConst.PAGE_PADDING,
        top: appBarHeight,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/page_bg.png'),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: controller.revenueTypes.map((item) {
            return GestureDetector(
              onTap: () {
                controller.onTypeChange(item);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                margin: EdgeInsets.only(right: 10),
                child: Obx(() {
                  // 根据选中状态动态切换文字颜色
                  return Text(
                    item,
                    style: TextStyle(
                      color: controller.typeStr == item
                          ? Color(0xff383838)
                          : Color(0xff808080),
                    ),
                  );
                }),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  /// 构建列表项 Widget
  ///
  /// 根据索引位置构建收益列表中的单个项目，支持两种类型的展示：
  /// - 月份标题项：显示月份和该月的总收入
  /// - 详细记录项：显示具体的收益记录，包含图标、标题、时间和收益金额
  ///
  /// 对于详细记录项，会根据其在列表中的位置自动处理圆角和分隔线：
  /// - 每组的第一项顶部为圆角
  /// - 每组的最后一项底部为圆角且无分隔线
  /// - 中间项显示底部分隔线
  ///
  /// [index] 列表数据索引
  ///
  /// Returns: 渲染后的列表项 Widget
  Widget _buildListItem(context, int index) {
    var item = controller.listData[index];
    // 处理月份标题项的展示
    if (item["type"] == "month") {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                var result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return RevenueDatePicker(
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                      onConfirm: (type, values) {
                        Navigator.of(context).pop(values);
                      },
                    );
                  },
                );
                print(result);
              },
              child: Text('${item["data"]["month"]}'),
            ),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Color(0xff808080),
              ),
            ),
            const Spacer(),
            Text(
              '收入 ${item["data"]["total"]}星钻',
              style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
            ),
          ],
        ),
      );
    }
    // 判断当前项是否为组内第一项
    bool isFirst = false;
    // 判断当前项是否为组内最后一项
    bool isLast = index == controller.listData.length - 1;
    if (index == 0 || controller.listData[index - 1]["type"] == "month") {
      isFirst = true;
    }

    if (index < controller.listData.length - 1) {
      if (controller.listData[index + 1]["type"] == "month") {
        isLast = true;
      }
    }

    // 构建详细记录项的基础 Widget
    var itemWidget = ListTile(
      leading: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: Color(0xffD1D1D1),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: isFirst ? Radius.circular(10) : Radius.zero,
          bottom: isLast ? Radius.circular(10) : Radius.zero,
        ),
      ),
      tileColor: Colors.white,
      title: Text('问答 - 星盘', style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(
        '1 月 1 号  12:00',
        style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
      ),
      trailing: Text(
        '+ 160',
        style: TextStyle(fontSize: 18, color: Color(0xff8097FF)),
      ),
    );
    // 组内最后一项直接返回，不添加分隔线
    if (isLast) {
      return itemWidget;
    }
    // 非最后一项添加底部分隔线
    return Column(
      children: [
        itemWidget,
        Container(
          color: Colors.white,
          child: Divider(
            color: Color(0xffF2F2F2),
            height: 1,
            indent: 60,
            endIndent: 10,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RevenueIndexController());

    return PageBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Text('我的收益'),
          backgroundColor: Colors.white.withAlpha(0),
          actions: [
            TextButton(
              onPressed: () {
                Get.toNamed(AppRoutes.COUNSELOR_REVENUE_INCOME);
              },
              style: TextButton.styleFrom(
                foregroundColor: Color(0xff383838),
                overlayColor: Colors.transparent,
              ),
              child: Text('去提现'),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            _buildTypeContainer(context),
            Expanded(
              child: RefreshLoadmore(
                controller: controller.refreshController,
                headerSafeArea: false,
                onRefresh: () async {
                  await controller.listRefresh();
                },
                onLoad: () async {
                  await controller.loadMore();
                },
                child: Obx(() {
                  return ListView.builder(
                    itemCount: controller.listData.length,
                    padding: EdgeInsets.only(
                      left: AppConst.PAGE_PADDING,
                      right: AppConst.PAGE_PADDING,
                    ),
                    itemBuilder: (context, index) {
                      return _buildListItem(context, index);
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
