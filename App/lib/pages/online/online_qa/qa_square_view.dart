import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:freud/widgets/component/select_archive.dart';
import 'package:freud/widgets/empty_tips.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:freud/widgets/gradient_text.dart';
import 'package:get/get.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

import '../../../widgets/refresh_loadmore.dart';
import '../../main/widgets/resolve_price_item.dart';
import 'qa_square_controller.dart';

class QaSquarePage extends GetView<QaSquareController> {
  const QaSquarePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => QaSquareController());

    return Scaffold(
      appBar: AppBar(title: const Text('问题广场'), backgroundColor: Colors.white),
      body: Obx(() {
        if (controller.isLoading.value && controller.listData.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!controller.isLoading.value && controller.listData.isEmpty) {
          return const Center(child: EmptyTips(title: '暂无数据'));
        }

        return RefreshLoadmore(
          controller: controller.refreshController,
          onRefresh: () async {
            await controller.listRefresh();
          },
          onLoad: () async {
            await controller.loadMore();
          },
          child: WaterfallFlow.builder(
            padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
            gridDelegate: SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              lastChildLayoutTypeBuilder: (index) =>
                  index == controller.listData.length
                  ? LastChildLayoutType.foot
                  : LastChildLayoutType.none,
            ),
            itemCount: controller.listData.length,
            itemBuilder: (context, index) {
              final item = controller.listData[index];
              return _QaSquareCard(item: item);
            },
          ),
        );
      }),
    );
  }
}

class _QaSquareCard extends StatelessWidget {
  final Map<String, dynamic> item;

  const _QaSquareCard({required this.item});

  void _showAskBottomSheet(BuildContext context) {
    DialogUtil.showModalBottom(
      context: context,
      child: const _AskBottomSheetContent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF7F9FF), Color(0xFFFFFFFF), Color(0xFFFFFFFF)],
          stops: [0.0, 0.3, 1.0],
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Image.asset(item['icon'] as String, width: 18, height: 18),
              const SizedBox(width: 4),
              Text(
                item['category'] as String,
                style: const TextStyle(fontSize: 12, color: Color(0xff383838)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 44,
            child: Text(
              item['title'] as String,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Color(0xff383838)),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 42,
                height: 18,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: List.generate(3, (i) {
                    return Positioned(
                      left: i * 12.0,
                      child: CircleAvatar(
                        radius: 9,
                        backgroundColor: Colors.grey[300],
                        foregroundImage: ImageView.provider(
                          'https://picsum.photos/100/100?t=1',
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '${item['askCount']}人已问过',
                style: const TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GradientButton(
            onPressed: () => _showAskBottomSheet(context),
            height: 28,
            width: 86,
            child: const Text(
              '我也要问',
              style: TextStyle(fontSize: 12, color: Color(0xffFFD5A8)),
            ),
          ),
        ],
      ),
    );
  }
}

class _AskBottomSheetContent extends StatefulWidget {
  const _AskBottomSheetContent();

  @override
  State<_AskBottomSheetContent> createState() => _AskBottomSheetContentState();
}

class _AskBottomSheetContentState extends State<_AskBottomSheetContent> {
  late final TextEditingController _contentController;
  var _selectedPrice = 2;
  Archive? _archive;

  final _priceData = [
    {'title': '1位咨询师', 'price': '18.00', 'originalPrice': '36.00', 'num': 1},
    {
      'title': '2位咨询师',
      'price': '28.00',
      'originalPrice': '36.00',
      'num': 2,
      'tips': '特惠x元',
    },
    {
      'title': '3位咨询师',
      'price': '38.00',
      'originalPrice': '56.00',
      'num': 3,
      'tips': '特惠',
    },
    {
      'title': '4位咨询师',
      'price': '48.00',
      'originalPrice': '66.00',
      'num': 4,
      'tips': '特惠',
    },
    {
      'title': '5位咨询师',
      'price': '58.00',
      'originalPrice': '76.00',
      'num': 5,
      'tips': '特惠',
    },
  ];

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedItem = _priceData.firstWhere(
      (e) => e['num'] == _selectedPrice,
    );
    final originalPrice = selectedItem['originalPrice'] as String;
    final price = selectedItem['price'] as String;
    final originalNum = double.parse(originalPrice);
    final curNum = double.parse(price);
    final discount = (originalNum - curNum).toStringAsFixed(0);

    return GestureDetector(
      onTap: () => CommonUtil.hideKeyShowUnfocus(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '星盘提问',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const Icon(Icons.close, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 15),
          SelectArchive(
            placeholder: '请选择档案',
            value: _archive,
            trailing: _archive != null
                ? Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(
                      '更换档案',
                      style: TextStyle(fontSize: 14, color: Color(0xff8391DE)),
                    ),
                  )
                : null,
            onSelected: (value) {
              setState(() {
                _archive = value;
              });
            },
          ),
          const SizedBox(height: 15),
          TextField(
            controller: _contentController,
            maxLines: 5,
            minLines: 5,
            style: const TextStyle(fontSize: 14),
            decoration: const InputDecoration(
              hintText: '一次只能问一个问题哦~',
              hintStyle: TextStyle(color: Color(0xffBDBDBD)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Color(0xffF7F9FF),
              contentPadding: EdgeInsets.all(10),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            '请选择解答的咨询师数量',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - 30) / 3;
              return Wrap(
                spacing: 15,
                runSpacing: 15,
                children: _priceData.map((item) {
                  final num = item['num'] as int;
                  return ResolvePriceItem(
                    title: item['title'] as String,
                    price: item['price'] as String,
                    tips: item['tips'] as String?,
                    selected: _selectedPrice == num,
                    width: width,
                    onTap: () {
                      setState(() {
                        _selectedPrice = num;
                      });
                    },
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 50),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    spacing: 4,
                    children: [
                      Text(
                        '明细 原价￥$originalPrice',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xffA6A6A6),
                        ),
                      ),
                      GradientText(
                        colors: [Color(0xffFF8138), Color(0xffFF4F4F)],
                        child: Text(
                          '特惠价￥$price',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const Spacer(),
                      GradientText(
                        colors: [Color(0xffFF8138), Color(0xffFF4F4F)],
                        child: Text(
                          '优惠$discount元',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                GradientButton(
                  onPressed: () {},
                  width: double.infinity,
                  height: 40,
                  foregroundColor: const Color(0xffFFD5A8),
                  child: const Text('获得解答', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
