import 'package:flutter/material.dart';
import 'package:freud/models/user/teacher.dart';
import 'package:freud/widgets/component/image_view.dart';

class ChatTeacherInfo extends StatelessWidget {
  final Teacher? teacher;

  const ChatTeacherInfo({super.key, this.teacher});

  static const TextStyle valueStyle = TextStyle(fontSize: 16);
  static const TextStyle titleStyle = TextStyle(
    fontSize: 13,
    color: Color(0xffcccccc),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: ImageView.network(
                  teacher?.headimg ?? '',
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  isPreview: false,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(teacher?.doubtnum?.toString() ?? '0', style: valueStyle),
                const Text('累计解惑', style: titleStyle),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: VerticalDivider(
              color: Color(0xffEBE8FA),
              indent: 0,
              endIndent: 0,
              width: 1,
              thickness: 1,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('${teacher?.score ?? 0}%', style: valueStyle),
                const Text('好评率', style: titleStyle),
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: VerticalDivider(
              color: Color(0xffEBE8FA),
              indent: 0,
              endIndent: 0,
              width: 1,
              thickness: 1,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  teacher?.year != null ? '${teacher!.year}年' : '0年',
                  style: valueStyle,
                ),
                const Text('从业年限', style: titleStyle),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
