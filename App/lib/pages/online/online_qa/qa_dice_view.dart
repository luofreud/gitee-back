import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/widgets/component/icon_widget.dart';
import 'package:get/get.dart';

import '../../../widgets/gradient_button.dart';
import '../../../widgets/gradient_text.dart';
import '../../main/widgets/resolve_price_item.dart';
import 'qa_dice_controller.dart';

class QaDicePage extends GetView<QaDiceController> {
  const QaDicePage({super.key});

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
          backgroundColor: const Color(0xffedf5ff),
          child: Text(
            '${(item['id'] as int) + 1}',
            style: TextStyle(
              color: const Color(0xff2A82E4),
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
        children: controller.diceItems
            .map(
              (item) => Column(
                spacing: 10,
                children: [
                  _buildIcon(item, 20),
                  Text(
                    item['title'] as String,
                    style: const TextStyle(color: Color(0xff383838)),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => QaDiceController());

    return Scaffold(
      appBar: AppBar(title: const Text('骰子解读'), backgroundColor: Colors.white),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
        padding: EdgeInsets.all(AppConst.PAGE_PADDING),
        child: Card(
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.all(AppConst.PAGE_PADDING),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                _buildDiceRow(),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffF7FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(AppConst.PAGE_PADDING),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text(
                        '我要咨询的问题',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xffA6A6A6),
                        ),
                      ),
                      TextField(
                        readOnly: true,
                        controller: TextEditingController(
                          text: controller.question.value ?? '',
                        ),

                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        minLines: 5,
                        maxLines: 5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  '请选择解答的咨询师数量',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 14),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = (constraints.maxWidth - 30) / 3;
                    return Obx(() {
                      return Wrap(
                        spacing: 15,
                        runSpacing: 15,
                        children: controller.priceData.map((item) {
                          final num = item['num'] as int;
                          return ResolvePriceItem(
                            title: item['title'] as String,
                            price: item['price'] as String,
                            tips: item['tips'] as String?,
                            selected: controller.selectedPrice.value == num,
                            width: width,
                            onTap: () {
                              controller.selectedPrice.value = num;
                            },
                          );
                        }).toList(),
                      );
                    });
                  },
                ),
                const SizedBox(height: 50),
                Obx(() {
                  final item = controller.priceData.firstWhere(
                    (e) => e['num'] == controller.selectedPrice.value,
                  );
                  final originalPrice = item['originalPrice'] as String;
                  final price = item['price'] as String;
                  final originalNum = double.parse(originalPrice);
                  final curNum = double.parse(price);
                  final discount = (originalNum - curNum).toStringAsFixed(0);
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            spacing: 4,
                            children: [
                              Text(
                                '明细 原价￥$originalPrice',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xffA6A6A6),
                                ),
                              ),
                              GradientText(
                                colors: [Color(0xffFF8138), Color(0xffFF4F4F)],
                                child: Text(
                                  '特惠价￥$price',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              const Spacer(),
                              GradientText(
                                colors: [Color(0xffFF8138), Color(0xffFF4F4F)],
                                child: Text(
                                  '优惠$discount元',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GradientButton(
                          onPressed: () => controller.submitQuestion(),
                          width: double.infinity,
                          height: 40,
                          foregroundColor: Color(0xffFFD5A8),
                          child: Text('获得解析', style: TextStyle(fontSize: 16)),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
  }),
    );
  }
}
