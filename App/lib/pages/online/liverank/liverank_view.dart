import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:get/get.dart';

import 'liverank_controller.dart';

class LiverankPage extends GetView<LiverankController> {
  const LiverankPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => LiverankController());
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, title: Text('排行榜')),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 170),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/liverank_top.png'),
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white.withAlpha(100), Colors.white],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(AppConst.PAGE_PADDING),
                child: Column(
                  spacing: 15,
                  children: [
                    Row(
                      spacing: 10,
                      children: controller.tabs.map((item) {
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              controller.changeTab(item);
                            },
                            child: Obx(() {
                              bool active = controller.tabActive.value == item;
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  gradient: active
                                      ? LinearGradient(
                                          colors: [
                                            Color(0xffFFAD7D),
                                            Color(0xffFF4A4A),
                                          ],
                                        )
                                      : null,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 40,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    active
                                        ? Image.asset(
                                            'assets/icons/icon_rank1.png',
                                            height: 25,
                                          )
                                        : SizedBox.shrink(),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          item,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: active ? Colors.white : null,
                                            fontWeight: active
                                                ? FontWeight.w600
                                                : null,
                                          ),
                                        ),
                                      ),
                                    ),
                                    active
                                        ? Transform.scale(
                                            scaleX: -1, // 水平翻转
                                            alignment: Alignment.center,
                                            child: Image.asset(
                                              'assets/icons/icon_rank1.png',
                                              height: 25,
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              );
                            }),
                          ),
                        );
                      }).toList(),
                    ),
                    ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Obx(() {
                          return _ItemWidget(
                            index: index,
                            type: controller.tabActive.value,
                          );
                        });
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 10);
                      },
                      itemCount: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  final int index;
  final String type;

  const _ItemWidget({super.key, required this.index, required this.type});

  @override
  Widget build(BuildContext context) {
    String subTitle = '';
    switch (type) {
      case '热度榜':
        subTitle = '1.7w人气 丨 累计连麦2522';
        break;
      case '好评榜':
        subTitle = '好评率 86.5%';
        break;
      case '新人榜':
        subTitle = '近期连麦 2666';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: index < 3 ? Color(0xffFFE0E0) : Color(0xffFAFAFA),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        horizontalTitleGap: 0,
        contentPadding: EdgeInsets.only(left: 15, right: 10, top: 5, bottom: 5),
        leading: Text(
          '${index + 1}',
          style: index < 3
              ? TextStyle(
                  fontFamily: 'ChuangKeTieJinGangTi',
                  fontSize: 20,
                  color: Colors.red,
                )
              : TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffA6A6A6),
                ),
        ),
        title: Row(
          spacing: 8,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  foregroundImage: NetworkImage(
                    'https://picsum.photos/50/50?random=$index',
                  ),
                ),
                Positioned(
                  child: Image.asset(
                    'assets/images/live_avatar.png',
                    width: 42,
                    height: 42,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('白日依山尽'),
                  Text(
                    subTitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: index < 3 ? Color(0xff9C7268) : Color(0xff808080),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            backgroundColor: Color(0xffFF4044),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            minimumSize: Size(50, 32),
          ),
          child: Text('立即咨询', style: TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}
