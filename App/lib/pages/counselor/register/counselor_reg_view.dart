import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/widgets/component/circle_checkbox.dart';
import 'package:freud/widgets/keep_alive_page.dart';
import 'package:get/get.dart';

import 'counselor_reg_controller.dart';

class CounselorRegPage extends GetView<CounselorRegController> {
  const CounselorRegPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => CounselorRegController());
    return Scaffold(
      appBar: AppBar(title: Text('咨询师入驻'), backgroundColor: Colors.white),

      body: Obx(() {
        if (controller.applyResultStatus.value == 0) {
          return Column(
            children: [
              _RegProgressWidget(),
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    KeepalivePage(child: _IdCardContainer()),
                    KeepalivePage(child: _RegFormContainer()),
                    KeepalivePage(child: _ApplyResultContainer()),
                  ],
                ),
              ),
            ],
          );
        }
        return _ResultFailedContainer();
      }),
    );
  }
}

class _RegProgressWidget extends StatelessWidget {
  const _RegProgressWidget({super.key});

  // 顶部进度信息组件
  _buildItem({
    required String title,
    required String subTitle,
    required int index,
    bool? active,
  }) {
    return Expanded(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: active == true ? Color(0xff8299FF) : Color(0xffF7F7F7),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    color: active == true ? Colors.white : Color(0xff787878),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 10,
                    color: active == true ? Colors.white : Color(0xffCFC8CE),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: -7,
            child: Opacity(
              opacity: active == true ? 1 : 0.4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 7),
                height: 16,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffFFBADF), Color(0xfff870ff)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$index',
                  style: TextStyle(
                    color: active == true ? Colors.white : Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CounselorRegController>();
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          spacing: 10,
          children: [
            _buildItem(
              title: '信息认证',
              subTitle: '认证身份和账户信息',
              index: 1,
              active: controller.currentStep >= 0,
            ),
            Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xff8097ff)),
            _buildItem(
              title: '资料填写',
              subTitle: '填写咨询师申请资料',
              index: 2,
              active: controller.currentStep >= 1,
            ),
            Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xff8097ff)),
            _buildItem(
              title: '申请提交',
              subTitle: '提交入驻申请等待审核',
              index: 3,
              active: controller.currentStep >= 2,
            ),
          ],
        );
      }),
    );
  }
}

