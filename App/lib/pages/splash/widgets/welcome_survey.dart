import 'package:flutter/material.dart';
import 'package:freud/pages/splash/splash_controller.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';

class SplashWelcomeSurvey extends StatelessWidget {
  const SplashWelcomeSurvey({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<SplashController>();
    return Padding(
      padding: EdgeInsets.only(
        left: AppConst.PAGE_PADDING,
        right: AppConst.PAGE_PADDING,
        top: AppConst.PAGE_PADDING,
        bottom: 50,
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(AppConst.PAGE_PADDING),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          spacing: 15,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 2,
              children: [
                Obx(() {
                  return Text(
                    '${controller.surveyIndex.value + 1}',
                    style: TextStyle(fontSize: 16),
                  );
                }),
                Text(
                  '/',
                  style: TextStyle(fontSize: 16, color: Color(0xff808080)),
                ),
                Text(
                  '${controller.surveyList.length}',
                  style: TextStyle(fontSize: 16, color: Color(0xff808080)),
                ),
              ],
            ),
            Obx(() {
              var question = controller
                  .surveyList[controller.surveyIndex.value]['question'];
              return Text(
                question.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              );
            }),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                var item = controller.surveyList[controller.surveyIndex.value];
                if (controller.surveyIndex.value == 1) {
                  return _SurveyTwoWidget(
                    options: item['options'] as List,
                    selected: item['selected']?.toString(),
                    onTap: (text) => controller.selectSurveyOption(text),
                  );
                } else if (controller.surveyIndex.value == 3) {
                  return _SurveyFourWidget(
                    options: item['options'] as List,
                    selected: item['selected']?.toString(),
                    onTap: () {
                      /// 最后一步跳转到注册界面
                      controller.goLogin();
                    },
                  );
                } else {
                  return _SurveyOneWidget(
                    options: item['options'] as List,
                    selected: item['selected']?.toString(),
                    onTap: (text) => controller.selectSurveyOption(text),
                  );
                }
              }), // _SurveyOneWidget()
            ),
          ],
        ),
      ),
    );
  }
}

class _SurveyOneWidget extends StatelessWidget {
  final List<dynamic> options;
  final String? selected;
  final Function(String text)? onTap;

  const _SurveyOneWidget({
    super.key,
    required this.options,
    this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: options.map((item) {
          return _SurveyItemWidget(
            text: item['text'],
            subText: item['subText'],
            isSelected: selected == item['text'],
            onTap: onTap,
          );
        }).toList(),
      ),
    );
  }
}

class _SurveyTwoWidget extends StatelessWidget {
  final List<dynamic> options;
  final String? selected;
  final Function(String text)? onTap;

  const _SurveyTwoWidget({
    super.key,
    required this.options,
    this.selected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var evenList = options.where((e) => options.indexOf(e) % 2 == 0).toList();
    var oddList = options.where((e) => options.indexOf(e) % 2 == 1).toList();
    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: Column(
            spacing: 10,
            children: evenList.map((item) {
              return _SurveyItemWidget(
                text: item['text'],
                subText: item['subText'],
                isSelected: selected == item['text'],
                onTap: onTap,
              );
            }).toList(),
          ),
        ),

        Expanded(
          child: Column(
            spacing: 10,
            children: oddList.map((item) {
              return _SurveyItemWidget(
                text: item['text'],
                subText: item['subText'],
                isSelected: selected == item['text'],
                onTap: onTap,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SurveyFourWidget extends StatelessWidget {
  final List<dynamic> options;
  final String? selected;
  final Function()? onTap;
  static const itemAttr = [
    {
      "colors": [Color(0xffCFECFF), Color(0xffCFDBFF)],
      "color": Color(0xff5EA9FF),
      "subColor": Color(0xff5EA9FF),
      "icon": "assets/icons/icon_xzys.png",
    },
    {
      "colors": [Color(0xffFFF2EB), Color(0xffFFF2E0)],
      "color": Color(0xffCC822D),
      "subColor": Color(0xffAD8353),
      "icon": "assets/icons/icon_mfgj.png",
    },
    {
      "colors": [Color(0xffFFEDEB), Color(0xffFFE3E3)],
      "color": Color(0xffCF6561),
      "subColor": Color(0xffDE8481),
      "icon": "assets/icons/icon_qgkh.png",
    },
    {
      "colors": [Color(0xffF0FFF7), Color(0xffD6FFFB)],
      "color": Color(0xff3A9489),
      "subColor": Color(0xff6FA8A1),
      "icon": "assets/icons/icon_rmcp.png",
    },
  ];

  const _SurveyFourWidget({
    super.key,
    required this.options,
    this.selected,
    this.onTap,
  });

  _buildItemWidget({
    required String text,
    required String subText,
    required String icon,
    List<Color>? colors,
    Color? color,
    Color? subColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: colors != null ? LinearGradient(colors: colors) : null,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(icon, width: 23),
              Text(text, style: TextStyle(fontSize: 16, color: color)),
            ],
          ),
          Text(subText, style: TextStyle(fontSize: 12, color: subColor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: [
          ...options.asMap().entries.map((item) {
            var _itemAttr = itemAttr[item.key];
            return _buildItemWidget(
              text: item.value['text'],
              subText: item.value['subText'],
              icon: _itemAttr['icon'] as String,
              colors: _itemAttr['colors'] as List<Color>,
              color: _itemAttr['color'] as Color,
              subColor: _itemAttr['subColor'] as Color,
            );
          }),
          const SizedBox(height: 10),
          GradientButton(
            onPressed: onTap,
            height: 60,
            width: double.infinity,
            foregroundColor: Colors.white,
            gradient: LinearGradient(
              colors: [Color(0xff4C1FAD), Color(0xff0A2063)],
            ),
            child: Text(
              '免费获取解析',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _SurveyItemWidget extends StatelessWidget {
  final String text;
  final String? subText;
  final bool isSelected;
  final Function(String text)? onTap;
  final List<Color>? colors;

  const _SurveyItemWidget({
    super.key,
    required this.text,
    this.subText,
    this.isSelected = false,
    this.onTap,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> _colors = colors ?? [Color(0xffF7FAFC), Color(0xffF7FAFC)];
    return GestureDetector(
      onTap: () {
        onTap?.call(text);
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [Color(0xff4C1FAD), Color(0xff0A2063)])
              : LinearGradient(colors: _colors),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.white : null,
              ),
            ),
            if (subText != null && subText!.isNotEmpty)
              Text(
                subText!,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : Color(0xffA6A6A6),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
