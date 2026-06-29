import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/widgets/empty_tips.dart';
import 'package:get/get.dart';

import '../../../../widgets/component/user_tag.dart';
import '../../widgets/advisor_ad_nav.dart';
import '../../widgets/fortune_item_widget.dart';
import 'fortune_day_controller.dart';

class FortuneDayComponent extends GetView<FortuneDayController> {
  final int archiveId;

  const FortuneDayComponent({super.key, required this.archiveId});

  _buildTabItem({
    required String item,
    bool selected = false,
    EdgeInsetsGeometry? padding,
  }) {
    return Container(
      alignment: Alignment.center,

      decoration: BoxDecoration(
        color: selected ? Colors.white : null,
        borderRadius: BorderRadius.circular(6),
      ),
      padding: padding ?? const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        item,
        style: TextStyle(color: selected ? Color(0xff4C1FAD) : null),
      ),
    );
  }

  Widget? _buildCorpusLabels(List<dynamic>? labels) {
    if (labels == null || labels.isEmpty) return null;
    return Row(
      spacing: 4,
      children: labels.map((label) {
        final trend = label['trend'] as String? ?? '0';
        final name = label['name'] as String? ?? '0';
        Color borderColor;
        Color textColor;
        String title;
        switch (trend) {
          case '1':
            title = name;
            borderColor = const Color(0xffFF3B3B);
            textColor = const Color(0xffFF3B3B);
          case '-1':
            title = name;
            borderColor = const Color(0xff53C260);
            textColor = const Color(0xff53C260);
          default:
            title = name;
            borderColor = const Color(0xffFF5C5C);
            textColor = const Color(0xffFF5C5C);
        }
        return UserTag(
          title: title,
          gradient: const LinearGradient(
            colors: [Colors.transparent, Colors.transparent],
          ),
          border: Border.all(color: borderColor),
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          textStyle: TextStyle(fontSize: 10, color: textColor, height: 1),
        );
        return Container(
          decoration: BoxDecoration(
            color: borderColor,
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          padding: const EdgeInsetsGeometry.only(right: 2),
          child: Row(
            spacing: 2,
            children: [
              UserTag(
                title: title,
                gradient: LinearGradient(colors: [Colors.white, Colors.white]),
                border: Border.all(color: borderColor),
                padding: const EdgeInsetsGeometry.symmetric(
                  horizontal: 3,
                  vertical: 2,
                ),
                textStyle: TextStyle(
                  fontSize: 10,
                  color: borderColor,
                  height: 1,
                ),
              ),
              Text(
                name,
                style: TextStyle(fontSize: 10, color: Colors.white, height: 1),
              ),
              Icon(Icons.arrow_forward_ios, size: 8, color: Colors.white),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPhaseTrailing(Map<String, dynamic> item) {
    final startDate = item['start_date'] as int? ?? 0;
    final endDate = item['end_date'] as int? ?? 0;
    final duration = startDate + endDate;
    return Text.rich(
      TextSpan(
        text: '持续${duration}天 ',
        style: const TextStyle(fontSize: 12, color: Color(0xff808080)),
        children: [
          TextSpan(
            text: '$startDate/$duration',
            style: const TextStyle(fontSize: 12, color: Color(0xff2A82E4)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => FortuneDayController());
    controller.loadFortuneForArchive(archiveId);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: controller.dayTabs.map((item) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.onDayChange(item);
                  },
                  child: Obx(() {
                    final selected =
                        controller.selectedDayIndex ==
                        controller.dayTabs.indexOf(item);
                    return _buildTabItem(item: item, selected: selected);
                  }),
                ),
              );
            }).toList(),
          ),
          _TodayMoodComponent(),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Text('解析今日行运指南'),
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
          ),
          Text('心理解读', style: TextStyle(fontSize: 16)),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: controller.typeTabs.map((item) {
                  final selected =
                      controller.selectedTypeIndex ==
                      controller.typeTabs.indexOf(item);
                  return GestureDetector(
                    onTap: () {
                      controller.onTypeChange(item);
                    },
                    child: _buildTabItem(
                      item: item,
                      selected: selected,
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 6,
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xff96A8FF),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: GestureDetector(
                  onTap: () {
                    if (controller.currentArchiveId != null) {
                      Get.toNamed(
                        AppRoutes.ASTROLABE_ANALYSIS,
                        arguments: {'id': controller.currentArchiveId},
                      );
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        '今日行运星盘',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '查看',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                final data = controller.todayFortune.value;
                final corpus =
                    (data?['corpus'] as List<dynamic>?)
                        ?.map((e) => Map<String, dynamic>.from(e as Map))
                        .toList() ??
                    [];
                final selectedCategory = controller.typeTabs.isNotEmpty
                    ? controller.typeTabs[controller.selectedTypeIndex.value]
                    : '综合';
                final filtered = corpus.where((item) {
                  final cat = (item['category'] as String?) ?? '';
                  final label = cat.isEmpty ? '综合' : cat;
                  return label == selectedCategory;
                }).toList();
                if (filtered.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: EmptyTips(title: '暂无数据')),
                  );
                }
                int index = 0;
                return Column(
                  spacing: 10,
                  children: filtered.map((item) {
                    index++;
                    return FortuneItemWidget(
                      title: item['title'] as String?,
                      titleTag: _buildCorpusLabels(
                        item['label'] as List<dynamic>?,
                      ),
                      borderRadius: index == 1
                          ? BorderRadius.vertical(bottom: Radius.circular(10))
                          : null,
                      subTitle: '行运：${item['phase_str'] ?? ''}',
                      subTrailing: _buildPhaseTrailing(item),
                      content: item['content'] as String?,
                    );
                  }).toList(),
                );
              }),
            ],
          ),
          AdvisorAdNav(),
        ],
      ),
    );
  }
}

class _TodayMoodComponent extends StatelessWidget {
  const _TodayMoodComponent({super.key});

  _buildCircularProgress(dynamic totalScore) {
    final score = (totalScore is num) ? totalScore.toDouble() : 0.0;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Color(0xffF5F7FF),
            shape: BoxShape.circle,
          ),
        ),
        CircularProgressIndicator(
          value: score / 100,
          strokeWidth: 6,
          constraints: BoxConstraints.expand(width: 100, height: 100),
          backgroundColor: Color(0xffd9f1ff),
          color: Color(0xff51BEFC),
        ),
        Column(
          spacing: 4,
          children: [
            Text(
              score.toInt().toString(),
              style: TextStyle(fontSize: 28, height: 1),
            ),
            Text(
              '综合分数',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildScoreItem({required String title, int score = 0, Color? color}) {
    color ??= Color(0xff51BEFC);
    return Row(
      spacing: 8,
      children: [
        Text(title, style: TextStyle(fontSize: 12)),
        Expanded(
          child: Container(
            height: 6,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Color(0xffF5F7FF),
              borderRadius: BorderRadius.circular(6),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  height: 6,
                  width: constraints.maxWidth * (score / 100),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    gradient: LinearGradient(
                      colors: [color!.withAlpha(100), color],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Text('${score}分', style: TextStyle(fontSize: 12)),
      ],
    );
  }

  _attrItem({
    required String title,
    required String valueTitle,
    Widget? child,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsetsGeometry.symmetric(vertical: 10),
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
            Text(valueTitle, style: TextStyle(fontSize: 10)),
            Text(
              title,
              style: TextStyle(fontSize: 8, color: Color(0xffA6A6A6)),
            ),
          ],
        ),
      ),
    );
  }

  _buildFortuneAttrs() {
    return Obx(() {
      final fortune = Get.find<FortuneDayController>().todayFortune.value;
      return Row(
        spacing: 10,
        children: [
          _attrItem(
            title: '幸运花',
            valueTitle: fortune?['lucky_flower'] ?? '-',
            child: CircleAvatar(backgroundColor: Colors.white, radius: 10),
          ),
          _attrItem(
            title: '幸运石',
            valueTitle: fortune?['lucky_stone'] ?? '-',
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
            title: '幸运色',
            valueTitle: fortune?['lucky_color'] ?? '-',
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 10,
              child: CircleAvatar(
                radius: 7,
                backgroundColor: Color(0xffFA5757),
              ),
            ),
          ),
          _attrItem(
            title: '幸运数',
            valueTitle: fortune?['lucky_number']?.toString() ?? '-',
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 10,
              child: Text(
                fortune?['lucky_number']?.toString() ?? '--',
                style: TextStyle(fontSize: 14, color: Color(0xff607BDB)),
              ),
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        spacing: 10,
        children: [
          Image.asset('assets/images/today_mood.png', width: 133, height: 30),
          const SizedBox(height: 5),
          Obx(() {
            final fortune = Get.find<FortuneDayController>().todayFortune.value;
            return Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Column(
                    spacing: 15,
                    children: [
                      _buildScoreItem(
                        title: '爱情',
                        score: fortune?['love'] ?? 0,
                        color: Color(0xffFF6961),
                      ),
                      _buildScoreItem(
                        title: '健康',
                        score: 85,
                        color: Color(0xff6BDBAD),
                      ),
                      _buildScoreItem(
                        title: '财富',
                        score: fortune?['wealth'] ?? 0,
                        color: Color(0xffFFBA70),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _buildCircularProgress(fortune?['average'] ?? 0),
                ),
              ],
            );
          }),
          const SizedBox(height: 5),
          _buildFortuneAttrs(),
          Obx(() {
            final fortune = Get.find<FortuneDayController>().todayFortune.value;
            final avoid = fortune?['avoid'] ?? '你在感情中雷区';
            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.DICE);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffF5F7FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Text(
                      '注意：',
                      style: TextStyle(fontSize: 12, color: Color(0xff7B59E3)),
                    ),
                    Expanded(
                      child: Text(
                        avoid,
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
            );
          }),
        ],
      ),
    );
  }
}
