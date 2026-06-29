import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:get/get.dart';

import '../../../../widgets/component/user_tag.dart';
import '../../widgets/advisor_ad_nav.dart';
import '../../widgets/fortune_item_widget.dart';
import 'fortune_year_controller.dart';

class FortuneYearComponent extends GetView<FortuneYearController> {
  final int archiveId;
  const FortuneYearComponent({super.key, required this.archiveId});

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
    Get.lazyPut(() => FortuneYearController());
    controller.loadFortuneForArchive(archiveId);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: controller.yearTabs.map((item) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.onDayChange(item);
                  },
                  child: Obx(() {
                    final selected =
                        controller.selectedYearIndex ==
                        controller.yearTabs.indexOf(item);
                    return _buildTabItem(item: item, selected: selected);
                  }),
                ),
              );
            }).toList(),
          ),
          _YearMoodComponent(),
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
                child: Center(
                  child: Text('暂无数据',
                      style: TextStyle(color: Colors.grey)),
                ),
              );
            }
            return Column(
              spacing: 10,
              children: filtered.map((item) {
                return FortuneItemWidget(
                  title: item['title'] as String?,
                  titleTag: _buildCorpusLabels(
                      item['label'] as List<dynamic>?),
                  subTitle: '行运：${item['phase_str'] ?? ''}',
                  subTrailing: _buildPhaseTrailing(item),
                  content: item['content'] as String?,
                );
              }).toList(),
            );
          }),
          AdvisorAdNav(),
        ],
      ),
    );
  }
}

class _YearMoodComponent extends StatelessWidget {
  const _YearMoodComponent();

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
          Image.asset('assets/images/year_mood.png', width: 133, height: 30),
          const SizedBox(height: 5),
          Obx(() {
            final fortune = Get.find<FortuneYearController>().todayFortune.value;
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
        ],
      ),
    );
  }
}
