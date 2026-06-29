import 'package:flutter/material.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/service/user_service.dart';
import 'package:freud/utils/address_util.dart';
import 'package:freud/utils/utils.dart';
import 'package:freud/widgets/component/image_view.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../constants/app_const.dart';
import '../../../widgets/component/menu_list_tile.dart';
import '../../login/login_view.dart';
import 'profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  static final Widget _divider = Divider(
    height: 1,
    color: Color(0xffF5F7F9),
    indent: AppConst.PAGE_PADDING,
    endIndent: AppConst.PAGE_PADDING,
  );

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProfileController());
    final userService = Get.find<UserService>();
    return Scaffold(
      appBar: AppBar(title: Text('个人资料'), backgroundColor: Colors.white),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(AppConst.PAGE_PADDING),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset(
                  'assets/images/profile_top.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: 156,
                ),
                Positioned(
                  child: Column(
                    spacing: 10,
                    children: [
                      Stack(
                        children: [
                          Obx(() {
                            return CircleAvatar(
                              radius: 33,
                              backgroundColor: Colors.grey.withAlpha(50),
                              foregroundImage: ImageView.provider(
                                userService.userinfo.value?.headimg ?? '',
                                maxWidth: 90,
                                maxHeight: 90,
                              ),
                            );
                          }),
                          Positioned(
                            right: 2,
                            bottom: 4,
                            child: GestureDetector(
                              onTap: () async {
                                DialogUtil.showMenuDialog(
                                  context: context,
                                  items: [
                                    DialogMenuItem(
                                      title: '拍照',
                                      onTap: (_) async {
                                        final entity =
                                            await CommonUtil.takePhoto(context);
                                        if (entity != null) {
                                          controller.cropperAvatar(entity);
                                        }
                                      },
                                    ),
                                    DialogMenuItem(
                                      title: '从相册中选取',
                                      onTap: (_) async {
                                        final result =
                                            await CommonUtil.selectImage(
                                              context,
                                              maxCount: 1,
                                              requestType: RequestType.image,
                                            );
                                        if (result != null &&
                                            result.isNotEmpty) {
                                          controller.cropperAvatar(result[0]);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                              child: CircleAvatar(
                                radius: 9,
                                backgroundColor: Color(0xff383838),
                                child: Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Obx(() {
                        return Text(
                          userService.userinfo.value?.nickname ?? '',
                          style: TextStyle(fontSize: 16),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
            Transform.translate(
              offset: Offset(0, -10),
              child: Card(
                elevation: 0,
                margin: const EdgeInsets.only(
                  left: AppConst.PAGE_PADDING,
                  right: AppConst.PAGE_PADDING,
                ),
                child: Column(
                  children: [
                    Obx(() {
                      return MenuListTile(
                        title: '昵称',
                        titlevalue: userService.userinfo.value?.nickname ?? '',
                        titleColor: Color(0xff808080),
                        radiusPosition: RadiusPosition.top,
                        onTap: () async {
                          await Get.toNamed(
                            AppRoutes.MINE_EDITNAME,
                            arguments:
                                userService.userinfo.value?.nickname ?? '',
                          );
                        },
                      );
                    }),
                    _divider,
                    Obx(() {
                      ;
                      return MenuListTile(
                        title: '性别',
                        titlevalue: userService.userinfo.value?.sex == 1
                            ? '女'
                            : '男',
                        titleColor: Color(0xff808080),
                        onTap: () {
                          DialogUtil.showMenuDialog(
                            context: context,
                            items: [
                              DialogMenuItem(
                                title: '男',
                                onTap: (_) async {
                                  controller.updateSex(0);
                                  Navigator.of(context).pop();
                                },
                              ),
                              DialogMenuItem(
                                title: '女',
                                onTap: (_) async {
                                  controller.updateSex(1);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }),
                    _divider,
                    Obx(() {
                      String birthday =
                          userService.userinfo.value?.birthday ?? '';
                      DateTime birthdayDate = DateTime.now();
                      if (birthday.isNotEmpty) {
                        birthdayDate = DateTime.parse(birthday);
                        birthday = CommonUtil.formatDate(
                          birthdayDate,
                          format: 'yyyy-MM-dd hh:mm',
                        );
                      }
                      return MenuListTile(
                        title: '出生日期',
                        titlevalue: birthday.isNotEmpty ? birthday : '-',
                        titleColor: Color(0xff808080),
                        onTap: () async {
                          final selectDate = await DialogUtil.showDatePicker(
                            context: context,
                            initialDate: birthdayDate,
                            showTime: true,
                          );
                          if (selectDate != null) {
                            await controller.updateBirthday(selectDate);
                          }
                        },
                      );
                    }),
                    _divider,
                    Obx(() {
                      return MenuListTile(
                        title: '出生地址',
                        titlevalue: userService.userinfo.value?.address ?? '-',
                        titleColor: Color(0xff808080),
                        onTap: () async {
                          var address = await AddressUtil.showDialog(
                            context: context,
                            dataType: DataType.city,
                            initData:
                                userService.userinfo.value?.address?.split(
                                  ' ',
                                ) ??
                                [],
                          );
                          if (address != null) {
                            String addressStr = address
                                .where(
                                  (item) => item != null && item.isNotEmpty,
                                )
                                .join(' ');
                            await controller.updateAddress(addressStr);
                          }
                        },
                      );
                    }),
                    _divider,
                    Obx(() {
                      return MenuListTile(
                        title: '现居地址',
                        titlevalue:
                            userService.userinfo.value?.nowaddress ?? '-',
                        titleColor: Color(0xff808080),
                        onTap: () async {
                          var address = await AddressUtil.showDialog(
                            context: context,
                            dataType: DataType.city,
                            initData:
                                userService.userinfo.value?.nowaddress?.split(
                                  ' ',
                                ) ??
                                [],
                          );
                          if (address != null) {
                            String addressStr = address
                                .where(
                                  (item) => item != null && item.isNotEmpty,
                                )
                                .join(' ');
                            await controller.updateNowAddress(addressStr);
                          }
                        },
                      );
                    }),
                    _divider,
                    Obx(() {
                      return MenuListTile(
                        title: '个性签名',
                        titlevalue: userService.userinfo.value?.sign ?? '',
                        titleColor: Color(0xff808080),
                        radiusPosition: RadiusPosition.bottom,
                        onTap: () async {
                          await Get.toNamed(
                            AppRoutes.MINE_EDITSIGN,
                            arguments: userService.userinfo.value?.sign ?? '',
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(
                left: AppConst.PAGE_PADDING,
                right: AppConst.PAGE_PADDING,
                bottom: 10,
              ),
              child: Column(
                children: [
                  Obx(() {
                    String phone = userService.userinfo.value?.phone ?? '-';
                    return MenuListTile(
                      title: '手机号',
                      titlevalue: phone.masked,
                      titleColor: Color(0xff808080),
                      radiusPosition: RadiusPosition.top,
                      onTap: () {
                        Get.toNamed(AppRoutes.MINE_BINDMOBILE);
                      },
                    );
                  }),
                  _divider,
                  MenuListTile(
                    title: '微信账户',
                    trailing: Text(
                      '已绑定',
                      style: TextStyle(color: Color(0xff2A82E4), fontSize: 14),
                    ),
                    titleColor: Color(0xff808080),
                    radiusPosition: RadiusPosition.bottom,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(
                left: AppConst.PAGE_PADDING,
                right: AppConst.PAGE_PADDING,
                bottom: 10,
              ),
              child: Column(
                children: [
                  MenuListTile(
                    titlevalue: '退出登录',
                    textAlign: TextAlign.center,
                    showArrow: false,
                    radiusPosition: RadiusPosition.both,
                    trailing: null,
                    onTap: () {
                      DialogUtil.showConfirmDialog(
                        title: '退出登录',
                        content: '确定退出登录吗？',
                        context: context,
                        onConfirm: (_) async {
                          Navigator.of(context).pop();
                          await Get.find<UserService>().logout();
                          Get.offAll(
                            LoginPage(),
                            transition: Transition.downToUp,
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
