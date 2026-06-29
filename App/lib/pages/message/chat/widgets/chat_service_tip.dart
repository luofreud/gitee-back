import 'package:flutter/material.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/widgets/gradient_button.dart';

import '../../../../constants/app_const.dart';

/// 打赏服务
class ChatServiceTip extends StatefulWidget {
  final List? starData;

  const ChatServiceTip({super.key, this.starData});

  @override
  State<ChatServiceTip> createState() => _ChatServiceTipState();
}

class _ChatServiceTipState extends State<ChatServiceTip> {
  int? selectValue = 8;
  int? starValue = 8;

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
                decoration: BoxDecoration(),
                padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Row(
                        spacing: 15,
                        children: [
                          Text('星钻赞赏', style: TextStyle(fontSize: 16)),
                          Text(
                            '星钻余额：66',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xffA6A6A6),
                            ),
                          ),
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
                                  selectValue = item['value'];
                                  starValue = selectValue;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: selectValue == item['value']
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
                      if (selectValue == 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xffE5E5E5),
                                offset: Offset(0, 0),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '请输入星钻数量',
                              hintStyle: TextStyle(
                                fontSize: 14,
                                color: Color(0xff808080),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xffF7FAFC),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '温馨提示：打赏星钻不可退哦~~',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff808080),
                          ),
                        ),
                      ),
                      GradientButton(
                        onPressed: () {},
                        width: double.infinity,
                        gradient: LinearGradient(
                          colors: [Color(0xffFF9C45), Color(0xffFF5F57)],
                        ),
                        height: 40,
                        child: Text('打赏'),
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
                  child: Icon(Icons.close, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
