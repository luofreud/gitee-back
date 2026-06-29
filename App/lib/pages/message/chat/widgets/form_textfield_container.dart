import 'dart:math';

import 'package:flutter/material.dart';

class FormTextfieldContainer extends StatelessWidget {
  final String? title;
  final String? hintText;
  final Color? color1;
  final Color? color2;
  final TextEditingController? controller;

  const FormTextfieldContainer({
    super.key,
    this.title,
    this.hintText,
    this.color1,
    this.color2,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    double _topBgWidth = (title?.length ?? 4) * 25;
    return ClipPath(
      clipper: _FormContainerClipper(width: _topBgWidth + 15),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 0.5],
            colors: [color1 ?? Color(0xff73C6F2), Colors.white],
          ),
        ),
        child: ClipPath(
          clipper: _FormContainerClipper(width: _topBgWidth),
          child: Container(
            padding: const EdgeInsets.only(
              top: 3,
              right: 1,
              left: 1,
              bottom: 1,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.9],
                colors: [color2 ?? Color(0xff2467F1), Colors.white],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 5,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Text(
                        title ?? '',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(4, -5),
                        child: CustomPaint(
                          size: Size(11, 11),
                          painter: _FourPointedStarPainter(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(12),
                        offset: Offset(0, 3),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller,
                    minLines: 5,
                    maxLines: 5,
                    maxLength: 100,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(
                        color: Color(0xffA8B2E6),
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.zero,
                      counterStyle: TextStyle(
                        color: Color(0xffA6A6A6),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 自定义裁剪器：实现文件夹右上角的“折角”效果
class _FormContainerClipper extends CustomClipper<Path> {
  final double? width;

  const _FormContainerClipper({this.width});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    final double startWidth = width ?? 120;
    path.lineTo(startWidth, 0);
    path.cubicTo(startWidth + 10, 0, startWidth + 20, 20, startWidth + 30, 20);
    path.lineTo(size.width - 10, 20);
    path.quadraticBezierTo(size.width, 20, size.width, 30);

    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(
      size.width,
      size.height + 10,
      size.width - 10,
      size.height + 10,
    ); // 右下角的曲线
    path.lineTo(10, size.height + 10);
    path.quadraticBezierTo(0, size.height + 10, 0, size.height); // 左下角的曲线

    path.lineTo(0, 10);
    path.quadraticBezierTo(0, 0, 10, 0); // 左下角的曲线
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

// 四脚星绘制逻辑
class _FourPointedStarPainter extends CustomPainter {
  final Color color;

  _FourPointedStarPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final innerRadius = outerRadius * 0.45; // 内凹半径（可调）

    // 定义四脚星的8个顶点（4个外顶点 + 4个内顶点）
    final path = Path();
    final angles = [
      0, // 右
      45, // 右下内
      90, // 下
      135, // 左下内
      180, // 左
      225, // 左上内
      270, // 上
      315, // 右上内
    ];

    for (int i = 0; i < angles.length; i++) {
      final radian = angles[i] * pi / 180;
      final radius = i % 2 == 0 ? outerRadius : innerRadius;
      final x = center.dx + radius * cos(radian);
      final y = center.dy + radius * sin(radian);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FourPointedStarPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
