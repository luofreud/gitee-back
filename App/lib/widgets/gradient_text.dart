import 'package:flutter/material.dart';

class GradientText extends StatelessWidget {
  final Widget? child;
  final Gradient? gradient;
  final List<Color>? colors;

  const GradientText({super.key, this.child, this.gradient, this.colors});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      // 渐变着色器（核心）
      shaderCallback: (Rect bounds) {
        return (gradient ??
                LinearGradient(
                  colors: colors ?? [Color(0xff4C1FAD), Color(0xff0A2063)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ))
            .createShader(bounds);
      },
      // 混合模式：只显示前景（文字）的渐变，背景透明
      blendMode: BlendMode.srcIn,
      child: child,
    );
  }
}
