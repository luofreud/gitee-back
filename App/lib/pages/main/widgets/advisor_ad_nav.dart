import 'package:flutter/material.dart';
import 'package:freud/utils/utils.dart';
import 'package:freud/widgets/component/icon_widget.dart';

/// 专业咨询师在线解读
class AdvisorAdNav extends StatelessWidget {
  const AdvisorAdNav({super.key});

  /// 生成两个同色系的深色
  /// 返回值：包含两个 Color 对象的列表
  List<Color> generateColors() {
    Color color = CommonUtil.randomColor();
    return [color.withAlpha(200), color];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: generateColors(), //[Color(0xff2A82E4), Color(0xff2967E3)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '专业咨询师在线解读',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xffFF4A4A)),
            ),
            padding: const EdgeInsets.all(2),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/example/home_item_image.png'),
            ),
          ),
          const SizedBox(width: 10),
          Image.asset('assets/icons/live_user_vs.png', width: 16, height: 16),
          const SizedBox(width: 10),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white),
            ),
            padding: const EdgeInsets.all(2),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconWidget(icon: 'icon_voice2.png', width: 14, height: 18),
            ),
          ),
        ],
      ),
    );
  }
}
