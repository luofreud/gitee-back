import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:get/get.dart';

import '../../../widgets/gradient_button.dart';
import '../../../widgets/gradient_text.dart';
import '../../main/widgets/resolve_price_item.dart';
import 'qa_astrolabe_controller.dart';

class QaAstrolabePage extends GetView<QaAstrolabeController> {
  const QaAstrolabePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => QaAstrolabeController());
    final textStyle = TextStyle(fontSize: 14, color: Color(0xffA6A6A6));

    return Scaffold(
      appBar: AppBar(title: const Text('星盘解读'), backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppConst.PAGE_PADDING),
        child: Card(
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.all(AppConst.PAGE_PADDING),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffF7FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(AppConst.PAGE_PADDING),
                  child: Text(
                    controller.archive.value?.name ?? '未选择',
                    style: textStyle,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xffF7FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.all(AppConst.PAGE_PADDING),
                  child: TextField(
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
      ),
    );
  }
}
