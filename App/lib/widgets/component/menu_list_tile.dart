import 'package:flutter/material.dart';

///菜单列表项
class MenuListTile extends StatelessWidget {
  final String? title;
  final String? titlevalue;
  final Color? titleColor;
  final Widget? subtitle;
  final Widget? child;
  final Widget? trailing;
  final Function()? onTap;
  final double? radius;
  final RadiusPosition? radiusPosition;
  final TextAlign? textAlign;
  final bool? showArrow;
  final Color? tileColor;
  final EdgeInsetsGeometry? contentPadding;

  const MenuListTile({
    super.key,
    this.title,
    this.titlevalue,
    this.titleColor,
    this.subtitle,
    this.child,
    this.trailing,
    this.onTap,
    this.radius,
    this.radiusPosition,
    this.textAlign,
    this.showArrow,
    this.tileColor,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    ShapeBorder? _shape;
    Radius _radius = Radius.circular(radius ?? 10);
    switch (radiusPosition) {
      case RadiusPosition.top:
        _shape = RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: _radius),
        );
        break;
      case RadiusPosition.bottom:
        _shape = RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: _radius),
        );
        break;
      case RadiusPosition.both:
        _shape = RoundedRectangleBorder(
          borderRadius: BorderRadius.all(_radius),
        );
        break;
      default:
        _shape = RoundedRectangleBorder();
        break;
    }

    Widget? _title;
    if (child != null) {
      _title = child;
    } else {
      _title = Text(
        title ?? '',
        style: TextStyle(fontSize: 14, color: titleColor),
      );
    }
    return Material(
      color: Colors.transparent,
      child: ListTile(
        title: Row(
          spacing: 3,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_title != null) _title,
            const SizedBox(width: 5),
            Expanded(
              child: titlevalue != null
                  ? Text(
                      titlevalue!,
                      style: TextStyle(fontSize: 14, height: 1),
                      textAlign: textAlign ?? TextAlign.end,
                    )
                  : const SizedBox.shrink(),
            ),
            if (trailing != null) trailing!,
            if (showArrow != false)
              Image.asset(
                'assets/icons/icon_arrow_right.png',
                width: 16,
                height: 16,
              ),
          ],
        ),
        subtitle: subtitle,
        tileColor: tileColor ?? Colors.white,
        dense: true,
        contentPadding:
            contentPadding ??
            const EdgeInsets.only(left: 12, right: 14, top: 5, bottom: 5),
        shape: _shape,
        onTap: onTap,
      ),
    );
  }
}

enum RadiusPosition { top, bottom, both, none }
