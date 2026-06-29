import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/utils/utils.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import '../../../widgets/component/select_archive.dart';
import 'online_qa_controller.dart';

class OnlineQaPage extends GetView<OnlineQaController> {
  const OnlineQaPage({super.key});

  _buildTabContainer() {
    return Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Obx(() {
          return Row(
            spacing: 10,
            children: controller.tabs.map((item) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.tabIndex.value = item['title']!;
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Image.asset('assets/images/${item['image']}'),
                      controller.tabIndex.value == item['title']
                          ? Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Image.asset(
                                'assets/images/${item['active']}',
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => OnlineQaController());

    Widget _questionWidget = Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(AppConst.PAGE_PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Obx(() {
              var title = '';
              switch (controller.tabIndex.value) {
                case '星盘':
                  title = '以星盘提问';
                  break;
                case '骰子':
                  title = '骰子提问';
                case '合盘':
                  title = '以合盘关系提问';
                  break;
                case '智慧牌':
                  title = '塔罗答疑';
                  break;
              }
              return Text(title, style: TextStyle(fontSize: 16));
            }),
            _FormTextField(),
            GradientButton(
              onPressed: () {
                CommonUtil.hideKeyShowUnfocus();
                controller.submitQuestion();
              },
              width: double.infinity,
              height: 40,
              foregroundColor: Color(0xffFFD5A8),
              gradient: LinearGradient(
                colors: [Color(0xff4D1FAE), Color(0xff0A2063)],
              ),
              child: Text('获得解析'),
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      onTap: () {
        CommonUtil.hideKeyShowUnfocus();
      },
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppConst.PAGE_PADDING,
          right: AppConst.PAGE_PADDING,
          bottom: AppConst.PAGE_PADDING,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            _buildTabContainer(),
            Obx(() {
              if (controller.tabIndex.value == '骰子') {
                return SizedBox.shrink();
              }
              return _XpContainerWidget(title: controller.tabIndex.value);
            }),
            _questionWidget,
            Card(
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.all(AppConst.PAGE_PADDING),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('这些问题大家都在问', style: TextStyle(fontSize: 16)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Row(
                            spacing: 10,
                            children: [
                              _QaItemWidget(title: '你肯定会中这几条'),
                              _QaItemWidget(title: '你肯定会中这几条'),
                              _QaItemWidget(title: '这些性格的星座是最好避开的'),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              _QaItemWidget(title: '测测你星盘基础知识'),
                              _QaItemWidget(title: '做这些事情可以让你财运更好哦'),
                              _QaItemWidget(title: '年运测算'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FormTextField extends StatefulWidget {
  const _FormTextField({super.key});

  @override
  State<_FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<_FormTextField> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnlineQaController>();
    return TextField(
      controller: controller.contentController,
      maxLines: 5,
      minLines: 5,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: '一次只能问一个问题哦~',
        hintStyle: TextStyle(color: Color(0xffBDBDBD)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Color(0xffF7F9FF),
        contentPadding: EdgeInsets.all(10),
      ),
    );
  }
}

/// 星盘选择档案组件
class _XpContainerWidget extends StatelessWidget {
  final String title;

  const _XpContainerWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnlineQaController>();
    String tipText = "选择问题相关的档案（必选）";
    if (title == '智慧牌') {
      tipText = "选择牌阵";
    }
    return Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(AppConst.PAGE_PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text(tipText, style: TextStyle(fontSize: 16)),
            if (title == '合盘' || title == '星盘')
              Obx(() {
                return SelectArchive(
                  placeholder: '请选择档案',
                  value: controller.archive1.value,
                  onSelected: (value) {
                    controller.archive1.value = value;
                  },
                );
              }),
            if (title == '合盘')
              Obx(() {
                return SelectArchive(
                  placeholder: '请选择档案',
                  placeholderColor: Color(0xffCCABAB),
                  backgroundColor: Color(0xffFFF7F7),
                  value: controller.archive2.value,
                  onSelected: (value) {
                    controller.archive2.value = value;
                  },
                );
              }),
            if (title == '智慧牌')
              Row(
                spacing: 10,
                children: List.generate(4, (index) {
                  return Expanded(
                    child: Obx(() {
                      return GestureDetector(
                        onTap: () {
                          controller.pz.value = index;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 32,
                          decoration: BoxDecoration(
                            color: controller.pz.value == index
                                ? Color(0xff4c1fac)
                                : Color(0xffF3F4FB),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '牌阵${index + 1}',
                            style: TextStyle(
                              fontSize: 14,
                              color: controller.pz.value == index
                                  ? Colors.white
                                  : Color(0xff383838),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}

class _QaItemWidget extends StatelessWidget {
  final String title;

  const _QaItemWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Color(0xffF7F9FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 12, color: Color(0xff383838)),
      ),
    );
  }
}
