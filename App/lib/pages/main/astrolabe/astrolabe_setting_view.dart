import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import '../../../widgets/component/menu_list_tile.dart';
import '../../../widgets/component/switch_widget.dart';
import 'astrolabe_setting_controller.dart';

class AstrolabeSettingPage extends GetView<AstrolabeSettingController> {
  const AstrolabeSettingPage({super.key});

  static final Widget _divider = Divider(
    height: 1,
    color: Color(0xffF5F7F9),
    indent: AppConst.PAGE_PADDING,
    endIndent: AppConst.PAGE_PADDING,
  );
  static final contentPadding = EdgeInsets.only(
    left: 12,
    right: 14,
    top: 2,
    bottom: 2,
  );

  /// 行星
  _buildPlanet() {
    return Obx(() {
      return Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            ...controller.planetDisplayList.asMap().entries.map((entry) {
              final index = entry.key;
              final planet = entry.value;
              final value = planet['value'] as String;
              final alwaysSelected = planet['alwaysSelected'] == true;

              return Column(
                children: [
                  MenuListTile(
                    title: planet['name'] as String,
                    radiusPosition: index == 0 ? RadiusPosition.top : null,
                    showArrow: false,
                    contentPadding: contentPadding,
                    trailing: alwaysSelected
                        ? null
                        : Obx(
                            () => SwitchWidget(
                              value: controller.planetSelectedValues.contains(
                                value,
                              ),
                              onChanged: (v) =>
                                  controller.togglePlanet(value, v),
                            ),
                          ),
                  ),
                  _divider,
                ],
              );
            }),
            MenuListTile(
              title: controller.planetShowAll.value ? '收起' : '全部星体',
              radiusPosition: RadiusPosition.bottom,
              showArrow: false,
              trailing: Transform.rotate(
                angle: (controller.planetShowAll.value ? -90 : 90) * pi / 180,
                child: Image.asset(
                  'assets/icons/icon_arrow_right.png',
                  width: 16,
                  height: 16,
                ),
              ),
              onTap: () => controller.togglePlanetShowAll(),
            ),
          ],
        ),
      );
    });
  }

  /// 虚点
  _buildPoint() {
    return Obx(() {
      return Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            ...controller.pointDisplayList.asMap().entries.map((entry) {
              final index = entry.key;
              final point = entry.value;
              final value = point['value'] as String;

              return Column(
                children: [
                  MenuListTile(
                    title: point['name'] as String,
                    radiusPosition: index == 0 ? RadiusPosition.top : null,
                    showArrow: false,
                    contentPadding: contentPadding,
                    trailing: Obx(
                      () => SwitchWidget(
                        value: controller.pointSelectedValues.contains(value),
                        onChanged: (v) => controller.togglePoint(value, v),
                      ),
                    ),
                  ),
                  _divider,
                ],
              );
            }),
            MenuListTile(
              title: controller.pointShowAll.value ? '收起' : '全部虚点',
              radiusPosition: RadiusPosition.bottom,
              showArrow: false,
              trailing: Transform.rotate(
                angle: (controller.pointShowAll.value ? -90 : 90) * pi / 180,
                child: Image.asset(
                  'assets/icons/icon_arrow_right.png',
                  width: 16,
                  height: 16,
                ),
              ),
              onTap: () => controller.togglePointShowAll(),
            ),
          ],
        ),
      );
    });
  }

  /// 小行星
  _buildAsteroid() {
    return Obx(() {
      return Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            ...controller.asteroidDisplayList.asMap().entries.map((entry) {
              final index = entry.key;
              final asteroid = entry.value;
              final value = asteroid['value'] as String;

              return Column(
                children: [
                  MenuListTile(
                    title: asteroid['name'] as String,
                    radiusPosition: index == 0 ? RadiusPosition.top : null,
                    showArrow: false,
                    contentPadding: contentPadding,
                    trailing: Obx(
                      () => SwitchWidget(
                        value: controller.asteroidSelectedValues.contains(
                          value,
                        ),
                        onChanged: (v) => controller.toggleAsteroid(value, v),
                      ),
                    ),
                  ),
                  _divider,
                ],
              );
            }),
            MenuListTile(
              title: controller.asteroidShowAll.value ? '收起' : '全部小行星',
              radiusPosition: RadiusPosition.bottom,
              showArrow: false,
              trailing: Transform.rotate(
                angle: (controller.asteroidShowAll.value ? -90 : 90) * pi / 180,
                child: Image.asset(
                  'assets/icons/icon_arrow_right.png',
                  width: 16,
                  height: 16,
                ),
              ),
              onTap: () => controller.toggleAsteroidShowAll(),
            ),
          ],
        ),
      );
    });
  }

  /// 合相
  _buildPhase(context) {
    return Obx(() {
      return Card(
        elevation: 0,
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          children: [
            ...controller.phaseDisplayList.asMap().entries.map((entry) {
              final index = entry.key;
              final phase = entry.value;
              final value = phase['value'] as String;
              final listType = phase['listType'] as int;
              final orbList = listType == 1
                  ? controller.xiangweiList1
                  : controller.xiangweiList2;

              return Column(
                children: [
                  MenuListTile(
                    title: phase['name'] as String,
                    radiusPosition: index == 0 ? RadiusPosition.top : null,
                    showArrow: false,
                    contentPadding: contentPadding,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10,
                      children: [
                        Obx(
                          () => SwitchWidget(
                            value: controller.phaseSelectedValues.contains(
                              value,
                            ),
                            onChanged: (v) => controller.togglePhase(value, v),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            final current =
                                controller.phaseValues[value] ??
                                '${orbList[0]}';
                            DialogUtil.showModalBottom(
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: orbList.map((item) {
                                      final isSelected = '$item' == current;
                                      return GestureDetector(
                                        onTap: () {
                                          controller.updatePhaseValue(
                                            value,
                                            '$item',
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: 32,
                                          width:
                                              (MediaQuery.of(
                                                    context,
                                                  ).size.width -
                                                  70) /
                                              5,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: isSelected
                                                ? null
                                                : Border.all(
                                                    color: Color(0xff383838),
                                                    width: 1,
                                                  ),
                                            color: isSelected
                                                ? null
                                                : Colors.white,
                                            gradient: isSelected
                                                ? LinearGradient(
                                                    colors: [
                                                      Color(0xff9255D9),
                                                      Color(0xff325EE3),
                                                    ],
                                                  )
                                                : null,
                                          ),
                                          child: Text(
                                            '$item',
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : Color(0xff383838),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            );
                          },
                          child: Obx(
                            () => Text(
                              '${controller.phaseValues[value] ?? orbList[0]}°',
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/icons/icon_arrow_right.png',
                          width: 16,
                          height: 16,
                        ),
                      ],
                    ),
                  ),
                  _divider,
                ],
              );
            }),
            MenuListTile(
              title: controller.phaseShowAll.value ? '收起' : '全部相位',
              radiusPosition: RadiusPosition.bottom,
              showArrow: false,
              trailing: Transform.rotate(
                angle: (controller.phaseShowAll.value ? -90 : 90) * pi / 180,
                child: Image.asset(
                  'assets/icons/icon_arrow_right.png',
                  width: 16,
                  height: 16,
                ),
              ),
              onTap: () => controller.togglePhaseShowAll(),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AstrolabeSettingController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('星盘设置'),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => controller.resetToDefault(),
            child: const Text(
              '重置',
              style: TextStyle(color: Color(0xff383838), fontSize: 14),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Obx(() {
                    return MenuListTile(
                      title: '恒星模式',
                      radiusPosition: RadiusPosition.top,
                      titlevalue: controller.selectedStarModeName,
                      contentPadding: contentPadding,
                      onTap: () {
                        DialogUtil.showModalBottom(
                          context: context,
                          builder: (context) {
                            final itemHeight = 56.0;
                            final contentHeight =
                                controller.starModeList.length * itemHeight +
                                60;
                            return SizedBox(
                              height: contentHeight.clamp(
                                0,
                                MediaQuery.of(context).size.height * 0.6,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 15,
                                    ),
                                    child: const Text(
                                      '选择恒星模式',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Flexible(
                                    child: ListView.builder(
                                      itemCount: controller.starModeList.length,
                                      itemBuilder: (context, index) {
                                        final item =
                                            controller.starModeList[index];
                                        final selected =
                                            controller.selectedStarMode.value ==
                                            item['value'];
                                        return ListTile(
                                          title: Text(item['name'] as String),
                                          trailing: selected
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Color(0xff4D1FAE),
                                                )
                                              : null,
                                          onTap: () {
                                            controller.setSelectedStarMode(
                                                item['value'] as String);
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  }),
                  _divider,
                  Obx(() {
                    return MenuListTile(
                      title: '宫位',
                      titlevalue: controller.selectedHouseName,
                      radiusPosition: RadiusPosition.bottom,
                      contentPadding: contentPadding,
                      onTap: () {
                        DialogUtil.showModalBottom(
                          context: context,
                          builder: (context) {
                            final itemHeight = 56.0;
                            final contentHeight =
                                controller.houseList.length * itemHeight + 60;
                            return SizedBox(
                              height: contentHeight.clamp(
                                0,
                                MediaQuery.of(context).size.height * 0.6,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 15,
                                    ),
                                    child: const Text(
                                      '选择宫位系统',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ),
                                  Flexible(
                                    child: ListView.builder(
                                      itemCount: controller.houseList.length,
                                      itemBuilder: (context, index) {
                                        final item =
                                            controller.houseList[index];
                                        final selected =
                                            controller.selectedHouse.value ==
                                            item['value'];
                                        return ListTile(
                                          title: Text(item['name'] as String),
                                          trailing: selected
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Color(0xff4D1FAE),
                                                )
                                              : null,
                                          onTap: () {
                                            controller.setSelectedHouse(
                                                item['value'] as String);
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
            Text(
              '行星',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            _buildPlanet(),
            Text(
              '虚点',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            _buildPoint(),
            Text(
              '小行星',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            _buildAsteroid(),
            Text(
              '相位容许度',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            _buildPhase(context),
          ],
        ),
      ),
    );
  }
}
