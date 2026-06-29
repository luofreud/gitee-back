import 'package:flutter/material.dart';

/// 圆形复选框
class CircleCheckbox extends StatelessWidget {
  final bool? value;
  final Function(bool?)? onChanged;
  final Color? fillColor;
  final Color? checkColor;
  final BorderSide? side;
  final Widget? child;

  const CircleCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.fillColor,
    this.checkColor,
    this.side,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget checkbox = Stack(
      alignment: Alignment.center,
      children: [
        Checkbox(
          value: value,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: const CircleBorder(),
          side: side ?? BorderSide.none,
          // 缩小点击区域
          visualDensity: VisualDensity(
            horizontal: VisualDensity.minimumDensity, // 水平间距最小
            vertical: VisualDensity.minimumDensity, // 垂直间距最小
          ),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return checkColor ?? Color(0xff43CF7C);
            }
            return fillColor ?? Color(0xffDBDBDB);
          }),
          checkColor: Colors.transparent,
          onChanged: onChanged,
        ),
        if (value == true)
          GestureDetector(
            onTap: () {
              onChanged?.call(value == true ? false : true);
            },
            child: Icon(Icons.check, size: 14, color: Colors.white),
          ),
      ],
    );

    if (child != null) {
      return Row(
        children: [
          checkbox,
          GestureDetector(
            onTap: () {
              onChanged?.call(value == true ? false : true);
            },
            child: child!,
          ),
        ],
      );
    }
    return checkbox;
  }
}
