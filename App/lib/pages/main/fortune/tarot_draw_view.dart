import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'tarot_draw_controller.dart';

class TarotDrawPage extends GetView<TarotDrawController> {
  const TarotDrawPage({super.key});

  double _calcOffsetWidth(BuildContext context) {
    return ((MediaQuery.of(context).size.width - 30 - 55) / 19)
        .clamp(10.0, 30.0);
  }

  Widget _buildDeck(double offsetWidth) {
    return Container(
      key: controller.deckKey,
      child: Obx(() {
        return Stack(
          children: [
            SizedBox(width: 19 * offsetWidth + 55, height: 88),
            ...List.generate(controller.remainingCards.value, (index) {
              return Positioned(
                left: index * offsetWidth,
                top: 0,
                child: Image.asset(
                  'assets/images/tarot_poker.png',
                  width: 55,
                  height: 88,
                  fit: BoxFit.fill,
                ),
              );
            }),
          ],
        );
      }),
    );
  }

  Widget _buildSlot(int index, String label, double offsetWidth) {
    return GestureDetector(
      onTap: () => controller.drawCard(index, offsetWidth),
      child: Column(
        spacing: 5,
        children: [
          Container(
            key: controller.slotKeys[index],
            alignment: Alignment.center,
            width: 55,
            height: 88,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xff808080), width: 1),
            ),
            child: Obx(() {
              if (controller.drawnCards[index] != null) {
                return Image.asset(
                  'assets/images/tarot_poker.png',
                  width: 55,
                  height: 88,
                  fit: BoxFit.fill,
                );
              }
              return const Icon(Icons.add, color: Color(0xffCCCCCC), size: 48);
            }),
          ),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => TarotDrawController());
    final offsetWidth = _calcOffsetWidth(context);

    return Scaffold(
      appBar: AppBar(title: const Text('智慧牌')),
      body: Stack(
        key: controller.stackKey,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity, height: 50),
              _buildDeck(offsetWidth),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSlot(0, '①过去', offsetWidth),
                  _buildSlot(1, '②现在', offsetWidth),
                ],
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSlot(2, '③未来', offsetWidth),
                ],
              ),
            ],
          ),
          Obx(() {
            if (!controller.isAnimating.value) return const SizedBox.shrink();
            return Positioned(
              left: controller.flyOffset.value.dx,
              top: controller.flyOffset.value.dy,
              child: Image.asset(
                'assets/images/tarot_poker.png',
                width: 55,
                height: 88,
                fit: BoxFit.fill,
              ),
            );
          }),
        ],
      ),
    );
  }
}
