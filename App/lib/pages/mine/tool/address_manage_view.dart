import 'package:flutter/material.dart';
import 'package:freud/utils/address_util.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:freud/widgets/component/circle_checkbox.dart';
import 'package:freud/widgets/gradient_button.dart';
import 'package:get/get.dart';

import '../../../constants/app_const.dart';
import '../../../utils/dialog_util.dart';
import '../../../widgets/component/switch_widget.dart';
import '../../../widgets/component/user_tag.dart';
import '../../../widgets/refresh_loadmore.dart';
import 'address_manage_controller.dart';

class AddressManagePage extends GetView<AddressManageController> {
  const AddressManagePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AddressManageController());

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: GetBuilder<AddressManageController>(
          builder: (AddressManageController home) {
            return Obx(() {
              List<Widget> actions = [];
              if (controller.isManagePage.value) {
                actions = [
                  TextButton(
                    onPressed: () {
                      controller.isManagePage.value = false;
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xffFF4A4A),
                      padding: EdgeInsets.zero,
                      overlayColor: Colors.transparent,
                      minimumSize: Size(0, 0),
                    ),
                    child: Text('退出管理'),
                  ),
                  const SizedBox(width: AppConst.PAGE_PADDING),
                ];
              } else {
                actions = [
                  TextButton(
                    onPressed: () {
                      controller.isManagePage.value = true;
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xff383838),
                      padding: EdgeInsets.zero,
                      overlayColor: Colors.transparent,
                      minimumSize: Size(0, 0),
                    ),
                    child: Text('管理'),
                  ),
                  TextButton(
                    onPressed: () {
                      controller.resetFormValue(null);
                      DialogUtil.showModalBottom(
                        context: context,
                        child: _AddressForm(),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Color(0xffFF4A4A),
                      padding: EdgeInsets.zero,
                      overlayColor: Colors.transparent,
                      minimumSize: Size(0, 0),
                    ),
                    child: Text('新建'),
                  ),
                  const SizedBox(width: AppConst.PAGE_PADDING),
                ];
              }
              return AppBar(
                title: Text('收货地址'),
                backgroundColor: Colors.white,
                actions: actions,
              );
            });
          },
        ),
      ),
      body: RefreshLoadmore(
        controller: controller.refreshController,
        onRefresh: () async {
          await controller.listRefresh();
        },
        child: Obx(() {
          final isManagePage = controller.isManagePage.value;
          return ListView.separated(
            itemCount: controller.listData.length,
            padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
            separatorBuilder: (_, index) {
              return SizedBox(height: 10);
            },
            itemBuilder: (_, index) {
              var item = controller.listData[index];
              var itemWidget = ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                title: Text(
                  item.area ?? '',
                  style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.address ?? '', style: TextStyle(fontSize: 16)),
                    Row(
                      spacing: 10,
                      children: [
                        Text(
                          '${item.name}  ${item.phone}',
                          style: TextStyle(fontSize: 12),
                        ),
                        if (item.isdefault == 1)
                          UserTag(
                            title: '默认',
                            textStyle: TextStyle(
                              fontSize: 10,
                              height: 1,
                              color: Color(0xffFF4A4A),
                            ),
                            gradient: LinearGradient(
                              colors: [Color(0xffFFD9D9), Color(0xffFFD9D9)],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                contentPadding: EdgeInsets.only(
                  left: 12,
                  top: 5,
                  bottom: 5,
                  right: 5,
                ),
                trailing: IconButton(
                  onPressed: () {
                    controller.resetFormValue(item);
                    DialogUtil.showModalBottom(
                      context: context,
                      child: _AddressForm(),
                    );
                  },
                  icon: Image.asset(
                    'assets/icons/icon_edit.png',
                    width: 18,
                    height: 18,
                  ),
                ),
              );

              if (!isManagePage) {
                return itemWidget;
              }

              return Column(
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      // CircleCheckbox(
                      //   value: false,
                      //   side: BorderSide(width: 1, color: Color(0xff808080)),
                      //   fillColor: Colors.white,
                      //   onChanged: (value) {},
                      // ),
                      Expanded(child: itemWidget),
                    ],
                  ),
                  Row(
                    spacing: 10,
                    children: [
                      // const SizedBox(width: 25),
                      ElevatedButton(
                        onPressed: () {
                          controller.onAddressDefault(
                            item,
                            item.isdefault == 1 ? false : true,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Colors.transparent,
                          foregroundColor: Color(0xff383838),
                          minimumSize: Size(64, 28),
                          maximumSize: Size(64, 28),
                          padding: EdgeInsets.zero,
                          textStyle: TextStyle(fontSize: 12, height: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleCheckbox(
                              value: item.isdefault == 1,
                              side: BorderSide(
                                width: 1,
                                color: Color(0xff808080),
                              ),
                              fillColor: Colors.white,
                              checkColor: Color(0xffFF4A4A),
                              onChanged: (value) {
                                controller.onAddressDefault(
                                  item,
                                  value == true,
                                );
                              },
                            ),
                            Text('默认'),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Colors.transparent,
                          foregroundColor: Color(0xff383838),
                          minimumSize: Size(48, 28),
                          maximumSize: Size(48, 28),
                          padding: EdgeInsets.zero,
                          textStyle: TextStyle(fontSize: 12, height: 1),
                        ),
                        child: Text('置顶'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          DialogUtil.showConfirmDialog(
                            context: context,
                            title: '确定要删除该地址吗？',
                            position: DialogPosition.center,
                            onConfirm: (_content) async {
                              Navigator.of(_content).pop();
                              if (await controller.onAddressDel(item)) {
                                ToastUtil.info('删除成功');
                              }
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          shadowColor: Colors.transparent,
                          foregroundColor: Color(0xff383838),
                          minimumSize: Size(48, 28),
                          maximumSize: Size(48, 28),
                          padding: EdgeInsets.zero,
                          textStyle: TextStyle(fontSize: 12, height: 1),
                        ),
                        child: Text('删除'),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}

class _AddressForm extends StatelessWidget {
  const _AddressForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddressManageController>();
    return Column(
      children: [
        _FormItem(
          label: '姓名',
          arrow: false,
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: '收货人姓名',
              hintStyle: TextStyle(color: Color(0xffA6A6A6), fontSize: 16),
            ),
            controller: TextEditingController(
              text: controller.addressName.value,
            ),
            onChanged: (value) {
              controller.addressName.value = value;
            },
          ),
        ),
        _FormItem(
          label: '电话',
          arrow: false,
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: '收货人手机号',
              hintStyle: TextStyle(color: Color(0xffA6A6A6), fontSize: 16),
            ),
            controller: TextEditingController(
              text: controller.addressPhone.value,
            ),
            onChanged: (value) {
              controller.addressPhone.value = value;
            },
          ),
        ),
        _FormItem(
          label: '地区',
          arrow: true,
          child: GestureDetector(
            onTap: () async {
              var res = await AddressUtil.showDialog(
                context: context,
                initData: controller.addressArea.value.split(' '),
                dataType: DataType.town,
              );
              if (res != null && res.isNotEmpty) {
                controller.addressArea.value = res.join(' ');
              }
            },
            child: Obx(() {
              final city = controller.addressArea.value;
              return SizedBox(
                width: double.infinity,
                child: Text(
                  city.isNotEmpty ? city : '请选择',
                  style: TextStyle(
                    color: city.isNotEmpty ? null : Color(0xffA6A6A6),
                    fontSize: 16,
                  ),
                ),
              );
            }),
          ),
        ),
        _FormItem(
          label: '详细地址',
          arrow: false,
          child: TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              hintText: '街道门牌，楼层房间号等信息',
              hintStyle: TextStyle(color: Color(0xffA6A6A6), fontSize: 16),
            ),
            controller: TextEditingController(
              text: controller.addressDetail.value,
            ),
            onChanged: (value) {
              controller.addressDetail.value = value;
            },
          ),
        ),
        _FormItem(
          label: '设为默认',
          arrow: false,
          child: Transform.translate(
            offset: Offset(-15, 0),
            child: Obx(() {
              return SwitchWidget(
                value: controller.addressIsDefault.value,
                onChanged: (value) {
                  controller.addressIsDefault.value = value;
                },
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
        GradientButton(
          onPressed: () async {
            if (await controller.onAddressAddOrEdit()) {
              ToastUtil.info('保存成功');
              Navigator.of(context).pop(true);
            }
          },
          width: double.infinity,
          height: 48,
          child: Text('保存'),
        ),
      ],
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
        height: 60,
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
