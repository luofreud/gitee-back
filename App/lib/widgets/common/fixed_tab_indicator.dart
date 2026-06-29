import 'package:flutter/material.dart';

class FixedTabIndicator extends Decoration {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  final BorderSide borderSide;

  final EdgeInsetsGeometry insets;

  const FixedTabIndicator({
    this.width = double.infinity,
    this.height = 3,
    this.borderRadius,
    this.borderSide = const BorderSide(width: 2.0, color: Colors.white),
    this.insets = EdgeInsets.zero,
  });

  Rect _indicatorRectFor(Rect rect, TextDirection textDirection) {
    final Rect indicator = insets.resolve(textDirection).deflateRect(rect);
    return Rect.fromLTWH(
      indicator.left + (indicator.width / 2) - width / 2,
      indicator.bottom - borderSide.width,
      width,
      borderSide.width,
    );
  }

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _FixedTabIndicatorPainter(this, borderRadius);
  }
}

class _FixedTabIndicatorPainter extends BoxPainter {
  final FixedTabIndicator decoration;
  final BorderRadius? borderRadius;

  _FixedTabIndicatorPainter(this.decoration, this.borderRadius);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection textDirection = configuration.textDirection!;
    final Paint paint;
    if (borderRadius != null) {
      paint = Paint()..color = decoration.borderSide.color;
      final Rect indicator = decoration._indicatorRectFor(rect, textDirection);
      final RRect rrect = RRect.fromRectAndCorners(
        indicator,
        topLeft: borderRadius!.topLeft,
        topRight: borderRadius!.topRight,
        bottomRight: borderRadius!.bottomRight,
        bottomLeft: borderRadius!.bottomLeft,
      );
      canvas.drawRRect(rrect, paint);
    } else {
      paint = decoration.borderSide.toPaint()..strokeCap = StrokeCap.square;
      final Rect indicator = decoration
          ._indicatorRectFor(rect, textDirection)
          .deflate(decoration.borderSide.width / 2.0);
      canvas.drawLine(indicator.bottomLeft, indicator.bottomRight, paint);
    }

    // final centerX = offset.dx + cfg.size!.width / 2;
    // final rect = Rect.fromLTWH(
    //   centerX - indicator.width / 2,
    //   cfg.size!.height - indicator.height,
    //   indicator.width,
    //   indicator.height,
    // );
    // canvas.drawRect(rect, Paint()..color = indicator.color);
  }
}
