import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/widgets/refresh_loadmore.dart';
import 'package:get/get.dart';

import 'coupon_list_controller.dart';

class CouponListPage extends GetView<CouponListController> {
  const CouponListPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CouponListController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的优惠券（1）'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: controller.tabController,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              dividerHeight: 0,
              // tabAlignment: TabAlignment.start,
              unselectedLabelColor: Color(0xff7986B0),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
              labelColor: Colors.black,
              labelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Color(0Xff4D1FAE), width: 3),
                borderRadius: BorderRadius.circular(4),
                insets: EdgeInsets.all(5),
              ),
              tabs: controller.couponTypes.map((item) {
                return Tab(text: item);
              }).toList(),
            ),
          ),
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: AppConst.PAGE_PADDING,
              vertical: 10,
            ),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              spacing: 8,
              children: controller.couponUseTypes.asMap().entries.map((item) {
                final index = item.key;
                final data = item.value;
                return Expanded(
                  child: Obx(() {
                    return GestureDetector(
                      onTap: () {
                        controller.useTypeIndex.value = index;
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 7,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: controller.useTypeIndex == index
                              ? Colors.white
                              : Color(0xffF5F5F5),
                          borderRadius: BorderRadius.circular(20),
                          border: controller.useTypeIndex == index
                              ? Border.all(color: Color(0xff949AE0), width: 1)
                              : null,
                        ),
                        child: Text(
                          data,
                          style: TextStyle(
                            color: controller.useTypeIndex == index
                                ? Color(0xff949AE0)
                                : Color(0xff808080),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: RefreshLoadmore(
              onLoad: () async {
                await controller.loadMore();
              },
              controller: controller.refreshController,
              child: Obx(() {
                return ListView.separated(
                  itemCount: controller.listData.length,
                  padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
                  separatorBuilder: (_, index) {
                    return SizedBox(height: 10);
                  },
                  itemBuilder: (_, index) {
                    if (index > 2) {
                      return ColorFiltered(
                        // 灰度转换矩阵（固定写法，直接复制使用）
                        colorFilter: const ColorFilter.matrix(<double>[
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0.2126,
                          0.7152,
                          0.0722,
                          0,
                          0,
                          0,
                          0,
                          0,
                          0.75,
                          0,
                        ]),
                        // 原页面内容（Scaffold 及所有子组件）
                        child: _CouponItem(index: index),
                      );
                    }
                    return _CouponItem(index: index);
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _CouponItem extends StatelessWidget {
  final int index;

  _CouponItem({super.key, required this.index});

  final double _leftWidth = 104;

  final Widget _newUserWidget = Positioned(
    top: 0,
    right: 0,
    child: Stack(
      children: [
        ClipPath(
          clipper: _TriangleClipper(),
          child: Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffFF7926), Color(0xffEF311F)],
                stops: [0, 0.5],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        Positioned(
          left: 10,
          top: 7,
          child: Transform.rotate(
            angle: 45 * pi / 180,
            child: Text(
              '新用户',
              style: TextStyle(fontSize: 9, color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildCouponType() {
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: _leftWidth - 10,
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xffFBE3DE), Color(0xffFFFBFA)],
            stops: [0, 0.6],
          ),
        ),
        child: Text(
          '问答券',
          style: TextStyle(fontSize: 12, color: Color(0xffEF311F)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: _CircleClipper(left: _leftWidth),
                child: Row(
                  children: [
                    Container(
                      width: _leftWidth,
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Color(0xffFFFBFA)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '免费',
                            style: TextStyle(
                              fontSize: 24,
                              color: Color(0xffEF311F),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '满任意金额可用',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xffEA7A74),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(color: Colors.white),
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                spacing: 6,
                                children: [
                                  Text(
                                    '免费问答券',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '有效期至2025/12/15  23:32',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xffA6A6A6),
                                    ),
                                  ),
                                  Text(
                                    '使用说明 >',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xffA6A6A6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            OutlinedButton(
                              onPressed: index > 2 ? null : () {},

                              style: OutlinedButton.styleFrom(
                                side: index > 2
                                    ? BorderSide.none
                                    : BorderSide(color: Color(0xffEF311F)),
                                foregroundColor: Color(0xffEF311F),
                                disabledBackgroundColor: Color(0xffF5F7F9),
                                padding: EdgeInsets.zero,
                                maximumSize: Size(64, 30),
                                minimumSize: Size(64, 30),
                              ),
                              child: Text(
                                index > 2 ? '已过期' : '去使用',
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (index == 1)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: Color(0xffFAFAFA)),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(
                    '1、满任意金额都可使用。\n2、仅限快问中智慧牌、骰子、星盘使用。',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xffA6A6A6),
                      height: 1.6,
                    ),
                  ),
                ),
            ],
          ),
          _buildCouponType(),
          _newUserWidget,
          if (index == 1)
            Positioned(
              left: _leftWidth - 8,
              top: 100 - 8,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Color(0xffFAFAFA),
              ),
            ),
        ],
      ),
    );
  }
}

// 自定义裁剪器：裁剪三角形
class _TriangleClipper extends CustomClipper<Path> {
  const _TriangleClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// 自定义裁剪器：裁剪圆形
class _CircleClipper extends CustomClipper<Path> {
  final double left;

  const _CircleClipper({this.left = 0});

  @override
  Path getClip(Size size) {
    // 1. 构建路径A：被裁剪的组件形状（这里是与容器一致的矩形）
    final pathA = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // 2. 构建路径B：裁剪模板形状（这里是居中的圆形）
    final pathB = Path()
      ..addOval(Rect.fromCircle(center: Offset(left, 0), radius: 8))
      ..addOval(Rect.fromCircle(center: Offset(left, size.height), radius: 8));

    // 3. 执行差运算：pathA - pathB（保留矩形中不与圆形重叠的部分）
    final resultPath = Path.combine(
      PathOperation.difference, // 差运算核心配置
      pathA,
      pathB,
    );

    return resultPath;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
