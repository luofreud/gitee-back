import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Gradient? gradient;
  final double? height;
  final double? width;
  final double? radius;
  final bool isRadius;
  final BorderSide? side;
  final EdgeInsetsGeometry? padding;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final TextStyle? textStyle;

  const GradientButton({
    super.key,
    this.onPressed,
    required this.child,
    this.gradient,
    this.height = 42,
    this.width,
    this.radius,
    this.isRadius = true,
    this.side,
    this.padding,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    double borderRadius = isRadius ? (height ?? 0) : (radius ?? 6);
    Widget outlinedButton = OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: foregroundColor ?? Colors.white,
        disabledBackgroundColor: disabledBackgroundColor,
        disabledForegroundColor:
            disabledForegroundColor ?? foregroundColor ?? Colors.white,
        side: side ?? BorderSide.none,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          // side: BorderSide.none,
        ),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
        textStyle: textStyle ?? TextStyle(fontSize: 16),
      ),
      child: child,
    );
    if (onPressed == null) {
      outlinedButton = Container(
        decoration: BoxDecoration(
          color: disabledBackgroundColor ?? Colors.white.withAlpha(180),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        height: height,
        width: width,
        padding: EdgeInsets.zero,
        child: outlinedButton,
      );
    }
    return Container(
      decoration: BoxDecoration(
        gradient:
            gradient ??
            LinearGradient(colors: [Color(0xff4D1FAE), Color(0xff0A2063)]),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      height: height,
      width: width,
      padding: EdgeInsets.zero,
      child: outlinedButton,
    );
  }
}
