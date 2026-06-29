import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:get/get.dart';

import 'astrolabe_parameter_controller.dart';
import 'utils/parsing.dart';

class AstrolabeParameterPage extends GetView<AstrolabeParameterController> {
  const AstrolabeParameterPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AstrolabeParameterController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('参数'), backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConst.PAGE_PADDING,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final archive = controller.analysisCtrl.archiveDetail.value;
              return Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                      'assets/images/default_avatar.png',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 3,
                      children: [
                        Text(
                          archive?.name ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          archive?.birthday ?? '',
                          style: const TextStyle(fontSize: 12, height: 1),
                        ),
                        Text(
                          archive?.address ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
            Obx(() {
              final planetData = controller.currentChartData.value?['planet'];
              final parsed = parseChartData(planetData);
              final planets = parsed.placements
                  .where((p) => p.type == CelestialType.planet)
                  .toList();
              final asteroids = parsed.placements
                  .where((p) => p.type == CelestialType.asteroid)
                  .toList();
              final isEmpty = parsed.patterns.isEmpty &&
                  planets.isEmpty &&
                  asteroids.isEmpty &&
                  parsed.phases.isEmpty;
              if (isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (parsed.patterns.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text('星盘格局',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    _buildPatternTable(parsed.patterns),
                  ],
                  if (planets.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text('行星信息',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    _buildPlacementTable(planets, const Color(0xFFE6F4FF)),
                  ],
                  if (asteroids.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text('小行星信息',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    _buildPlacementTable(asteroids, const Color(0xFFFFF0E6)),
                  ],
                  if (parsed.phases.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text('相位信息',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    _buildPhaseTable(parsed.phases),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPatternTable(List<GrandPattern> patterns) {
    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(10)),
      child: Column(
        children: [
          Container(
            color: const Color(0xFFFFE6FD),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text('名称', textAlign: TextAlign.center)),
                Expanded(
                    flex: 2,
                    child: Text('星体', textAlign: TextAlign.center)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFEBEBF2)),
            ),
            child: Column(
              children: patterns.asMap().entries.map((entry) {
                final p = entry.value;
                final isLast = entry.key == patterns.length - 1;
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: isLast
                          ? BorderSide.none
                          : const BorderSide(
                              color: Color(0xFFEBEBF2)),
                    ),
                  ),
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(p.name,
                              textAlign: TextAlign.center)),
                      VerticalDivider(
                          color: const Color(0xFFEBEBF2),
                          thickness: 1,
                          width: 1),
                      Expanded(
                          flex: 2,
                          child: Text(p.planets.join('、'),
                              textAlign: TextAlign.center)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlacementTable(
      List<PlanetPlacement> placements, Color headerColor) {
    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(10)),
      child: Column(
        children: [
          Container(
            color: headerColor,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text('星体', textAlign: TextAlign.center)),
                Expanded(
                    flex: 2,
                    child:
                        Text('星座度数', textAlign: TextAlign.center)),
                Expanded(
                    flex: 1,
                    child: Text('宫位', textAlign: TextAlign.center)),
                Expanded(
                    flex: 1,
                    child: Text('逆行', textAlign: TextAlign.center)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFEBEBF2)),
            ),
            child: Column(
              children: placements.asMap().entries.map((entry) {
                final p = entry.value;
                final isLast = entry.key == placements.length - 1;
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: isLast
                          ? BorderSide.none
                          : const BorderSide(
                              color: Color(0xFFEBEBF2)),
                    ),
                  ),
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Text(p.planetName,
                              textAlign: TextAlign.center)),
                      VerticalDivider(
                          color: const Color(0xFFEBEBF2),
                          thickness: 1,
                          width: 1),
                      Expanded(
                          flex: 2,
                          child: Text(
                              '${p.signName}${p.signDeg}°${p.signMin}',
                              textAlign: TextAlign.center)),
                      VerticalDivider(
                          color: const Color(0xFFEBEBF2),
                          thickness: 1,
                          width: 1),
                      Expanded(
                          flex: 1,
                          child: Text('${p.houseId}宫',
                              textAlign: TextAlign.center)),
                      VerticalDivider(
                          color: const Color(0xFFEBEBF2),
                          thickness: 1,
                          width: 1),
                      Expanded(
                          flex: 1,
                          child: Text(p.isRetrograde ? '逆行' : '顺行',
                              textAlign: TextAlign.center)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseTable(List<PhaseEntry> phases) {
    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(10)),
      child: Column(
        children: [
          Container(
            color: const Color(0xFFF0E6FF),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Row(
              children: [
                Expanded(
                    flex: 2,
                    child: Text('相位', textAlign: TextAlign.center)),
                Expanded(
                    flex: 1,
                    child: Text('方向', textAlign: TextAlign.center)),
                Expanded(
                    flex: 1,
                    child: Text('容许度', textAlign: TextAlign.center)),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFEBEBF2)),
            ),
            child: Column(
              children: phases.asMap().entries.map((entry) {
                final p = entry.value;
                final isLast = entry.key == phases.length - 1;
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: isLast
                          ? BorderSide.none
                          : const BorderSide(
                              color: Color(0xFFEBEBF2)),
                    ),
                  ),
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Text(p.label,
                              textAlign: TextAlign.center)),
                      VerticalDivider(
                          color: const Color(0xFFEBEBF2),
                          thickness: 1,
                          width: 1),
                      Expanded(
                          flex: 1,
                          child: Text(p.isInbound ? '入相' : '出相',
                              textAlign: TextAlign.center)),
                      VerticalDivider(
                          color: const Color(0xFFEBEBF2),
                          thickness: 1,
                          width: 1),
                      Expanded(
                          flex: 1,
                          child: Text(p.orb,
                              textAlign: TextAlign.center)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
