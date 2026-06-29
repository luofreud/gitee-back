import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import 'dice_detail_controller.dart';

class DiceDetailPage extends GetView<DiceDetailController> {
  const DiceDetailPage({super.key});

  Widget _buildIcon(Map item, double radius) {
    switch (item['type']) {
      case 'planet':
        {
          final id = item['id'] as int;
          final icon = id < AppConst.XINGXING_ICON.length
              ? AppConst.XINGXING_ICON[id].icon
              : '';
          return IconWidget(icon: 'xingpan/$icon.png', size: radius * 2);
        }
      case 'house':
        return CircleAvatar(
          radius: radius,
          backgroundColor: Color(0xffedf5ff),
          child: Text(
            '${(item['id'] as int) + 1}',
            style: TextStyle(
              color: Color(0xff2A82E4),
              fontWeight: FontWeight.w500,
              fontSize: radius * 1.2,
            ),
          ),
        );
      case 'constellation':
        {
          final id = item['id'] as int;
          final icon = id < AppConst.CONSTELLATION.length
              ? AppConst.CONSTELLATION[id].icon
              : '';
          return IconWidget(icon: 'constellation/$icon.png', size: radius * 2);
        }
    }
    return CircleAvatar(radius: radius, backgroundColor: Colors.grey);
  }

  Widget _buildDiceRow() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: controller.items
            .map(
              (item) => Column(
                spacing: 10,
                children: [
                  _buildIcon(item, 20),
                  Text(
                    item['title'] as String,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildResolveItem(Map item) {
    final desc = (item['desc'] as List<dynamic>).cast<String>();
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff202A3B).withAlpha(100),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffBDC9FF).withAlpha(100)),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 5,
            children: [
              _buildIcon(item, 12),
              Text(
                item['title'] as String,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          ...desc.map(
            (d) => Text(d, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DiceDetailController());
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/dice_detail_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('骰子', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black.withAlpha(0),
          foregroundColor: Colors.white,
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Obx(() {
            if (controller.loading.value) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox.shrink(),
                _buildDiceRow(),
                const SizedBox(height: 10),
                ...controller.items.map(_buildResolveItem),
                Row(
                  spacing: 5,
                  children: [
                    const Icon(Icons.info, color: Colors.white, size: 16),
                    Expanded(
                      child: Text(
                        '当前内容为免费内容，仅供您在娱乐中探索自我，无任何现实指导意义。',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                GradientButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.DICE_RESOLVE);
                  },
                  width: double.infinity,
                  height: 40,
                  foregroundColor: const Color(0xffFFD2A6),
                  gradient: const LinearGradient(
                    colors: [Color(0xff8247FF), Color(0xff496FE3)],
                  ),
                  child: const Text('咨询师解读'),
                ),
                const SizedBox(height: 10),
              ],
            );
          }),
        ),
      ),
    );
  }
}
