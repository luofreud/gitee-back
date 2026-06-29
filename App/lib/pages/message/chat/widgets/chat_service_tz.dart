import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freud/api/live/question_api.dart';
import 'package:freud/models/im/im_message.dart';
import 'package:freud/service/im_service.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import '../../../../constants/app_const.dart';
import '../chat_controller.dart';
import 'form_textfield_container.dart';

class ChatServiceTz extends StatefulWidget {
  final List? starData;

  const ChatServiceTz({super.key, this.starData});

  @override
  State<ChatServiceTz> createState() => _ChatServiceTzState();
}

class _ChatServiceTzState extends State<ChatServiceTz> {
  final _questionController = TextEditingController();
  int? starValue = 8;
  final chatController = Get.find<ChatController>();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;
    CommonUtil.hideKeyShowUnfocus();
    final question = _questionController.text.trim();
    if (question.isEmpty) {
      ToastUtil.info('请输入问题');
      return;
    }
    if (starValue != null && starValue! > 0) {
      final balance = Get.find<UserService>().userinfo.value?.xzmoney ?? 0;
      if (balance < starValue!) {
        ToastUtil.info('星钻余额不足');
        return;
      }
    }
    final text = _questionController.text.trim();
    final data = <String, dynamic>{
      'tid': chatController.teacher.value?.id,
      'content': text,
      'ordertype': 0,
      'orderstate': 0,
      'money': (starValue ?? 0).toDouble(),
      'name': text.length > 50 ? text.substring(0, 50) : text,
    };

    setState(() => _isSubmitting = true);
    try {
      final result = await QuestionApi().questionAdd(data);
      if (result != null && context.mounted) {
        final fromUid = Get.find<UserService>().userinfo.value?.id;
        final toUid = chatController.uid.value;
        if (fromUid != null && toUid > 0) {
          final imData = {
            'type': 'service',
            'subtype': 'tz',
            'content': text,
            'money': (starValue ?? 0).toDouble(),
            'question_id': result.id,
          };
          Get.find<ImService>().sendText(
            fromUserId: fromUid.toString(),
            toUserId: toUid.toString(),
            content: jsonEncode(imData),
          );
          chatController.messages.add(
            ImMessage(
              fromUid: fromUid.toString(),
              toUid: toUid.toString(),
              type: 'other',
              content: jsonEncode(imData),
              createdAt: CommonUtil.formatDate(DateTime.now()),
            ),
          );
          Future.delayed(Duration(milliseconds: 100), () {
            chatController.scrollToBottom();
          });
        }
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } else {
        ToastUtil.error('提交失败');
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        CommonUtil.hideKeyShowUnfocus();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight:
                      (MediaQuery.of(context).size.height -
                          MediaQuery.of(context).viewInsets.bottom) *
                      0.9,
                ),
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/chat_tz_bg.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.only(
                  top: 150,
                  left: AppConst.PAGE_PADDING,
                  right: AppConst.PAGE_PADDING,
                  bottom: AppConst.PAGE_PADDING,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      FormTextfieldContainer(
                        controller: _questionController,
                        title: '以骰子提问',
                        hintText: '一次只能问一个问题哦~',
                        color1: Color(0xff61DA7E),
                        color2: Color(0xff47AD64),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text('星钻赞赏', style: TextStyle(fontSize: 16)),
                          ),
                          Obx(() {
                            final balance =
                                Get.find<UserService>()
                                    .userinfo
                                    .value
                                    ?.xzmoney ??
                                0;
                            return Text(
                              '星钻余额：$balance',
                              style: TextStyle(fontSize: 13),
                            );
                          }),
                        ],
                      ),
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 10,
                        children: (widget.starData ?? []).map((item) {
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  starValue = item['value'];
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: starValue == item['value']
                                        ? [Color(0xff5159C2), Color(0xffD54AFF)]
                                        : [
                                            Color(0xffF7FAFC),
                                            Color(0xffF7FAFC),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    // horizontal: 8,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xffF7FAFC),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (item['value'] > 0)
                                        Image.asset(
                                          'assets/icons/icon_zuanshi.png',
                                          width: 16,
                                          height: 16,
                                        ),
                                      Text(
                                        item['title'],
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xffF7FAFC),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '温馨提示：赞赏的提问咨询师会优先处理哦~',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff808080),
                          ),
                        ),
                      ),
                      GradientButton(
                        onPressed: _isSubmitting ? null : () { _submit(); },
                        width: double.infinity,
                        height: 40,
                        child: _isSubmitting
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text('发给咨询师获得答案'),
                                ],
                              )
                            : Text('发给咨询师获得答案'),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