class _IdCardContainer extends StatelessWidget {
  const _IdCardContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CounselorRegController>();
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsGeometry.all(AppConst.PAGE_PADDING),
        child: Column(
          spacing: 10,
          children: [
            Container(
              padding: EdgeInsetsGeometry.all(14),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '请上传/拍摄您的身份证正面',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '请保持身份证完整清晰',
                    style: TextStyle(fontSize: 12, color: Color(0xff999999)),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    child: Image.asset('assets/images/idcard_front.png'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '请上传/拍摄您的身份证反面',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    '请保持身份证完整清晰',
                    style: TextStyle(fontSize: 12, color: Color(0xff999999)),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    child: Image.asset('assets/images/idcard_reverse.png'),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 42,
              child: OutlinedButton(
                onPressed: () {
                  controller.nextStep(1);
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color(0xff102069),
                  foregroundColor: Color(0xffFFDE82),
                  side: BorderSide.none,
                ),
                child: Text('下一步'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegFormContainer extends StatelessWidget {
  const _RegFormContainer({super.key});

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CounselorRegController>();
    return SingleChildScrollView(
      padding: EdgeInsetsGeometry.all(AppConst.PAGE_PADDING),
      child: Column(
        spacing: 10,
        children: [
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('咨询师资料', style: TextStyle(fontWeight: FontWeight.w500)),
                Text(
                  '请完成咨询师的资料填写',
                  style: TextStyle(fontSize: 12, color: Color(0xff999999)),
                ),
                Divider(color: Color(0xfff2f2f2)),
                _FormItemWidget(
                  title: '上传头像',
                  child: GestureDetector(
                    child: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Color(0xffE6EAFF)),
                      child: Icon(
                        Icons.camera_alt,
                        size: 20,
                        color: Color(0xff8097FF),
                      ),
                    ),
                  ),
                ),
                _FormItemWidget(
                  title: '入驻昵称',
                  child: TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: '请输入2-6个字的昵称',
                      hintStyle: TextStyle(
                        color: Color(0xffA6A6A6),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                _FormItemWidget(
                  title: '性别',
                  child: Row(
                    spacing: 15,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleCheckbox(
                        value: true,
                        fillColor: Colors.white,
                        side: BorderSide(color: Color(0xffA6A6A6)),
                        onChanged: (value) {},
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('男'),
                        ),
                      ),
                      CircleCheckbox(
                        value: false,
                        fillColor: Colors.white,
                        side: BorderSide(color: Color(0xffA6A6A6)),
                        onChanged: (value) {},
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('女'),
                        ),
                      ),
                    ],
                  ),
                ),
                _FormItemWidget(title: '入驻手机号', child: Text('135xxxx3454')),
              ],
            ),
          ),
          _buildCard(
            child: Column(
              children: [
                _FormItemWidget(
                  title: '当前所在地',
                  showArrow: true,
                  child: GestureDetector(
                    child: Text(
                      '请选择所在城市',
                      style: TextStyle(color: Color(0xffa6a6a6)),
                    ),
                  ),
                ),
                _FormItemWidget(
                  title: '从业经验',
                  child: TextField(
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: '请填写从业年限，例如：5',
                      hintStyle: TextStyle(
                        color: Color(0xffA6A6A6),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        height: 1,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                _FormItemWidget(
                  title: '最高学历',
                  showArrow: true,
                  child: GestureDetector(
                    child: Text(
                      '请选择学历',
                      style: TextStyle(color: Color(0xffa6a6a6)),
                    ),
                  ),
                ),
                _FormItemWidget(title: '上传最高学业证书'),
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Color(0xffE6EAFF)),
                        child: Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Color(0xff8097FF),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          _buildCard(
            child: Column(
              children: [
                _FormItemWidget(
                  title: '工作方式',
                  showArrow: true,
                  child: GestureDetector(
                    child: Text(
                      '请选择工作方式',
                      style: TextStyle(color: Color(0xffa6a6a6)),
                    ),
                  ),
                ),
                _FormItemWidget(title: '服务类型（可多选）'),
                SizedBox(
                  width: double.infinity,
                  child: _GridViewTypes(
                    itemCount: controller.serviceTypes.length,
                    itemBuilder: (index) {
                      return GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 36,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Color(0xfff5f7f9),
                          ),
                          child: Text(
                            controller.serviceTypes[index],
                            style: TextStyle(color: Color(0xffA6A6A6)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 5),
                _FormItemWidget(title: '擅长领域（可多选）'),
                SizedBox(
                  width: double.infinity,
                  child: _GridViewTypes(
                    itemCount: controller.fieldTypes.length,
                    itemBuilder: (index) {
                      return GestureDetector(
                        child: Container(
                          height: 36,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Color(0xfff5f7f9),
                          ),
                          child: Text(
                            controller.fieldTypes[index],
                            style: TextStyle(color: Color(0xffA6A6A6)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 5),
                _FormItemWidget(title: '咨询风格（可多选）'),
                SizedBox(
                  width: double.infinity,
                  child: _GridViewTypes(
                    itemCount: controller.styleTypes.length,
                    itemBuilder: (index) {
                      return GestureDetector(
                        child: Container(
                          height: 36,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Color(0xfff5f7f9),
                          ),
                          child: Text(
                            controller.styleTypes[index],
                            style: TextStyle(color: Color(0xffA6A6A6)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          _buildCard(
            child: Column(
              children: [
                _FormItemWidget(title: '个人简介'),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color(0xfff5f7f9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    minLines: 3,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: '请填写您的咨询师简介',
                      hintStyle: TextStyle(
                        color: Color(0xffa6a6a6),
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Row(
            spacing: 20,
            children: [
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton(
                    onPressed: () {
                      controller.nextStep(0);
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xff102069),
                      side: BorderSide.none,
                    ),
                    child: Text('上一步'),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: OutlinedButton(
                    onPressed: () {
                      controller.nextStep(2);
                      // 模拟审核失败
                      Future.delayed(Duration(seconds: 2), () {
                        controller.applyResultStatus.value = 1;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xff102069),
                      foregroundColor: Color(0xffFFDE82),
                      side: BorderSide.none,
                    ),
                    child: Text('提交'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FormItemWidget extends StatelessWidget {
  final String title;
  final Widget? child;
  final bool showArrow;

  const _FormItemWidget({
    super.key,
    required this.title,
    this.child,
    this.showArrow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      alignment: Alignment.centerLeft,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(fontSize: 14)),
          Expanded(
            child: Align(alignment: Alignment.centerRight, child: child),
          ),
          if (showArrow)
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: Color(0xff696969),
              ),
            ),
        ],
      ),
    );
  }
}

class _GridViewTypes extends StatelessWidget {
  final int itemCount;
  final Widget Function(int index) itemBuilder;
  final double? itemMaxWidth;
  final double? spacing;
  final double? runSpacing;

  const _GridViewTypes({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.itemMaxWidth,
    this.spacing,
    this.runSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (content, constraints) {
        final layoutWidth = constraints.maxWidth;
        return Wrap(
          runSpacing: runSpacing ?? 10,
          children: List.generate(itemCount, (index) => index).map((item) {
            final index = item;
            final rowSpacing = spacing ?? 10;
            int itemNum = (layoutWidth / (itemMaxWidth ?? 100)).toInt();
            double itemWidth =
                (layoutWidth - (itemNum - 1) * rowSpacing) / itemNum;

            return Container(
              width: itemWidth,
              margin: EdgeInsets.only(
                right: (index + 1) % itemNum == 0 ? 0 : rowSpacing,
              ),
              child: itemBuilder(index),
            );
          }).toList(),
        );
      },
    );
  }
}

class _ApplyResultContainer extends StatelessWidget {
  const _ApplyResultContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          Icon(Icons.check_circle, color: Color(0xff599E57), size: 55),
          Text('您的咨询师入驻申请已经提交', style: TextStyle(fontSize: 16)),
          Text(
            '申请将在1-3个工作日内处理\n请耐心等待审核结果',
            style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ResultFailedContainer extends StatelessWidget {
  const _ResultFailedContainer({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CounselorRegController>();
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      width: double.infinity,
      padding: const EdgeInsetsGeometry.symmetric(
        horizontal: AppConst.PAGE_PADDING,
      ),
      child: Column(
        children: [
          const SizedBox(height: 100),
          Text(
            '审核未通过',
            style: TextStyle(fontSize: 20, color: Color(0xffDE7373)),
          ),
          Text(
            '您提交的咨询师入驻申请审核未通过',
            style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 168,
            child: OutlinedButton(
              onPressed: () {
                controller.applyResultStatus.value = 0;
                controller.currentStep.value = 0;
                // 第二步：在当前帧绘制完成后执行跳转
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // 跳转到第二页（索引从0开始，所以是1）
                  controller.nextStep(0);
                });
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Color(0xff102069),
                side: BorderSide(color: Color(0xff8C99CF)),
              ),
              child: Text('修改资料'),
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 30),
            decoration: BoxDecoration(
              color: Color(0xffF5F7F9),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.only(
              top: 10,
              right: 14,
              left: 14,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('审核未通过原因', style: TextStyle(color: Color(0xffDE7373))),
                Text(
                  '这是审核未通过原因',
                  style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
