import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user/teacher.dart';
import '../../router/app_routes.dart';
import '../dashed_divider.dart';
import 'image_view.dart';

///导师列表
class TutorItem extends StatelessWidget {
  final Teacher? teacher;

  const TutorItem({super.key, this.teacher});

  String _formatPrice(double? price) {
    if (price == null) return '';
    return '${price.toStringAsFixed(2)}星钻/分钟';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ImageView.network(
                      teacher?.headimg ?? '',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      isPreview: false,
                    ),
                  ),
                  if (teacher?.livestate == 0)
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xff53DAF5),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          '在线',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ),
                  Positioned(
                    left: 6,
                    bottom: 6,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [Color(0xffFFB16E), Color(0xffFF4D4D)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        spacing: 3,
                        children: [
                          Image.asset(
                            'assets/icons/icon_fire.png',
                            width: 8,
                            height: 9,
                          ),
                          Text(
                            '活跃',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            teacher?.name ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          _formatPrice(teacher?.oliveprice),
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xffED8C24),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      teacher?.introduction ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Color(0xff808080)),
                    ),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: (teacher?.tags ?? '')
                          .split(';')
                          .where((t) => t.isNotEmpty)
                          .map(
                            (tag) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: Color(0xffED8C24)),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xffED8C24),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          DashedDivider(
            height: 24,
            color: Color(0xffD9D9D9),
            dashPattern: [1, 2],
          ),
          Row(
            children: [
              Text(
                '咨询量${teacher?.doubtnum}',
                style: TextStyle(color: Color(0xffA6A6A6), fontSize: 13),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 15,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.CHAT,
                          arguments: {
                            'uid': teacher?.uid,
                            'name': teacher?.name,
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xffF1EBFF), Color(0xffE0E8FF)],
                          ),
                        ),
                        child: Text(
                          '私聊咨询',
                          style: TextStyle(
                            color: Color(0xff4D1FAE),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await Get.toNamed(
                          AppRoutes.VOICE_CALL,
                          arguments: {'uid': teacher?.uid},
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xff4D1FAE), Color(0xff0A2063)],
                          ),
                        ),
                        child: Text(
                          '通话咨询',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
