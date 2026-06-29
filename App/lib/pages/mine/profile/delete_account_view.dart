import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/widgets/component/circle_checkbox.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import '../../../utils/dialog_util.dart';
import 'delete_account_controller.dart';

class DeleteAccountPage extends GetView<DeleteAccountController> {
  const DeleteAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => DeleteAccountController());
    final userService = Get.find<UserService>();
    return Scaffold(
      appBar: AppBar(title: Text('注销账号'), backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 5,
                  children: [
                    Text(
                      '即将注销此账号：',
                      style: TextStyle(fontSize: 16, color: Color(0xffE85F5F)),
                    ),
                    Text('${userService.userinfo.value?.nickname}'),
                    Text('用户ID：${userService.userinfo.value?.id}'),
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xffFFF5F5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 14,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        '注销账户后，将自动放弃以下资产及权益：\n\n1、该账号下所有个人资料和历史信息。\n2、该账号发布和参与的所有内容。\n3、该账号下账户余额、优惠券、星钻、已购买的数据以及相关服务等。\n\n以上信息，将在账号注销后全部清空和删除。',
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('*', style: TextStyle(color: Color(0xffE85F5F))),
                        Expanded(
                          child: Text(
                            '确认注销后，7日未进行登录操作将自动注销账号。若7日内进行登录操作将自动解除注销。',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Transform.translate(
                    offset: Offset(0, -3),
                    child: CircleCheckbox(
                      value: controller.agree.value,
                      onChanged: (value) {
                        controller.agree.value = value ?? false;
                      },
                    ),
                  );
                }),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.agree.value = !controller.agree.value;
                    },
                    child: Text(
                      '我已阅读并同意上述内容，并对操作带来的一切后果负责',
                      style: TextStyle(fontSize: 12, color: Color(0xff808080)),
                    ),
                  ),
                ),
              ],
            ),
            Obx(() {
              return GradientButton(
                width: double.infinity,
                height: 48,
                disabledBackgroundColor: Color(0xffE5E5E5),
                disabledForegroundColor: Color(0xff808080),
                onPressed: controller.agree.value
                    ? () async {
                        var result = await DialogUtil.showConfirmDialog(
                          context: context,
                          confirmText: '确认',
                          confirmColor: Colors.white,
                          confirmTextColor: Color(0xff383838),
                          child: Text(
                            '再次确认要注销账号吗？',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xffE85F5F),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          position: DialogPosition.center,
                        );
                        if (result == true) {
                          controller.deleteAccount();
                        }
                      }
                    : null,
                child: Text('确认注销'),
              );
            }),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ],
        ),
      ),
    );
  }
}
