import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:freud/widgets/page_background.dart';
import 'package:get/get.dart';

import 'synastry_index_controller.dart';

class SynastryIndexPage extends GetView<SynastryIndexController> {
  const SynastryIndexPage({super.key});

  _buildUserContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 32.5,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(radius: 30),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 8,
                      child: IconWidget(icon: 'icon_change2.png', size: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text('我的名字'),
              Text(
                '日摩月射升水',
                style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
              ),
            ],
          ),
          Container(
            height: 65,
            alignment: Alignment.center,
            child: IconWidget(icon: 'icon_zx.png', width: 38, height: 31),
          ),
          Column(
            children: [
              Text(
                '0',
                style: TextStyle(fontSize: 32, color: Color(0xff8097FF)),
              ),
              Text(
                '契合度',
                style: TextStyle(fontSize: 12, color: Color(0xff808080)),
              ),
            ],
          ),
          Container(
            height: 65,
            alignment: Alignment.center,
            child: IconWidget(icon: 'icon_zx.png', width: 38, height: 31),
          ),
          CircleAvatar(
            radius: 32.5,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xffE8ECFF),
              child: Icon(Icons.add, size: 42, color: Color(0xffC7CEF0)),
            ),
          ),
        ],
      ),
    );
  }

  _buildExample() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            spacing: 10,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Transform.translate(
                    offset: Offset(0, -3),
                    child: IconWidget(
                      icon: 'icon_yh2.png',
                      width: 17,
                      height: 14,
                    ),
                  ),
                  Text(
                    '天作之合型情侣',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Transform.translate(
                    offset: Offset(0, -3),
                    child: Transform.scale(
                      scaleX: -1,
                      scaleY: -1,
                      child: IconWidget(
                        icon: 'icon_yh2.png',
                        width: 17,
                        height: 14,
                      ),
                    ),
                  ),
                ],
              ),
              Center(
                child: CustomPaint(
                  size: Size(double.infinity, 300),
                  painter: _ChartPainter(),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffF5F7F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 11,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(radius: 10),
                    ),
                    Transform.translate(
                      offset: Offset(-5, 0),
                      child: CircleAvatar(
                        radius: 11,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(radius: 10),
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(-10, 0),
                      child: CircleAvatar(
                        radius: 11,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(radius: 10),
                      ),
                    ),
                    Expanded(child: Text('咨询师在线，获取详细情感解析')),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Color(0xff696969),
                    ),
                  ],
                ),
              ),
              Row(
                spacing: 5,
                children: [
                  Icon(Icons.info, size: 16, color: Color(0xffA6A6A6)),
                  Expanded(
                    child: Text(
                      '当前内容为免费内容，仅供您在娱乐中探索自我，无任何现实指导意义。',
                      style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: Image.asset(
            'assets/images/example_tag.png',
            width: 56,
            height: 25,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SynastryIndexController());
    return PageBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Text('合盘'),
          backgroundColor: Colors.white.withAlpha(0),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
          child: Column(
            spacing: 10,
            children: [
              _buildUserContainer(),
              _buildExample(),
              GradientButton(
                onPressed: () {},
                width: double.infinity,
                height: 40,
                foregroundColor: Color(0xffFFD0A1),
                child: Text('邀请好友合盘'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  List<String> textList = ['玩乐', '羁绊', '默契', '碰撞', '激情'];
  List<num> scoreList = [85, 60, 90, 83.4, 70];

  _ChartPainter({
    this.textList = const ['玩乐', '羁绊', '默契', '碰撞', '激情'],
    this.scoreList = const [85, 60, 90, 83.4, 70],
  });

  List<Offset> _getVertices(Offset center, {double radius = 100}) {
    final int sides = 5; // 边数：5（固定为五边形）
    final double angleStep = 2 * pi / sides; // 相邻顶点的夹角：72°（弧度制，2π=360°）

    final List<Offset> vertices = []; // 存储5个顶点的数组

    for (int i = 0; i < sides; i++) {
      // 计算当前顶点的角度（从y轴正方向开始，逆时针旋转）
      final double angle = i * angleStep;
      // 极坐标转直角坐标，计算顶点x/y
      final double x = center.dx + radius * sin(angle);
      final double y = center.dy - radius * cos(angle);
      vertices.add(Offset(x, y)); // 将顶点加入数组
    }

    return vertices;
  }

  _drawBg(Canvas canvas, Offset center, double radius, {Color? color}) {
    // 画笔配置：可切换实心/描边，开启抗锯齿（必开，避免边缘锯齿）
    final Paint paint = Paint()
      ..color =
          color ??
          Color(0xffF5F7F9) // 主颜色（半透明）
      ..style = PaintingStyle
          .fill // 描边宽度（仅stroke模式有效）
      ..isAntiAlias = true; // 抗锯齿（关键，优化绘制效果）

    final vertices = _getVertices(center, radius: radius);

    // 3. 绘制正五边形：通过Path连接所有顶点并闭合
    final Path path = Path();
    if (vertices.isNotEmpty) {
      path.moveTo(vertices[0].dx, vertices[0].dy); // 移动画笔到第一个顶点
      // 依次连接剩余4个顶点
      for (int i = 1; i < vertices.length; i++) {
        path.lineTo(vertices[i].dx, vertices[i].dy);
      }
      path.close(); // 闭合路径（自动连接最后一个顶点和第一个顶点，形成封闭五边形）
    }

    // 4. 渲染路径：将正五边形绘制到画布
    canvas.drawPath(path, paint);
  }

  _drawLines(Canvas canvas, Offset center) {
    final Paint linePaint = Paint()
      ..color = Color(0xffD6DEFF)
      ..strokeWidth = 1;
    final vertices = _getVertices(center);
    if (vertices.isNotEmpty) {
      // 依次连接剩余4个顶点
      for (int i = 0; i < vertices.length; i++) {
        canvas.drawLine(center, vertices[i], linePaint);
      }
    }
  }

  _drawText(Canvas canvas, Offset center) {
    final vertices = _getVertices(center, radius: 130);

    for (int i = 0; i < vertices.length; i++) {
      final text = textList[i];
      // 将文字转成绘制的段落
      TextSpan textSpan = TextSpan(
        text: text,
        style: TextStyle(fontSize: 14, color: Color(0xff383838)),
        children: [
          TextSpan(
            text: '\n${scoreList[i]}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Color(0xff8097FF),
            ),
          ),
        ],
      );
      TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr, // 文字方向（从左到右）
        textAlign: TextAlign.center,
      );
      // 布局文字（计算绘制大小）
      textPainter.layout();
      // 绘制文字：定位在画布底部中心（居中对齐）

      textPainter.paint(canvas, vertices[i] - Offset(15, 15));
    }
  }

  _drawScore(Canvas canvas, Offset center) {
    final int sides = 5; // 边数：5（固定为五边形）
    final double angleStep = 2 * pi / sides; // 相邻顶点的夹角：72°（弧度制，2π=360°）

    final List<Offset> vertices = []; // 存储5个顶点的数组

    for (int i = 0; i < sides; i++) {
      final radius = scoreList[i];
      // 计算当前顶点的角度（从y轴正方向开始，逆时针旋转）
      final double angle = i * angleStep;
      // 极坐标转直角坐标，计算顶点x/y
      final double x = center.dx + radius * sin(angle);
      final double y = center.dy - radius * cos(angle);
      vertices.add(Offset(x, y)); // 将顶点加入数组
    }

    // 画笔配置：可切换实心/描边，开启抗锯齿（必开，避免边缘锯齿）
    final Paint paint = Paint()
      ..color =
          Color(0xff8097FF) // 主颜色（半透明）
      ..style = PaintingStyle
          .fill // 描边宽度（仅stroke模式有效）
      ..isAntiAlias = true; // 抗锯齿（关键，优化绘制效果）
    // 3. 绘制正五边形：通过Path连接所有顶点并闭合
    final Path path = Path();
    if (vertices.isNotEmpty) {
      path.moveTo(vertices[0].dx, vertices[0].dy); // 移动画笔到第一个顶点
      // 依次连接剩余4个顶点
      for (int i = 1; i < vertices.length; i++) {
        path.lineTo(vertices[i].dx, vertices[i].dy);
      }
      path.close(); // 闭合路径（自动连接最后一个顶点和第一个顶点，形成封闭五边形）
    }

    // 4. 渲染路径：将正五边形绘制到画布
    canvas.drawPath(path, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    // 1. 基础配置：画布中心、外接圆半径、画笔
    final Offset center = Offset(
      size.width / 2,
      size.height / 2,
    ); // 画布中心（正五边形中心）
    _drawBg(canvas, center, 100);
    _drawBg(canvas, center, 80, color: Color(0xffe6e6e6));

    _drawLines(canvas, center);

    _drawText(canvas, center);

    _drawScore(canvas, center);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
