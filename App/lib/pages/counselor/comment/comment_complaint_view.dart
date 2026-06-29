import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import 'comment_complaint_controller.dart';

class CommentComplaintPage extends GetView<CommentComplaintController> {
  const CommentComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CommentComplaintController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('举报'),
        backgroundColor: Colors.white,
        shape: const Border(
          bottom: BorderSide(color: Color(0xffF5F7F9), width: 1),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
              child: Text(
                '昨夜雨疏风骤，浓睡不消残酒，兴尽晚回舟，误入藕花深处。争渡，争渡，',
                style: TextStyle(color: Color(0xffA6A6A6)),
              ),
            ),
            Container(
              height: 10,
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            Padding(
              padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 10,
                children: [
                  Text('违反法律法规', style: TextStyle(color: Color(0xffA6A6A6))),
                  Obx(() {
                    return RadioGroup(
                      groupValue: controller.lawValue.value,
                      onChanged: (value) {
                        print(value);
                        if (value != null) {
                          controller.lawValue.value = value;
                        }
                      },
                      child: Wrap(
                        children: controller.lawRadioList.map((item) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 5,
                            children: [
                              Radio<String>(
                                value: item,
                                activeColor: Colors.red,
                                side: BorderSide(
                                  width: 1,
                                  color: Color(0xffE5E5E5),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(-15, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.lawValue.value = item;
                                  },
                                  child: Text(item),
                                ),
                              ),
                            ],
                          );
                          return Radio(value: item == '违法违纪');
                        }).toList(),
                      ),
                    );
                  }),
                  Text('侵犯个人权益', style: TextStyle(color: Color(0xffA6A6A6))),
                  Obx(() {
                    return RadioGroup(
                      groupValue: controller.personalValue.value,
                      onChanged: (value) {
                        print(value);
                        if (value != null) {
                          controller.personalValue.value = value;
                        }
                      },
                      child: Wrap(
                        children: controller.personalRadioList.map((item) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 5,
                            children: [
                              Radio<String>(
                                value: item,
                                activeColor: Colors.red,
                                side: BorderSide(
                                  width: 1,
                                  color: Color(0xffE5E5E5),
                                ),
                              ),
                              Transform.translate(
                                offset: Offset(-15, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.personalValue.value = item;
                                  },
                                  child: Text(item),
                                ),
                              ),
                            ],
                          );
                          return Radio(value: item == '违法违纪');
                        }).toList(),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GradientButton(
                width: double.infinity,
                height: 40,
                onPressed: () {},
                child: Text('提交'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
