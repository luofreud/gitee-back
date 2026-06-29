import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import 'counselor_guide_controller.dart';

///
/// 咨询师首页
/// 引导注册咨询师和咨询师相关说明
///
class CounselorGuidePage extends GetView<CounselorGuideController> {
  const CounselorGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CounselorGuideController());
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: GetBuilder<CounselorGuideController>(
          builder: (CounselorGuideController home) {
            return Obx(
              () => AppBar(
                title: const Text('咨询师入驻'),
                backgroundColor: Colors.white.withAlpha(home.appBarAlpha.value),
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        controller: controller.scrollController,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: AppConst.PAGE_PADDING),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/counselor_index_top.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
            color: Color(0xfffecbfd),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 12,
            children: [
              SizedBox(height: MediaQuery.of(context).size.width * 0.8),
              _CardContainerWidget(
                title: '宝瓶星座*',
                children: [
                  Padding(
                    padding: const EdgeInsetsGeometry.only(top: 10),
                    child: Text(
                      '每日有百万星座爱好者在线沟通，汇集了上万星座方面心理咨询师实时在线语音一对一专业服务;提供了多种专业星座分析、等测试工具帮助每个人在线疏导心理情绪、感情危机，让人更好的认知自我更快乐自信地生活。如果您拥有相关专业知识，并乐于帮助他人，那么欢迎你加入宝瓶星座，成为宝瓶星座咨询师~',
                      style: TextStyle(fontSize: 12, height: 1.6),
                    ),
                  ),
                ],
              ),
              _CardContainerWidget(
                title: '成为宝瓶星座咨询师*',
                children: [
                  Text(
                    '能给你带来什么？',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff575ee6),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _DaiLaiItemWidget(
                    title: '这是一份有着高自由度、收入还不错的工作',
                    subTitle: '#高额收入#',
                  ),
                  const SizedBox(height: 10),
                  _DaiLaiItemWidget(
                    title: '这是一份有着高自由度、收入还不错的工作',
                    subTitle: '#高额收入#',
                  ),
                  const SizedBox(height: 10),
                  _DaiLaiItemWidget(
                    title: '这是一份有着高自由度、收入还不错的工作',
                    subTitle: '#高额收入#',
                  ),
                ],
              ),
              _CardContainerWidget(
                title: '成为咨询师有什么要求？*',
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('& 专业能力', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 10, top: 5),
                    child: DefaultTextStyle(
                      style: TextStyle(color: Color(0xff545454)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 3,
                        children: [
                          Text('·满足18岁成年，'),
                          Text('·至少会2种以上推运方式，'),
                          Text('·具备心理、星盘、Tarot、星骰等相关的专业知识及相应证书，'),
                          Text('·能配合平台的活动，'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('& 倾听与沟通能力', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 10, top: 5),
                    child: DefaultTextStyle(
                      style: TextStyle(color: Color(0xff545454)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 3,
                        children: [Text('·有良好倾听和语言表达能力，尊重每一位来访者，和来访者有高度的认同感!')],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('& 正确价值观和卓越服务意识', style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 10, top: 5),
                    child: DefaultTextStyle(
                      style: TextStyle(color: Color(0xff545454)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 3,
                        children: [
                          Text('·不攻击、不诋毁、不评价、不嘲讽，善待包容每一位来访者，'),
                          Text('·真诚、善良、正能量、积极向上发自内心的去帮助    每一位有困惑的来访者。'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              _CardContainerWidget(
                title: '申请咨询师流程',
                children: [
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ProcessItemWidget(title: '01', subTitle: '实名认证'),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Color(0xffFDAAF9),
                      ),
                      _ProcessItemWidget(title: '02', subTitle: '答题认证'),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Color(0xffFDAAF9),
                      ),
                      _ProcessItemWidget(title: '03', subTitle: '签约完成'),
                    ],
                  ),
                ],
              ),
              _CardContainerWidget(title: '申请流程指南', children: []),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('如有疑惑不清楚的可以联系'),
                  GestureDetector(
                    child: Text(
                      '客服咨询',
                      style: TextStyle(color: Color(0xff5A00D9)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Transform.scale(
                scale:
                    MediaQuery.of(context).size.width /
                    (MediaQuery.of(context).size.width -
                        AppConst.PAGE_PADDING * 2),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(AppRoutes.COUNSELOR_REG);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 68,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xffEEEFFC), Color(0xffA0D0FE)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '立即入驻',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBgWidget extends StatelessWidget {
  const _TitleBgWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (container, box) {
        return CustomPaint(
          size: Size(box.maxWidth, 20),
          painter: _CurveGradientPainter(),
        );
      },
    );
    // return CustomPaint(size: Size(240, 20), painter: CurveGradientPainter());
  }
}

// 通用 SVG 路径解析工具类（纯原生，无第三方依赖）
class SvgPathParser {
  /// 将 SVG path 的 d 字符串解析为 Flutter Path 对象
  /// [svgPathData]：SVG 路径的 d 属性字符串（如 "M0,100 Q75,50 150,100 T300,100 Z"）
  static Path parseSvgPath(String svgPathData, Size size) {
    Path path = Path();
    if (svgPathData.isEmpty) return path;

    // 1. 预处理：替换逗号为空格，去除多余空格，拆分为指令+参数列表
    final RegExp regExp = RegExp(r'([MLQCSTZAmlqcstza])|([+-]?\d*\.?\d+)');
    final Iterable<Match> matches = regExp.allMatches(svgPathData);

    // 提取所有匹配项（指令 + 数字）
    final List<String> tokens = matches.map((m) => m.group(0)!).toList();
    if (tokens.isEmpty) return path;

    int index = 0;
    // 记录上一个贝塞尔控制点，用于处理 T/S 平滑指令
    double lastControlX = 0, lastControlY = 0;
    // 记录上一个终点，用于计算相对坐标/平滑指令
    double lastX = 0, lastY = 0;

    while (index < tokens.length) {
      String command = tokens[index];
      index++;

      // 2. 解析各指令对应的参数并调用 Path 方法
      switch (command.toUpperCase()) {
        // 移动到起点 (M/m)
        case 'M':
          double x = _parseDouble(tokens, index++, width: size.width);
          double y = _parseDouble(tokens, index++);
          path.moveTo(x, y);
          lastX = x;
          lastY = y;
          break;

        // 直线到目标点 (L/l)
        case 'L':
          double x = _parseDouble(tokens, index++, width: size.width);
          double y = _parseDouble(tokens, index++);
          path.lineTo(x, y);
          lastX = x;
          lastY = y;
          break;

        // 二次贝塞尔曲线 (Q/q)：控制点(x1,y1) → 终点(x2,y2)
        case 'Q':
          double x1 = _parseDouble(tokens, index++, width: size.width);
          double y1 = _parseDouble(tokens, index++);
          double x2 = _parseDouble(tokens, index++, width: size.width);
          double y2 = _parseDouble(tokens, index++);
          path.quadraticBezierTo(x1, y1, x2, y2);
          lastControlX = x1;
          lastControlY = y1;
          lastX = x2;
          lastY = y2;
          break;

        // 平滑二次贝塞尔 (T/t)：复用前一个控制点的镜像 → 终点(x,y)
        case 'T':
          double x = _parseDouble(tokens, index++, width: size.width);
          double y = _parseDouble(tokens, index++);
          // 计算镜像控制点：以上一个终点为中心，镜像前一个控制点
          double mirrorX = lastX * 2 - lastControlX;
          double mirrorY = lastY * 2 - lastControlY;
          path.quadraticBezierTo(mirrorX, mirrorY, x, y);
          lastControlX = mirrorX;
          lastControlY = mirrorY;
          lastX = x;
          lastY = y;
          break;

        // 三次贝塞尔曲线 (C/c)：控制点1(x1,y1) → 控制点2(x2,y2) → 终点(x3,y3)
        case 'C':
          double x1 = _parseDouble(tokens, index++, width: size.width);
          double y1 = _parseDouble(tokens, index++);
          double x2 = _parseDouble(tokens, index++, width: size.width);
          double y2 = _parseDouble(tokens, index++);
          double x3 = _parseDouble(tokens, index++, width: size.width);
          double y3 = _parseDouble(tokens, index++);
          path.cubicTo(x1, y1, x2, y2, x3, y3);
          lastControlX = x2;
          lastControlY = y2;
          lastX = x3;
          lastY = y3;
          break;

        // 闭合路径 (Z/z)
        case 'Z':
          path.close();
          break;

        // 忽略不支持的指令（可根据需要扩展）
        default:
          print('暂不支持的 SVG 路径指令：$command');
          break;
      }
    }

    return path;
  }

  /// 安全解析 double 类型参数
  static double _parseDouble(List<String> tokens, int index, {double? width}) {
    if (index >= tokens.length) return 0.0;
    if (width != null && width > 0) {
      var newX = double.tryParse(tokens[index]) ?? 0.0;
      return newX / 138 * width;
    }
    return double.tryParse(tokens[index]) ?? 0.0;
  }
}

class _CurveGradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 1. 替换成你自己的 SVG path 数据（从 SVG 文件中提取的 d 属性值）
    // 示例曲线：一条简单的波浪曲线，你可以替换成自己的路径
    const svgPathData =
        "M 2.2481 23.6084 C 16.6753 16.3437 49.2935 1.8143 45.5299 11.8731 C 41.7662 21.9319 55.5662 18.0202 64.348 13.5496 C 73.1299 9.079 98.2208 -1.5387 90.6935 13.5496 C 83.1662 28.6378 123.124 11.8172 140.248 4.6084";

    // 2. 解析 SVG 路径为 Flutter Path 对象
    Path curvePath = SvgPathParser.parseSvgPath(svgPathData, size);

    // 4. 创建渐变画笔
    Paint gradientPaint = Paint()
      ..style = PaintingStyle
          .stroke // 填充模式（区别于描边）
      ..strokeWidth = 6
      ..shader =
          LinearGradient(
            // 渐变颜色（可自定义）
            colors: [
              Colors.white.withAlpha(0),
              Color(0xFF95F8FA),
              Color(0xFFfc8fed),
              Color(0xFFfbf268),
              Colors.white.withAlpha(0),
            ],
            // 渐变位置（0.0-1.0，可选）
            stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
            // 渐变方向（可选，默认从上到下）
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(
            // 渐变范围：覆盖整个画布
            Rect.fromLTWH(0, 0, size.width, size.height),
          );

    canvas.drawPath(curvePath, gradientPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // 路径和渐变不变时，不需要重绘
    return false;
  }
}

class _CardContainerWidget extends StatelessWidget {
  final String? title;
  final List<Widget>? children;

  const _CardContainerWidget({super.key, this.title, this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(left: 0, right: 0, child: _TitleBgWidget()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  title ?? '',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),

          ...?children,
        ],
      ),
    );
  }
}

class _DaiLaiItemWidget extends StatelessWidget {
  final String? title;
  final String? subTitle;

  const _DaiLaiItemWidget({super.key, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Color(0xffffd4f6), Color(0xfffef5fd)],
        ),
      ),
      child: Row(
        spacing: 20,
        children: [
          Expanded(
            child: Text(
              title ?? '',
              style: TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
          Text(
            subTitle ?? '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xffff6363),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessItemWidget extends StatelessWidget {
  final String? title;
  final String? subTitle;

  const _ProcessItemWidget({super.key, this.title, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xfffdeffe),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '#',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffFADCF7),
                  ),
                ),
                Text(
                  title ?? '',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffFDAAF9),
                  ),
                ),
                Text(
                  '#',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffFADCF7),
                  ),
                ),
              ],
            ),
            Text(
              subTitle ?? '',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
