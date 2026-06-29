import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/widgets/component/circle_checkbox.dart';
import 'package:freud/widgets/page_background.dart';
import 'package:get/get.dart';

import '../../../widgets/gradient_button.dart';
import 'tarot_question_controller.dart';

class TarotQuestionPage extends GetView<TarotQuestionController> {
  const TarotQuestionPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => TarotQuestionController());
    return PageBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Text('智慧牌'),
          backgroundColor: Colors.white.withAlpha(0),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: AppConst.PAGE_PADDING,
            right: AppConst.PAGE_PADDING,
            bottom: AppConst.PAGE_PADDING,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('塔罗答疑', style: TextStyle(fontSize: 16)),
                    TextField(
                      maxLines: null,
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
                    ),
                    Row(
                      children: [
                        Obx(() {
                          return CircleCheckbox(
                            value: controller.syncQuestion.value,
                            side: BorderSide(
                              width: 1,
                              color: Color(0xff808080),
                            ),
                            fillColor: Colors.white,
                            onChanged: (value) {
                              controller.syncQuestion.value = value ?? false;
                            },
                          );
                        }),
                        GestureDetector(
                          onTap: () {
                            controller.syncQuestion.value =
                                !controller.syncQuestion.value;
                          },
                          child: Text(
                            '是否将问题匿名同步到社区',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xff828282),
                            ),
                          ),
                        ),
                      ],
                    ),
                    GradientButton(
                      onPressed: () {},
                      width: double.infinity,
                      height: 40,
                      foregroundColor: Color(0xffFFD5A8),
                      gradient: LinearGradient(
                        colors: [Color(0xff4D1FAE), Color(0xff0A2063)],
                      ),
                      child: Text('获得解答'),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
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
