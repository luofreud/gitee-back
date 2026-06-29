import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  final double height; // 整个组件的高度
  final double thickness; // 虚线的粗细
  final Color? color; // 颜色
  final List<double> dashPattern; // 虚线模式，如 [5,5]

  const DashedDivider({
    this.height = 16,
    this.thickness = 1,
    this.color,
    this.dashPattern = const [5, 5],
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CustomPaint(
        painter: _DashedLinePainter(
          color: color ?? Theme.of(context).colorScheme.outline,
          thickness: thickness,
          dashPattern: dashPattern,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  final double thickness;
  final List<double> dashPattern;

  _DashedLinePainter({
    required this.color,
    required this.thickness,
    required this.dashPattern,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = thickness
          ..style = PaintingStyle.stroke;

    // 在垂直方向居中绘制水平线
    final y = size.height / 2;

    var dashWidth = dashPattern.isNotEmpty ? dashPattern[0] : 5;
    var dashSpace = dashPattern.length > 1 ? dashPattern[1] : 5;
    double startX = 0;
    final space = (dashSpace + dashWidth);

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashWidth, y), paint);
      startX += space;
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) => false;
}
