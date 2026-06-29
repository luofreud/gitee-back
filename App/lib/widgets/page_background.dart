import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';

class PageBackground extends StatelessWidget {
  final Widget? child;

  const PageBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/page_bg.png"),
          fit: BoxFit.fitWidth, // 图片填充方式
          alignment: Alignment.topCenter,
        ),
        color: AppConst.PAGE_BACKGROUND_COLOR,
      ),
      child: child,
    );
  }
}
