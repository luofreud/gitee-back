import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:freud/widgets/page_background.dart';
import 'package:get/get.dart';

import 'revenue_withdraw_controller.dart';

class RevenueWithdrawPage extends GetView<RevenueWithdrawController> {
  const RevenueWithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RevenueWithdrawController());
    return GestureDetector(
      onTap: () {
        CommonUtil.hideKeyShowUnfocus();
      },
      child: PageBackground(
        child: Scaffold(
          appBar: AppBar(
            title: Text('星钻提现'),
            backgroundColor: Colors.white.withAlpha(0),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    spacing: 15,
                    children: [
                      Row(
                        children: [
                          Text('可提现余额'),
                          const Spacer(),
                          Text(
                            '（ 兑换比例：1星钻 = 1元 ）',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xffA6A6A6),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        spacing: 10,
                        children: [
                          Text(
                            '120.0',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text('元', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        spacing: 10,
                        children: [
                          Text('提现数额'),
                          Expanded(
                            child: TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '请输入 1-120',
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: Color(0xffE5E5E5),
                                  ),
                                ),
                                suffixIconConstraints: BoxConstraints(
                                  minWidth: 0,
                                  minHeight: 0,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    '全额提现',
                                    style: TextStyle(color: Color(0xff4769FF)),
                                  ),
                                ),
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xffF2F1FC),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Text('提现到银行卡'),
                            Expanded(
                              child: Text(
                                '6224 **** 4414',
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      GradientButton(
                        onPressed: () {
                          DialogUtil.showSuccess(
                            context: context,
                            title: '提现申请提交成功',
                            subtitle: '银行卡到账可能会有延迟，请耐心等待',
                          );
                        },
                        width: double.infinity,
                        height: 40,
                        child: Text('发起提现'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
