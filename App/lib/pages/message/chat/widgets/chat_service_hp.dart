import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freud/api/live/question_api.dart';
import 'package:freud/models/im/im_message.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/service/im_service.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import '../../../../constants/app_const.dart';
import '../chat_controller.dart';
import 'form_textfield_container.dart';

class ChatServiceHp extends StatefulWidget {
  final List? starData;

  const ChatServiceHp({super.key, this.starData});

  @override
  State<ChatServiceHp> createState() => _ChatServiceHpState();
}

class _ChatServiceHpState extends State<ChatServiceHp> {
  Archive? _archive1;
  Archive? _archive2;
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
    if (_archive1 == null) {
      ToastUtil.info('请选择第一个档案');
      return;
    }
    if (_archive2 == null) {
      ToastUtil.info('请选择第二个档案');
      return;
    }
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
      'ordertype': 3,
      'orderstate': 0,
      'money': (starValue ?? 0).toDouble(),
      'name': text.length > 50 ? text.substring(0, 50) : text,
    };
    if (_archive1?.id != null) {
      data['aid1'] = _archive1!.id;
    }
    if (_archive2?.id != null) {
      data['aid2'] = _archive2!.id;
    }

    setState(() => _isSubmitting = true);
    try {
      final result = await QuestionApi().questionAdd(data);
      if (result != null && context.mounted) {
        final fromUid = Get.find<UserService>().userinfo.value?.id;
        final toUid = chatController.uid.value;
        if (fromUid != null && toUid > 0) {
          final imData = {
            'type': 'service',
            'subtype': 'hp',
            'content': text,
            'money': (starValue ?? 0).toDouble(),
            'question_id': result.id,
            'archive1': _archive1?.toJson(),
            'archive2': _archive2?.toJson(),
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
                    image: AssetImage('assets/images/chat_hp_bg.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.only(
                  top: 30,
                  left: AppConst.PAGE_PADDING,
                  right: AppConst.PAGE_PADDING,
                  bottom: AppConst.PAGE_PADDING,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _SelectUserArchive(
                            archive: _archive1,
                            onSelected: (value) {
                              setState(() => _archive1 = value);
                            },
                          ),
                          _SelectUserArchive(
                            archive: _archive2,
                            onSelected: (value) {
                              setState(() => _archive2 = value);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      FormTextfieldContainer(
                        controller: _questionController,
                        title: '以合盘提问',
                        hintText: '一次只能问一个问题哦~',
                        color1: Color(0xffFFA3DF),
                        color2: Color(0xffFF59C5),
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

class _SelectUserArchive extends StatelessWidget {
  final Archive? archive;
  final ValueChanged<Archive>? onSelected;

  const _SelectUserArchive({super.key, this.archive, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Get.toNamed(AppRoutes.ARCHIVE_SELECT);
        if (result != null) {
          onSelected?.call(result);
        }
      },
      child: Column(
        spacing: 5,
        children: [
          CircleAvatar(
            radius: 29,
            backgroundColor: Colors.white,
            child: archive != null
                ? Text(
                    archive!.name?.isNotEmpty == true ? archive!.name![0] : '',
                    style: TextStyle(fontSize: 20, color: Color(0xffFF52CE)),
                  )
                : Icon(Icons.add, size: 32, color: Color(0xffFF52CE)),
          ),
          Text(archive?.name ?? '请选择', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
