import 'package:flutter/cupertino.dart';

class IconWidget extends StatelessWidget {
  final String icon;
  final double? size;
  final double? width;
  final double? height;
  final Color? color;

  const IconWidget({
    super.key,
    required this.icon,
    this.size,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/icons/$icon',
      width: size ?? width,
      height: size ?? height,
      color: color,
    );
  }
}
