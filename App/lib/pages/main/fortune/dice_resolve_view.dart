import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:freud/widgets/gradient_text.dart';
import 'package:get/get.dart';

import '../widgets/resolve_price_item.dart';
import 'dice_resolve_controller.dart';

class DiceResolvePage extends GetView<DiceResolveController> {
  const DiceResolvePage({super.key});

  _buildDiceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          spacing: 10,
          children: [
            CircleAvatar(radius: 20, backgroundColor: Colors.grey),
            Text('水瓶'),
          ],
        ),
        Column(
          spacing: 10,
          children: [
            CircleAvatar(radius: 20, backgroundColor: Colors.grey),
            Text('水瓶'),
          ],
        ),
        Column(
          spacing: 10,
          children: [
            CircleAvatar(radius: 20, backgroundColor: Colors.grey),
            Text('水瓶'),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DiceResolveController());
    return Scaffold(
      appBar: AppBar(title: const Text('咨询师解读'), backgroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              _buildDiceRow(),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xffF7FAFC),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Text(
                      '咨询师解读',
                      style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
                    ),
                    Text('我的另一半会什么时候出现？'),
                  ],
                ),
              ),
              Text(
                '请选择解答的咨询师数量',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  ResolvePriceItem(title: '1位咨询师', price: '18.00'),
                  ResolvePriceItem(
                    title: '2位咨询师',
                    price: '28.00',
                    tips: '特惠x元',
                    selected: true,
                  ),
                  ResolvePriceItem(
                    title: '2位咨询师',
                    price: '28.00',
                    tips: '特惠',
                    selected: false,
                  ),
                  ResolvePriceItem(
                    title: '2位咨询师',
                    price: '28.00',
                    tips: '特惠',
                    selected: false,
                  ),
                  ResolvePriceItem(
                    title: '2位咨询师',
                    price: '28.00',
                    tips: '特惠',
                    selected: false,
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 4),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsGeometry.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        spacing: 4,
                        children: [
                          Text(
                            '明细 原价￥36.00',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xffA6A6A6),
                            ),
                          ),
                          GradientText(
                            colors: [Color(0xffFF8138), Color(0xffFF4F4F)],
                            child: Text(
                              '特惠价￥28.00',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                          const Spacer(),
                          GradientText(
                            colors: [Color(0xffFF8138), Color(0xffFF4F4F)],
                            child: Text('优惠8元', style: TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                    GradientButton(
                      onPressed: () {},
                      width: double.infinity,
                      height: 40,
                      foregroundColor: Color(0xffFFD5A8),
                      child: Text('获得解析', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
