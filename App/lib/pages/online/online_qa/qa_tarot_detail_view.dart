import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/router/app_routes.dart';
import 'package:get/get.dart';

import '../../../widgets/component/icon_widget.dart';
import 'qa_tarot_detail_controller.dart';

class QaTarotDetailPage extends GetView<QaTarotDetailController> {
  const QaTarotDetailPage({super.key});

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
    Get.lazyPut(() => QaTarotDetailController());
    return Scaffold(
      appBar: AppBar(title: const Text('塔罗解读')),
      floatingActionButton: GestureDetector(
        onTap: () {
          Get.toNamed(AppRoutes.QA_TAROT_ORDER, arguments: {
            'cards': controller.cards.toList(),
            'question': controller.question.value,
          });
        },
        child: IconWidget(icon: 'icon_zxsjd.png', size: 96),
      ),
      body: Obx(() {
        if (controller.loading.value) {
          return const Center(child: CircularProgressIndicator());
        }

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
                      controller: TextEditingController(text: controller.question.value),
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
                  if (cards.isNotEmpty)
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
              ),
            ),
          ),
        );
      }),
    );
  }
}
