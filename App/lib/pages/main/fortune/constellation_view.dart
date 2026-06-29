import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:freud/widgets/component/user_tag.dart';
import 'package:freud/widgets/page_background.dart';
import 'package:get/get.dart';

import 'constellation_controller.dart';

/// 星座页面
class ConstellationPage extends GetView<ConstellationController> {
  const ConstellationPage({super.key});

  _userTag(String text) {
    return UserTag(
      title: text,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      gradient: LinearGradient(colors: [Colors.white, Colors.white]),
      textStyle: TextStyle(height: 1, color: Color(0xffED8C24), fontSize: 10),
      border: Border.all(color: Color(0xffED8C24)),
    );
  }

  _buildTeacheInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        spacing: 12,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://picsum.photos/100/100?random=123',
              width: 94,
              height: 94,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 3,
              children: [
                Text('王小明', style: TextStyle(fontSize: 16)),
                Text(
                  '从业8年 丨 好评95%',
                  style: TextStyle(fontSize: 12, color: Color(0xff808080)),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '技能：',
                      style: TextStyle(fontSize: 12, color: Color(0xff808080)),
                    ),
                    Expanded(
                      child: Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        children: List.generate(2, (index) => _userTag('星图')),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '技能：',
                      style: TextStyle(fontSize: 12, color: Color(0xff808080)),
                    ),
                    Expanded(child: Wrap(children: [_userTag('星图')])),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildAttrItemWidget({String? title, String? content, Function()? onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          Row(
            spacing: 5,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Color(0xffF5F7FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: IconWidget(icon: 'icon_star3.png', size: 12),
              ),
              Text(
                title ?? '',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Text(
            content ?? '',
            style: TextStyle(fontSize: 12),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF5F7F9),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  IconWidget(icon: 'icon_fire2.png', size: 16),
                  Expanded(
                    child: Text('火热讨论区', style: TextStyle(fontSize: 12)),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Color(0xff696969),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ConstellationController());

    return PageBackground(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('星座'),
          backgroundColor: Colors.white.withAlpha(0),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              _ConstellationFortune(),
              _HotLiveContainer(),
              _buildTeacheInfo(),
              _buildAttrItemWidget(
                title: '爱情',
                content:
                    '昨夜雨疏风骤，浓睡不消残酒，兴尽晚回舟，误入藕花深处。争渡，争渡，近期一滩鸥鹭。红藕香残玉簟秋，轻解罗裳，独上兰舟，云中谁寄锦书来，雁字回时，月满西楼。花自飘零...',
                onTap: () {},
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color(0xff0A2063),
                  side: BorderSide.none,
                  minimumSize: Size(double.infinity, 40),
                ),
                child: ShaderMask(
                  // 渐变着色器（核心）
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      colors: [Color(0xff4C1FAD), Color(0xff0A2063)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds);
                  },
                  // 混合模式：只显示前景（文字）的渐变，背景透明
                  blendMode: BlendMode.srcIn,
                  child: Text('查看今日注意事项'),
                ),
              ),
              _buildAttrItemWidget(
                title: '事业学业',
                content:
                    '昨夜雨疏风骤，浓睡不消残酒，兴尽晚回舟，误入藕花深处。争渡，争渡，近期一滩鸥鹭。红藕香残玉簟秋，轻解罗裳，独上兰舟，云中谁寄锦书来，雁字回时，月满西楼。花自飘零...',
                onTap: () {},
              ),
              _buildAttrItemWidget(
                title: '财富',
                content:
                    '昨夜雨疏风骤，浓睡不消残酒，兴尽晚回舟，误入藕花深处。争渡，争渡，近期一滩鸥鹭。红藕香残玉簟秋，轻解罗裳，独上兰舟，云中谁寄锦书来，雁字回时，月满西楼。花自飘零...',
                onTap: () {},
              ),
              _buildAttrItemWidget(
                title: '健康',
                content:
                    '昨夜雨疏风骤，浓睡不消残酒，兴尽晚回舟，误入藕花深处。争渡，争渡，近期一滩鸥鹭。红藕香残玉簟秋，轻解罗裳，独上兰舟，云中谁寄锦书来，雁字回时，月满西楼。花自飘零...',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConstellationFortune extends StatelessWidget {
  const _ConstellationFortune({super.key});

  _buildDateTab() {
    final controller = Get.find<ConstellationController>();
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF5F7FF),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: controller.tabs.asMap().entries.map((item) {
          final index = item.key;
          final tab = item.value;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                controller.changeTab(index);
              },
              child: Obx(() {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: 8,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: controller.tabIndex == index
                        ? LinearGradient(
                            colors: [Color(0xff4C1FAD), Color(0xff0A2063)],
                          )
                        : null,
                  ),
                  child: Text(
                    '$tab',
                    style: TextStyle(
                      color: controller.tabIndex == index ? Colors.white : null,
                    ),
                  ),
                );
              }),
            ),
          );
        }).toList(),
      ),
    );
  }

  _buildScoreTag(String text) {
    final tags = ['注意', '指南', '警惕'];
    final colors = [Color(0xff9A95FC), Color(0xff78E3BF), Color(0xffFF3B3B)];
    final index = tags
        .indexWhere((item) => item == text)
        .clamp(0, colors.length - 1);
    return SizedBox(
      width: 40,
      child: Center(
        child: text.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                  border: Border.all(color: colors[index]),
                  borderRadius: BorderRadius.circular(2),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 10,
                    color: colors[index],
                    height: 1,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  _buildFortuneScore(int score) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(5, (index) {
          return IconWidget(
            icon: index < score ? 'icon_star2.png' : 'icon_star.png',
            size: 16,
          );
        }),
      ),
    );
  }

  _buildFortune() {
    return SizedBox(
      height: 180,
      child: Row(
        spacing: 15,
        children: [
          Container(
            width: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Color(0xffF2F2F2),
                  offset: Offset(0, 2),
                  blurRadius: 10,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/constellation/img_by.png',
                  width: 110,
                  height: 110,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [
                    Text('白羊座'),
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffF2F2F2),
                              offset: Offset(0, 2),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/icons/icon_sync_alt.png',
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '03.21-04.19',
                  style: TextStyle(fontSize: 12, color: Color(0xff808080)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsGeometry.symmetric(vertical: 10),
                  child: Text(
                    '完善计划再行动',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                Divider(color: Color(0xffF7F7F7), height: 1),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Text('综合', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 10),
                          _buildFortuneScore(2),
                          _buildScoreTag('注意'),
                        ],
                      ),
                      Row(
                        children: [
                          Text('工作', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 10),
                          _buildFortuneScore(2),
                          _buildScoreTag('指南'),
                        ],
                      ),
                      Row(
                        children: [
                          Text('爱情', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 10),
                          _buildFortuneScore(5),
                          _buildScoreTag('警惕'),
                        ],
                      ),
                      Row(
                        children: [
                          Text('理财', style: TextStyle(fontSize: 12)),
                          const SizedBox(width: 10),
                          _buildFortuneScore(2),
                          _buildScoreTag(''),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _attrItem({required String title, Widget? child}) {
    return Expanded(
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Color(0xffF5F7FF),
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            if (child != null) SizedBox(height: 20, child: child),
            Text(title, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  _buildFortuneAttrs() {
    return Row(
      spacing: 10,
      children: [
        _attrItem(
          title: '健康指数',
          child: Text(
            '86%',
            style: TextStyle(fontSize: 14, color: Color(0xff66CC7E)),
          ),
        ),
        _attrItem(
          title: '速配星座',
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 10,
            child: Image.asset(
              'assets/icons/constellation/icon_color_by.png',
              width: 10,
              height: 10,
            ),
          ),
        ),
        _attrItem(
          title: '幸运颜色',
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 10,
            child: CircleAvatar(radius: 7, backgroundColor: Color(0xffFA5757)),
          ),
        ),
        _attrItem(
          title: '幸运数字',
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 10,
            child: Text(
              '6',
              style: TextStyle(fontSize: 14, color: Color(0xff607BDB)),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 15,
        children: [
          _buildDateTab(),
          _buildFortune(),
          _buildFortuneAttrs(),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffF5F7FF),
                borderRadius: BorderRadius.circular(6),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Row(
                children: [
                  Text(
                    '注意：',
                    style: TextStyle(fontSize: 12, color: Color(0xff7B59E3)),
                  ),
                  Expanded(
                    child: Text(
                      '你在感情中雷区',
                      style: TextStyle(fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Color(0xff696969),
                  ),
                ],
              ),
            ),
          ),
          Text('选择你最关心的事情，解析今日行运指南'),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: GestureDetector(
                  child: Image.asset('assets/images/fortune_nav_sy.png'),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Image.asset('assets/images/fortune_nav_aq.png'),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Image.asset('assets/images/fortune_nav_cf.png'),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  child: Image.asset('assets/images/fortune_nav_qt.png'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HotLiveContainer extends StatelessWidget {
  const _HotLiveContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/constellation_hotlive_bg.png'),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 6,
                  children: [
                    Text(
                      '咨询师在线解读',
                      style: TextStyle(color: Color(0xffFA789B), height: 1),
                    ),
                    Text(
                      '听听大家都在聊什么？',
                      style: TextStyle(color: Color(0xffFA789B), height: 1),
                    ),
                    Container(
                      width: 80,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5,
                        children: [
                          Text(
                            '点击进入',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xff545454),
                              height: 1,
                            ),
                          ),
                          Icon(Icons.arrow_forward_ios, size: 10),
                        ],
                      ),
                    ),
                  ],
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
              Image.asset(
                'assets/icons/live_user_vs.png',
                width: 16,
                height: 16,
              ),
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
                  child: IconWidget(
                    icon: 'icon_voice2.png',
                    width: 14,
                    height: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffFA78E4),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(6),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            child: Row(
              children: [
                Transform.scale(
                  scaleX: -1,
                  child: Icon(
                    Icons.signal_cellular_alt,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '热门直播',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
