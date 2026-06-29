import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/pages/main/widgets/advisor_ad_nav.dart';
import 'package:freud/pages/main/widgets/fortune_item_widget.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:freud/widgets/page_background.dart';
import 'package:get/get.dart';

import 'astrolabe_analysis_controller.dart';
import 'widgets/astrolabe_widget.dart';

/// 星盘页面
class AstrolabeAnalysisPage extends GetView<AstrolabeAnalysisController> {
  const AstrolabeAnalysisPage({super.key});

  // 推运时间选择
  _buildTransitdayContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      child: Row(
        spacing: 5,
        children: [
          GestureDetector(
            onTap: () => controller.previousTransit(),
            child: Icon(Icons.arrow_back_ios, color: Color(0xff808080)),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8,
              children: [
                Obx(
                  () => Text(
                    controller.formattedTransitTime,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                _DateIntervalType(),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => controller.nextTransit(),
            child: Icon(Icons.arrow_forward_ios, color: Color(0xff808080)),
          ),
        ],
      ),
    );
  }

  // 专业解读星盘
  _buildAnswerNavContainer() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        spacing: 10,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xfff2f5ff),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '你想了解更多关于本命盘的内容，可以咨询专业解读~',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
                Text(
                  '情感问题、事业发展、个人财运、身体健康、前程学业',
                  style: TextStyle(fontSize: 12, color: Color(0xff7385BF)),
                ),
              ],
            ),
          ),
          GradientButton(
            onPressed: () {},
            height: 40,
            width: double.infinity,
            isRadius: false,
            foregroundColor: Color(0xffFFD0A1),
            child: Text('专业解读本命星盘'),
          ),
        ],
      ),
    );
  }

  // 解读tab
  _buildBirthChartTabs() {
    return Obx(() {
      final tabs = controller.availableBirthChartTabs;
      if (tabs.isEmpty) return const SizedBox.shrink();
      return Row(
        spacing: 10,
        children: tabs.map((item) {
          return Expanded(
            child: Obx(() {
              final selected = controller.birthChartTabStr == item;
              return GestureDetector(
                onTap: () {
                  controller.changeBirthChartTab(item);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selected ? Color(0xffE6EAFF) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  height: 40,
                  child: Text(
                    '$item',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: selected ? FontWeight.w500 : FontWeight.w300,
                      color: selected ? Color(0xff3D44C4) : null,
                    ),
                  ),
                ),
              );
            }),
          );
        }).toList(),
      );
    });
  }

  // 解读内容
  Widget _buildBirthChartContainer() {
    return Obx(() {
      final tab = controller.birthChartTabStr.value;
      final tabs = controller.availableBirthChartTabs;
      if (!tabs.contains(tab)) {
        if (tabs.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.birthChartTabStr.value = tabs.first;
          });
        }
        return const SizedBox.shrink();
      }
      switch (tab) {
        case '星座解读':
          return _XzjdContainer();
        case '落宫分析':
          return _LgfxContainer();
        default:
          return const SizedBox.shrink();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AstrolabeAnalysisController());
    return PageBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Obx(() {
            if (controller.currentChartType.value == 0 &&
                controller.archive2.value != null) {
              return Text(
                '${controller.archiveDetail.value?.name ?? ''} & ${controller.archive2.value?.name ?? ''}',
              );
            }
            return Text(controller.archiveDetail.value?.name ?? '');
          }),
          backgroundColor: Colors.white.withAlpha(0),
          actions: [
            GestureDetector(
              onTap: () => controller.changeArchive(),
              child: IconWidget(icon: 'icon_change.png', size: 20),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              child: IconWidget(icon: 'icon_share2.png', size: 20),
            ),
            const SizedBox(width: AppConst.PAGE_PADDING),
          ],
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConst.PAGE_PADDING,
          ),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                onTap: (index) {
                  controller.changeTab(index);
                },
                isScrollable: true,
                overlayColor: WidgetStateProperty.all(Colors.transparent),
                controller: controller.tabController,
                dividerHeight: 0,
                tabAlignment: TabAlignment.start,
                unselectedLabelColor: Color(0xff7986B0),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
                labelColor: Colors.black,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(color: Color(0Xff4D1FAE), width: 3),
                  borderRadius: BorderRadius.circular(4),
                  insets: EdgeInsets.all(5),
                ),
                tabs: controller.tabs.map((item) => Tab(text: item)).toList(),
              ),
              Obx(() {
                var chartData = controller
                    .chartData[controller.currentChartType.value]
                    ?.value;
                if (chartData == null && controller.isLoading.value == true) {
                  return SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final tabName =
                    controller.tabs[controller.currentChartType.value];
                final hideYearReport =
                    tabName == '合盘' || tabName == '日返' || tabName == '月返';
                return Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AstrolabeWidget(),
                    if (['天象', '行运', '法达', '次限', '三限'].contains(tabName))
                      _buildTransitdayContainer(),
                    if ('天象' == tabName) _TodayConstellationContainer(),
                    _buildAnswerNavContainer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        spacing: 5,
                        children: [
                          Icon(Icons.info, size: 18, color: Color(0xffCCCCCC)),
                          Expanded(
                            child: Text(
                              '当前内容为免费内容，仅供您在娱乐中探索自我，无任何现实指导意义。',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff808080),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '$tabName解读',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    _buildBirthChartTabs(),
                    _buildBirthChartContainer(),
                    if (!hideYearReport) _YearReportContainer(),
                    AdvisorAdNav(),
                    const SizedBox(height: 10),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

/// 推运日期间隔类型选择
class _DateIntervalType extends StatefulWidget {
  const _DateIntervalType({super.key});

  @override
  State<_DateIntervalType> createState() => _DateIntervalTypeState();
}

class _DateIntervalTypeState extends State<_DateIntervalType> {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AstrolabeAnalysisController>();
    return Stack(
      alignment: Alignment.centerRight,
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () {
            DialogUtil.showMenuDialog(
              context: context,
              items: ['年', '月', '周', '日', '时', '分'].map((item) {
                return DialogMenuItem(
                  title: item,
                  onTap: (_) {
                    ctrl.dateIntervalType.value = item;
                    setState(() {});
                  },
                );
              }).toList(),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xff6969FF),
              borderRadius: BorderRadius.circular(6),
            ),
            width: 22,
            height: 22,
            alignment: Alignment.center,
            child: Text(
              ctrl.dateIntervalType.value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 今日星象
class _TodayConstellationContainer extends StatelessWidget {
  const _TodayConstellationContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AstrolabeAnalysisController>();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        spacing: 5,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/today_constellation_title.png',
                width: 83,
                height: 16,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.TOOL_CALENDAR);
                },
                child: Text('更多 >', style: TextStyle(color: Color(0xffA6A6A6))),
              ),
            ],
          ),
          Obx(() {
            final data = ctrl.todayCalendarData;
            if (data.isEmpty) return const SizedBox.shrink();
            return Column(
              spacing: 5,
              children: data.map((item) {
                return Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.circle, size: 8),
                    Text('${item.time ?? ''}   ${item.title ?? ''}'),
                  ],
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }
}

/// 星座解读
class _XzjdContainer extends StatelessWidget {
  const _XzjdContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AstrolabeAnalysisController>();
    return Obx(() {
      if (ctrl.xzjdList.isEmpty) return const SizedBox.shrink();
      final items = ctrl.xzjdList.take(3).toList();
      return Column(
        spacing: 10,
        children: [
          ...items.map((item) {
            final name =
                item['oneself'] as String? ?? item['title'] as String? ?? '';
            final iconFile = AppConst.XINGXING_ICON_NAME(name);
            return FortuneItemWidget(
              title: '${name}落${item['other'] as String}',
              titleLeading: iconFile != null
                  ? IconWidget(icon: 'xingpan/$iconFile.png', size: 16)
                  : null,
              subTitle: item['keywords'] ?? '',
              content: item['content'] ?? '',
              onTap: () {
                Get.toNamed(
                  AppRoutes.ASTROLABE_DETAIL,
                  arguments: {'tab': '星座解读'},
                );
              },
            );
          }),
          OutlinedButton(
            onPressed: () {
              Get.toNamed(
                AppRoutes.ASTROLABE_DETAIL,
                arguments: {'tab': '星座解读'},
              );
            },
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide.none,
              backgroundColor: Colors.white,
              foregroundColor: Color(0xff6183FF),
              textStyle: TextStyle(fontSize: 14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [Text('查看更多'), Icon(Icons.arrow_forward_ios, size: 12)],
            ),
          ),
        ],
      );
    });
  }
}

/// 落宫分析
class _LgfxContainer extends StatelessWidget {
  const _LgfxContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AstrolabeAnalysisController>();
    return Obx(() {
      if (ctrl.lgfxList.isEmpty) return const SizedBox.shrink();
      final items = ctrl.lgfxList.take(3).toList();
      return Column(
        spacing: 10,
        children: [
          ...items.map((item) {
            final name =
                item['oneself'] as String? ?? item['title'] as String? ?? '';
            final other = item['other'] as String? ?? '';
            final iconFile = AppConst.XINGXING_ICON_NAME(name);
            return FortuneItemWidget(
              title:
                  '$name${other.isNotEmpty ? '落入' : ''}${other.isNotEmpty ? other : ''}',
              titleLeading: iconFile != null
                  ? IconWidget(icon: 'xingpan/$iconFile.png', size: 16)
                  : null,
              subTitle: item['keywords'] ?? '',
              content: item['content'] ?? '',
              onTap: () {
                Get.toNamed(
                  AppRoutes.ASTROLABE_DETAIL,
                  arguments: {'tab': '落宫分析'},
                );
              },
            );
          }),
          OutlinedButton(
            onPressed: () => Get.toNamed(
              AppRoutes.ASTROLABE_DETAIL,
              arguments: {'tab': '落宫分析'},
            ),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide.none,
              backgroundColor: Colors.white,
              foregroundColor: Color(0xff6183FF),
              textStyle: TextStyle(fontSize: 14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [Text('查看更多'), Icon(Icons.arrow_forward_ios, size: 12)],
            ),
          ),
        ],
      );
    });
  }
}

/// 相位解析
class _XwjxContainer extends StatelessWidget {
  const _XwjxContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        FortuneItemWidget(
          title: '太阳摩羯3',
          titleLeading: IconWidget(icon: 'icon_tymj.png', size: 16),
          subTitle: '太阳代表着一个人的本质，自我认知及人生态度。',
          content:
              '昨夜雨疏风骤，浓睡不消残酒，兴尽晚回舟，误入藕花深处。争渡，争渡，近期一滩鸥鹭。红藕香残玉簟秋，轻解罗裳，独上兰舟，云中谁寄锦书来，雁字回时，月满西楼。花自飘零...',
        ),
        FortuneItemWidget(
          title: '月亮射手',
          titleLeading: IconWidget(icon: 'icon_ylss.png', size: 16),
          subTitle: '太阳代表着一个人的本质，自我认知及人生态度。',
          content:
              '昨夜雨疏风骤，浓睡不消残酒，兴尽晚回舟，误入藕花深处。争渡，争渡，近期一滩鸥鹭。红藕香残玉簟秋，轻解罗裳，独上兰舟，云中谁寄锦书来，雁字回时，月满西楼。花自飘零...',
        ),
        FortuneItemWidget(
          title: '上升水瓶',
          titleLeading: IconWidget(icon: 'icon_sssp.png', size: 16),
          subTitle: '太阳代表着一个人的本质，自我认知及人生态度。',
          content:
              '昨夜雨疏风骤，浓睡不消残酒，兴尽晚回舟，误入藕花深处。争渡，争渡，近期一滩鸥鹭。红藕香残玉簟秋，轻解罗裳，独上兰舟，云中谁寄锦书来，雁字回时，月满西楼。花自飘零...',
        ),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: BorderSide.none,
            backgroundColor: Colors.white,
            foregroundColor: Color(0xff6183FF),
            textStyle: TextStyle(fontSize: 14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [Text('查看更多'), Icon(Icons.arrow_forward_ios, size: 12)],
          ),
        ),
      ],
    );
  }
}

