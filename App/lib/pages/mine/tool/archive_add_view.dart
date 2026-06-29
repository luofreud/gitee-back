import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/utils/address_util.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/widgets/component/switch_widget.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:freud/widgets/page_background.dart';
import 'package:get/get.dart';

import '../../../utils/dialog_util.dart';
import 'archive_add_controller.dart';

class ArchiveAddPage extends GetView<ArchiveAddController> {
  const ArchiveAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ArchiveAddController());
    return PageBackground(
      child: GestureDetector(
        onTap: () {
          CommonUtil.hideKeyShowUnfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('添加档案'),
            backgroundColor: Colors.white.withAlpha(0),
          ),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
            child: Column(
              spacing: 30,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      _FormItem(
                        label: '姓名',
                        arrow: false,
                        child: TextField(
                          controller: controller.nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            hintText: '请填写',
                            hintStyle: TextStyle(
                              color: Color(0xffA6A6A6),
                              fontSize: 16,
                            ),
                          ),
                          onChanged: (value) {
                            controller.name.value = value;
                          },
                        ),
                      ),
                      _FormItem(
                        label: '备注',
                        onTap: () async {
                          CommonUtil.hideKeyShowUnfocus();
                          DialogUtil.showMenuDialog(
                            context: context,
                            items: controller.relationList.map((item) {
                              return DialogMenuItem(
                                title: item,
                                onTap: (_) {
                                  controller.relation.value = item;
                                },
                              );
                            }).toList(),
                          );
                        },
                        child: Obx(() {
                          final selected = controller.relation.value.isNotEmpty;
                          return Text(
                            selected ? controller.relation.value : '请选择',
                            style: TextStyle(
                              color: selected
                                  ? Color(0xff383838)
                                  : Color(0xffA6A6A6),
                              fontSize: 16,
                            ),
                          );
                        }),
                      ),
                      Obx(() {
                        return _FormItem(
                          label: '性别',
                          border: true,
                          arrow: false,
                          child: Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                child: _SexItem(
                                  sex: '女',
                                  checked: controller.sex.value == 1,
                                  onTap: () {
                                    controller.sex.value = 1;
                                  },
                                ),
                              ),
                              Expanded(
                                child: _SexItem(
                                  sex: '男',
                                  checked: controller.sex.value == 0,
                                  onTap: () {
                                    controller.sex.value = 0;
                                  },
                                ),
                              ),
                              const SizedBox.shrink(),
                            ],
                          ),
                        );
                      }),
                      _FormItem(
                        label: '出生时间',
                        border: true,
                        onTap: () async {
                          CommonUtil.hideKeyShowUnfocus();
                          var result = await DialogUtil.showDatePicker(
                            context: context,
                            initialDate: controller.birthday.value,
                            showTime: true,
                          );
                          if (result is DateTime) {
                            controller.birthday.value = result;
                          }
                        },
                        child: Obx(() {
                          if (controller.birthday.value != null) {
                            var timeStr = CommonUtil.formatDate(
                              controller.birthday.value,
                              format: 'yyyy年MM月dd日 hh时mm分',
                            );
                            return Text(
                              timeStr,
                              style: TextStyle(fontSize: 16),
                            );
                          }
                          return Text(
                            '请选择',
                            style: TextStyle(
                              color: Color(0xffA6A6A6),
                              fontSize: 16,
                            ),
                          );
                        }),
                      ),
                      _FormItem(
                        label: '出生地点',
                        border: true,
                        onTap: () async {
                          CommonUtil.hideKeyShowUnfocus();
                          var result = await AddressUtil.showDialog(
                            context: context,
                            dataType: DataType.city,
                            initData: controller.address.value.split(' '),
                            onSelected: (result) {
                              var city = result[result.length - 1];
                              controller.addresslat.value = city.lat;
                              controller.addresslong.value = city.long;
                            },
                          );
                          if (result != null && result.isNotEmpty) {
                            controller.address.value = result.join(' ');
                          }
                        },
                        child: Obx(() {
                          if (controller.address.value.isNotEmpty) {
                            return Text(
                              controller.address.value,
                              style: TextStyle(fontSize: 16),
                            );
                          }
                          return Text(
                            '请选择',
                            style: TextStyle(
                              color: Color(0xffA6A6A6),
                              fontSize: 16,
                            ),
                          );
                        }),
                      ),
                      _FormItem(
                        label: '现居地',
                        border: true,
                        onTap: () async {
                          CommonUtil.hideKeyShowUnfocus();
                          var result = await AddressUtil.showDialog(
                            context: context,
                            dataType: DataType.city,
                            onSelected: (result) {
                              var city = result[result.length - 1];
                              controller.nowaddresslat.value = city.lat;
                              controller.nowaddresslong.value = city.long;
                            },
                          );
                          if (result != null && result.isNotEmpty) {
                            controller.nowaddress.value = result.join(' ');
                          }
                        },
                        child: Obx(() {
                          if (controller.nowaddress.value.isNotEmpty) {
                            return Text(
                              controller.nowaddress.value,
                              style: TextStyle(fontSize: 16),
                            );
                          }
                          return Text(
                            '请选择',
                            style: TextStyle(
                              color: Color(0xffA6A6A6),
                              fontSize: 16,
                            ),
                          );
                        }),
                      ),
                      _FormItem(
                        label: '时区',
                        border: true,
                        onTap: () {
                          CommonUtil.hideKeyShowUnfocus();
                          DialogUtil.showModalBottom(
                            context: context,
                            builder: (context) {
                              final itemHeight = 56.0;
                              final contentHeight =
                                  controller.timezoneJson.length * itemHeight +
                                  60;
                              return SizedBox(
                                height: contentHeight.clamp(
                                  0,
                                  MediaQuery.of(context).size.height * 0.6,
                                ),
                                child: Column(
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 15,
                                      ),
                                      child: const Text(
                                        '选择时区',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    Flexible(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            controller.timezoneJson.length,
                                        itemBuilder: (context, index) {
                                          final item =
                                              controller.timezoneJson[index];
                                          final selected =
                                              controller.timezone.value ==
                                              item['utc_offset'];
                                          return ListTile(
                                            title: Text(
                                              '${item['name']} (UTC${item['utc_offset']})',
                                            ),
                                            trailing: selected
                                                ? const Icon(
                                                    Icons.check,
                                                    color: Color(0xff4D1FAE),
                                                  )
                                                : null,
                                            onTap: () {
                                              controller.timezone.value =
                                                  item['utc_offset']!;
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Obx(() {
                          if (controller.timezone.value.isNotEmpty) {
                            return Text(
                              controller.timezoneDisplay,
                              style: const TextStyle(fontSize: 16),
                            );
                          }
                          return Text(
                            '请选择',
                            style: TextStyle(
                              color: Color(0xffA6A6A6),
                              fontSize: 16,
                            ),
                          );
                        }),
                      ),
                      _FormItem(
                        label: '夏令时',
                        border: false,
                        arrow: false,
                        child: Obx(() {
                          return Transform.translate(
                            offset: Offset(-15, 0),
                            child: SwitchWidget(
                              value: controller.isdst.value,
                              onChanged: (value) {
                                controller.isdst.value = value;
                              },
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                GradientButton(
                  width: double.infinity,
                  height: 52,
                  onPressed: () {
                    controller.archiveSubmit();
                  },
                  child: Text('完成星盘'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FormItem extends StatelessWidget {
  final String label;
  final Widget? child;
  final bool arrow;
  final bool border;
  final Function()? onTap;

  const _FormItem({
    super.key,
    required this.label,
    this.child,
    this.arrow = true,
    this.border = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 68,
        decoration: BoxDecoration(
          border: border
              ? const Border(bottom: BorderSide(color: Color(0xffFAFAFA)))
              : null,
        ),
        child: Row(
          spacing: 20,
          children: [
            SizedBox(
              width: 80,
              child: Text(
                label,
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: child ?? SizedBox.shrink(),
              ),
            ),
            if (arrow)
              const Padding(
                padding: EdgeInsets.only(right: AppConst.PAGE_PADDING),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xff696969),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SexItem extends StatelessWidget {
  final String sex;
  final bool checked;
  final Function()? onTap;

  const _SexItem({
    super.key,
    required this.sex,
    this.checked = false,
    this.onTap,
  });

  static const List sexList = [
    {'icon': 'assets/icons/icon_woman.png', 'label': '女生'},
    {'icon': 'assets/icons/icon_man.png', 'label': '男生'},
  ];

  @override
  Widget build(BuildContext context) {
    var sexItem = sex == '女' ? sexList[0] : sexList[1];
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: 36,
        decoration: BoxDecoration(
          border: Border.all(
            color: checked ? Color(0xffFF66C9) : Color(0xffE5E5E5),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 5,
          children: [
            Image.asset(
              sexItem['icon'],
              width: 18,
              height: 18,
              color: checked ? Color(0xffFF66C9) : Color(0xff383838),
            ),
            Text(
              sexItem['label'],
              style: TextStyle(
                fontSize: 16,
                color: checked ? Color(0xffFF66C9) : Color(0xff383838),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
