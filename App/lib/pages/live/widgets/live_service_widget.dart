import 'package:flutter/material.dart';

/// 直播服务区域
class LiveServiceWidget extends StatelessWidget {
  const LiveServiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        spacing: 10,
        children: [
          const Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Color(0xff262626).withAlpha(100),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/home_nav_xp.png',
                  width: 38,
                  height: 38,
                ),
                Text('星盘', style: TextStyle(fontSize: 12, color: Colors.white)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xff262626).withAlpha(100),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/home_nav_hp.png',
                  width: 38,
                  height: 38,
                ),
                Text('合盘', style: TextStyle(fontSize: 12, color: Colors.white)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xff262626).withAlpha(100),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/home_nav_tl.png',
                  width: 38,
                  height: 38,
                ),
                Text('塔罗', style: TextStyle(fontSize: 12, color: Colors.white)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color(0xff262626).withAlpha(100),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Image.asset('assets/images/photo.png', width: 38, height: 38),
                Text('照片', style: TextStyle(fontSize: 12, color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