/// 年度报告
class _YearReportContainer extends StatelessWidget {
  const _YearReportContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(12),
          height: 120,
          child: Row(
            spacing: 10,
            children: [
              Image.asset(
                'assets/example/report.png',
                width: 75,
                height: 100,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2026年度报告',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '个人趋势洞察，预见你的先机和问题。',
                      style: TextStyle(fontSize: 12, color: Color(0xff808080)),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '11233人已解锁',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff808080),
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide.none,
                            minimumSize: Size(0, 0),
                            fixedSize: Size(80, 30),
                            padding: EdgeInsets.zero,
                            backgroundColor: Color(0xff6382EB),
                            foregroundColor: Colors.white,
                            textStyle: TextStyle(fontSize: 12),
                          ),
                          child: Text('预览报告'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(12),
          height: 120,
          child: Row(
            spacing: 10,
            children: [
              Image.asset(
                'assets/example/report.png',
                width: 75,
                height: 100,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2025年度报告',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '个人趋势洞察，预见你的先机和问题。',
                      style: TextStyle(fontSize: 12, color: Color(0xff808080)),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '11233人已解锁',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff808080),
                            ),
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide.none,
                            minimumSize: Size(0, 0),
                            fixedSize: Size(80, 30),
                            padding: EdgeInsets.zero,
                            backgroundColor: Color(0xff6382EB),
                            foregroundColor: Colors.white,
                            textStyle: TextStyle(fontSize: 12),
                          ),
                          child: Text('预览报告'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            side: BorderSide.none,
            backgroundColor: Colors.white,
            foregroundColor: Color(0xff6183FF),
            textStyle: TextStyle(fontSize: 14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5,
            children: [Text('查看更多'), Icon(Icons.arrow_forward_ios, size: 12)],
          ),
        ),
      ],
    );
  }
}
