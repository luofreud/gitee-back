import 'package:flutter/material.dart';

class EmptyTips extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final AlignmentGeometry? alignment;
  final Widget? leading;
  final Widget? child;
  final double? spacing;
  final String? image;

  const EmptyTips({
    super.key,
    this.title,
    this.subTitle,
    this.alignment,
    this.leading,
    this.spacing,
    this.child,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment ?? Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: spacing ?? 3,
        children: [
          if (leading != null) leading!,
          if (leading == null)
            Image.asset(
              image ?? 'assets/images/empty_record.png',
              width: 160,
              height: 160,
            ),
          if (title != null && title!.isNotEmpty)
            Text(title ?? '暂无数据', style: TextStyle(fontSize: 12)),
          Text(
            subTitle ?? '',
            style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
