import 'package:flutter/material.dart';

class UserTag extends StatelessWidget {
  final String title;
  final Widget? icon;
  final Color? color;
  final Gradient? gradient;
  final TextStyle? textStyle;
  final BoxBorder? border;
  final EdgeInsetsGeometry? padding;

  const UserTag({
    super.key,
    required this.title,
    this.icon,
    this.color,
    this.gradient,
    this.textStyle,
    this.border,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget _titleWidget = Text(
      title,
      style:
          textStyle ??
          TextStyle(
            fontSize: 12,
            color: color ?? Color(0xff337EFF),
            fontWeight: FontWeight.w600,
          ),
    );
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient:
            gradient ??
            const LinearGradient(
              colors: [Color(0xffE6E3FF), Color(0xffEAE8FF), Color(0xffC7DAFF)],
              stops: [0.0, 0.1, 1.0],
            ),
        border: border,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [?icon, _titleWidget],
      ),
    );
  }
}
