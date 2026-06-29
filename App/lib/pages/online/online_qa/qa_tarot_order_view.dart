import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:get/get.dart';

import '../../../widgets/gradient_button.dart';
import '../../../widgets/gradient_text.dart';
import '../../main/widgets/resolve_price_item.dart';
import 'qa_tarot_order_controller.dart';

class QaTarotOrderPage extends GetView<QaTarotOrderController> {
  const QaTarotOrderPage({super.key});

  static const _labels = ['①过去', '②现在', '③未来'];

  Widget _buildSlot(Map<String, dynamic>? card, String label) {
    final imagePath = card != null
        ? controller.getCardImagePath(card['id'] as int)
        : null;
    return Column(
      spacing: 5,
      children: [
        Container(
          alignment: Alignment.center,
          width: 55,
          height: 88,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff808080), width: 1),
          ),
          child: imagePath != null
              ? Image.asset(imagePath, width: 55, height: 88, fit: BoxFit.fill)
              : const Icon(Icons.add, color: Color(0xffCCCCCC), size: 48),
        ),
        Text(label),
      ],
    );
  }

  Widget _buildCardDetail(Map<String, dynamic> card, int index) {
    final title = card['title'] as String? ?? '';
    final explain = card['explain'] as String? ?? '';
    final negative = card['negative'] as String? ?? '';
    final position = controller.getCardPosition(negative);
    final extraFields = controller.getExtraFields(card);

    final label = ['①', '②', '③'][index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          '$label 牌名：$title        牌位：$position',
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          '象征意义：$explain',
          style: const TextStyle(fontSize: 14, color: Color(0xff808080)),
        ),
        for (final field in extraFields)
          Text(
            '${controller.getFieldLabel(field.key)}：${field.value}',
            style: const TextStyle(fontSize: 14, color: Color(0xff808080)),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => QaTarotOrderController());
    return Scaffold(
      appBar: AppBar(title: const Text('塔罗解读'), backgroundColor: Colors.white),
      body: Obx(() {
        final cards = controller.cards;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppConst.PAGE_PADDING),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            shadowColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  const Text('您咨询的问题', style: TextStyle(fontSize: 16)),
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
                        text: controller.question.value,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      minLines: 1,
                      maxLines: 5,
                    ),
                  ),
                  const Text('抽取结果（通用牌阵）', style: TextStyle(fontSize: 16)),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xffF7FAFC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSlot(
                              cards.isNotEmpty ? cards[0] : null,
                              _labels[0],
                            ),
                            _buildSlot(
                              cards.isNotEmpty ? cards[1] : null,
                              _labels[1],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildSlot(
                              cards.isNotEmpty ? cards[2] : null,
                              _labels[2],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    if (cards.isEmpty) return const SizedBox.shrink();
                    if (!controller.showFull.value) {
                      return GestureDetector(
                        onTap: () => controller.toggleShowFull(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.keyboard_double_arrow_down,
                                size: 16,
                                color: const Color(0xff2A82E4),
                              ),
                              Text(
                                '展开看完整版',
                                style: TextStyle(
                                  color: const Color(0xff2A82E4),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 10,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xffF7FAFC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 10,
                            children: [
                              for (int i = 0; i < cards.length; i++)
                                _buildCardDetail(cards[i], i),
                            ],
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xffF7FAFC),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
                          child: Row(
                            spacing: 5,
                            children: [
                              const Icon(
                                Icons.info,
                                color: Color(0xffcccccc),
                                size: 16,
                              ),
                              Expanded(
                                child: Text(
                                  '当前内容为免费内容，仅供您在娱乐中探索自我，无任何现实指导意义。',
                                  style: TextStyle(
                                    color: const Color(0xff808080),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 14),
                  const Text(
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
                                  colors: [
                                    Color(0xffFF8138),
                                    Color(0xffFF4F4F),
                                  ],
                                  child: Text(
                                    '特惠价￥$price',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                const Spacer(),
                                GradientText(
                                  colors: [
                                    Color(0xffFF8138),
                                    Color(0xffFF4F4F),
                                  ],
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
