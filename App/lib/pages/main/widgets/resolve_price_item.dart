import 'package:flutter/material.dart';
import 'package:freud/widgets/gradient_text.dart';

class ResolvePriceItem extends StatelessWidget {
  final String title;
  final String? price;
  final String? tips;
  final bool? selected;
  final double? width;
  final VoidCallback? onTap;

  const ResolvePriceItem({
    super.key,
    required this.title,
    this.price,
    this.tips,
    this.selected,
    this.width,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: width,
            decoration: BoxDecoration(
              color: Color(0xffF7FAFC),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(
                color: selected == true ? Color(0xffFF8138) : Color(0xffF7FAFC),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
            child: Column(
              spacing: 5,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Color(0xff808080)),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '￥',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1,
                        color: selected == true
                            ? Color(0xffFF8138)
                            : Color(0xff383838),
                      ),
                    ),
                    GradientText(
                      colors: selected == true
                          ? [Color(0xffFF8138), Color(0xffFF4F4F)]
                          : [Color(0xff383838), Color(0xff383838)],
                      child: Text(
                        price ?? '0.00',
                        style: TextStyle(fontSize: 18, height: 1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (tips != null && tips!.isNotEmpty)
            Positioned(
              left: 0,
              top: -10,
              child: ClipPath(
                clipper: _TipsContainerClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xffFF8138), Color(0xffFF4F4F)],
                    ),
                  ),
                  height: 26,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 6,
                  ),
                  child: Text(
                    tips!,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// 自定义裁剪
class _TipsContainerClipper extends CustomClipper<Path> {
  const _TipsContainerClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width - 10, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 10);
    path.quadraticBezierTo(
      size.width,
      size.height - 6,
      size.width - 10,
      size.height - 6,
    );
    path.lineTo(10, size.height - 6);
    path.quadraticBezierTo(0, size.height - 6, 0, size.height);

    path.lineTo(0, 10);
    path.quadraticBezierTo(0, 0, 10, 0); // 左下角的曲线
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
