import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:get/get.dart';

import '../../../utils/dialog_util.dart';
import '../../../widgets/component/image_view.dart';
import '../../../widgets/gradient_button.dart';
import 'sales_service_detail_controller.dart';

class SalesServiceDetailPage extends GetView<SalesServiceDetailController> {
  const SalesServiceDetailPage({super.key});

  _buildServiceStatus() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xffF5F7F9),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '申请退款',
            style: TextStyle(fontSize: 14, color: Color(0xff808080)),
          ),
          Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xff808080)),
          Text(
            '平台处理',
            style: TextStyle(fontSize: 14, color: Color(0xff808080)),
          ),
          Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xff808080)),
          Text('退款结束'),
        ],
      ),
    );
  }

  _buildOrderInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Color(0xffE5E5E5)),
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(radius: 20),
            horizontalTitleGap: 10,
            minTileHeight: 30,
            title: Text('白日依山尽'),
            subtitle: Text(
              '5.2星钻/分钟',
              style: TextStyle(fontSize: 12, color: Color(0xffA6A6A6)),
            ),
            trailing: Text(
              '问答咨询',
              style: TextStyle(fontSize: 16, color: Color(0xff808080)),
            ),
          ),
          Row(
            spacing: 10,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text.rich(
                style: TextStyle(fontSize: 12),
                TextSpan(
                  children: [
                    TextSpan(text: '免费：'),
                    TextSpan(text: '3', style: TextStyle(fontSize: 20)),
                    TextSpan(text: ' 分钟'),
                  ],
                ),
              ),
              Text.rich(
                style: TextStyle(fontSize: 12),
                TextSpan(
                  children: [
                    TextSpan(text: '付费：'),
                    TextSpan(text: '6', style: TextStyle(fontSize: 20)),
                    TextSpan(text: ' 分钟'),
                  ],
                ),
              ),
              Spacer(),
              Text.rich(
                style: TextStyle(fontSize: 12),
                TextSpan(
                  children: [
                    TextSpan(text: '消费 '),
                    TextSpan(text: '32.1', style: TextStyle(fontSize: 20)),
                    TextSpan(text: ' 星钻'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildRefundDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Text(
          '退款原因',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Text(
          '原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因原因。',
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            itemCount: 5,
            separatorBuilder: (_, index) {
              return const SizedBox(width: 10);
            },
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: ImageView.network(
                  'https://picsum.photos/200/300?t=$index',
                  height: 100,
                  width: 100,
                  urls: List.generate(
                    9,
                    (item) => 'https://picsum.photos/200/300?t=$index',
                  ),
                  showIndicator: true,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }

  _buildServiceInfo(context) {
    final labelStyle = TextStyle(fontSize: 12, color: Color(0xffA6A6A6));
    return Column(
      spacing: 5,
      children: [
        Row(
          spacing: 5,
          children: [
            Text('退款原因：', style: labelStyle),
            Expanded(
              child: Text(
                '退款原因退款原因退款原因退款原因退款原因退款原因退款原因退款原因',
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: labelStyle,
              ),
            ),
            GestureDetector(
              onTap: () {
                DialogUtil.showModalBottom(
                  context: context,
                  child: _buildRefundDetail(),
                );
              },
              child: Text('查看'),
            ),
          ],
        ),
        Row(
          children: [
            Text('申请金额：', style: labelStyle),
            const Spacer(),
            Text('共31.2星钻', style: labelStyle),
          ],
        ),
        Row(
          children: [
            Text('退款完结：', style: labelStyle),
            const Spacer(),
            Text('2022-01-01 12:00:00', style: labelStyle),
          ],
        ),
        Row(
          children: [
            Text('申请时间：', style: labelStyle),
            const Spacer(),
            Text('2022-01-01 12:00:00', style: labelStyle),
          ],
        ),
        Row(
          children: [
            Text('退款编号：', style: labelStyle),
            const Spacer(),
            Text('20220101120000', style: labelStyle),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SalesServiceDetailController());

    return Scaffold(
      appBar: AppBar(title: const Text('售后详情'), backgroundColor: Colors.white),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsetsGeometry.all(AppConst.PAGE_PADDING),
        child: Column(
          children: [
            _buildServiceStatus(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                spacing: 5,
                children: [
                  Text('退款成功', style: TextStyle(fontSize: 24)),
                  Text('退款 ￥35'),
                ],
              ),
            ),
            Divider(color: Color(0xffF5F7F9)),
            _buildOrderInfo(),
            const SizedBox(height: 10),
            _buildServiceInfo(context),
            Divider(color: Color(0xffF5F7F9)),
            Row(
              spacing: 10,
              children: [
                const Spacer(),
                GradientButton(
                  onPressed: () async {
                    var result = await DialogUtil.showConfirmDialog(
                      context: context,
                      position: DialogPosition.center,
                      title: '确定要删除该记录吗？',
                    );
                    if (result) {
                      // todo 删除
                    }
                  },
                  gradient: LinearGradient(
                    colors: [Color(0xffF5F7F9), Color(0xffF5F7F9)],
                  ),
                  foregroundColor: Color(0xff383838),
                  isRadius: false,
                  child: Text('删除记录'),
                ),
                GradientButton(
                  onPressed: () async {
                    var result = await DialogUtil.showConfirmDialog(
                      context: context,
                      position: DialogPosition.center,
                      title: '确定要取消此订单的售后吗？',
                    );
                    if (result) {
                      // todo 取消售后单
                    }
                  },
                  gradient: LinearGradient(
                    colors: [Color(0xffF5F7F9), Color(0xffF5F7F9)],
                  ),
                  foregroundColor: Color(0xff383838),
                  isRadius: false,
                  child: Text('取消售后'),
                ),
                GradientButton(
                  onPressed: () {},
                  gradient: LinearGradient(
                    colors: [Color(0xffECE3FF), Color(0xffE3EAFF)],
                  ),
                  foregroundColor: Color(0xff2F4791),
                  isRadius: false,
                  child: Text('联系客服'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
