import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import 'edit_sign_controller.dart';

class EditSignPage extends GetView<EditSignController> {
  const EditSignPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => EditSignController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('个性签名'),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () async {
              await controller.onSave();
            },
            style: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
              overlayColor: Colors.transparent,
              foregroundColor: Color(0xff383838),
            ),
            child: const Text('保存'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
        child: Column(
          children: [
            Stack(
              children: [
                TextField(
                  controller: controller.textFieldController,
                  maxLength: 100,
                  maxLines: 5,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: '介绍一下自己吧~',
                    hintStyle: TextStyle(color: Color(0xff808080)),
                    filled: true,
                    fillColor: Colors.white,
                    counterText: '',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    controller.signature.value = value;
                  },
                ),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: Obx(() {
                    return Text(
                      '${controller.signature.value.length}/100',
                      style: TextStyle(fontSize: 12, color: Color(0xff808080)),
                    );
                  }),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                '简介字数限制100字\n仅支持中文、英文、数字、下划线\n\n请不要试图以联系方式（电话号码、QQ号等）作为昵称，一旦发现作封号处理。',
                style: TextStyle(color: Color(0xff808080)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
