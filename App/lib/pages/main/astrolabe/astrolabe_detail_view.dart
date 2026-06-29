import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:get/get.dart';

import '../widgets/fortune_item_widget.dart';
import 'astrolabe_detail_controller.dart';

class AstrolabeDetailPage extends GetView<AstrolabeDetailController> {
  const AstrolabeDetailPage({super.key});

  _buildBirthChartTabs() {
    return Row(
      spacing: 10,
      children: controller.birthChartTabs.map((item) {
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
  }

  Widget _buildBirthChartContainer() {
    return Obx(() {
      late Widget widget;
      switch (controller.birthChartTabStr.value) {
        case '星座解读':
          widget = _XzjdContainer();
          break;
        case '落宫分析':
          widget = _LgfxContainer();
          break;
        case '相位解析':
          widget = _XwjxContainer();
          break;
      }
      return widget;
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AstrolabeDetailController());
    return Scaffold(
      appBar: AppBar(title: Text('星盘分析'), backgroundColor: Colors.white),
      floatingActionButton: GestureDetector(
        child: IconWidget(icon: 'icon_zxsjd.png', size: 96),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
        child: Column(
          spacing: 12,
          children: [_buildBirthChartTabs(), _buildBirthChartContainer()],
        ),
      ),
    );
  }
}

class _XzjdContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AstrolabeDetailController>();
    return Obx(() {
      if (ctrl.xzjdList.isEmpty) return const SizedBox.shrink();
      return Column(
        spacing: 10,
        children: ctrl.xzjdList.map<Widget>((item) {
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
            contentLines: null,
          );
        }).toList(),
      );
    });
  }
}

class _LgfxContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AstrolabeDetailController>();
    return Obx(() {
      if (ctrl.lgfxList.isEmpty) return const SizedBox.shrink();
      return Column(
        spacing: 10,
        children: ctrl.lgfxList.map<Widget>((item) {
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
            contentLines: null,
          );
        }).toList(),
      );
    });
  }
}

class _XwjxContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<AstrolabeDetailController>();
    return Obx(() {
      final phases = ctrl.phaseList;
      if (phases.isEmpty) return const SizedBox.shrink();
      return Column(
        spacing: 10,
        children: phases.map((phase) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  phase.label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                Text(
                  '${phase.isInbound ? '入相' : '出相'} 容许度:${phase.orb}',
                  style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }
}
