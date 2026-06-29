import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:get/get.dart';

import 'edit_name_controller.dart';

class EditNamePage extends GetView<EditNameController> {
  const EditNamePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => EditNameController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('编辑昵称'),
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
            TextField(
              controller: controller.textFieldController,
              decoration: InputDecoration(
                hintText: '请输入昵称',
                hintStyle: TextStyle(color: Color(0xff808080)),
                filled: true,
                fillColor: Colors.white,
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
                controller.nickname.value = value;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                '昵称只允许4-16个字符\n仅支持中文、英文、数字、下划线\n\n请不要试图以联系方式（电话号码、QQ号等）作为昵称，一旦发现作封号处理。',
                style: TextStyle(color: Color(0xff808080)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
