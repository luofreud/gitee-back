import 'package:flutter/material.dart';
import 'package:freud/constants/app_const.dart';
import 'package:freud/router/app_routes.dart';
import 'package:freud/widgets/page_background.dart';
import 'package:get/get.dart';

import 'revenue_income_controller.dart';

class RevenueIncomePage extends GetView<RevenueIncomeController> {
  const RevenueIncomePage({super.key});

  _buildTopTotal() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5,
        children: [
          Text('星钻余额'),
          Text(
            '1200',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xffFBFCFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 20,
                  bottom: 5,
                ),
                child: Row(
                  children: [
                    Text(
                      '￥ 120',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.COUNSELOR_REVENUE_WITHDRAW);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xff8097FF),
                        padding: EdgeInsets.zero,
                        overlayColor: Colors.transparent,
                      ),
                      child: Row(
                        children: [Text('去提现'), Icon(Icons.arrow_right)],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xffEFF4FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Text(
                    '可提现金额',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xff808080),
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RevenueIncomeController());
    return PageBackground(
      child: Scaffold(
        appBar: AppBar(
          title: Text('我的收入'),
          backgroundColor: Colors.white.withAlpha(0),
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConst.PAGE_PADDING,
          ),
          child: Column(
            spacing: 10,
            children: [
              _buildTopTotal(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () {},
                  title: Text('常见问题'),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // tileColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xff808080),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(AppRoutes.COUNSELOR_REVENUE_RECORD);
                      },
                      child: Row(
                        children: [
                          Text(
                            '提现记录',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Color(0xff808080),
                          ),
                        ],
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('星钻余额提现'),
                          subtitle: Text(
                            '12月1号  12:00',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xffA6A6A6),
                            ),
                          ),
                          leading: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Color(0xffD1D1D1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          trailing: Text(
                            '+ 1800',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xffFF5733),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          contentPadding: EdgeInsets.zero,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 1,
                          color: Color(0xffF2F2F2),
                          indent: 50,
                        );
                      },
                      itemCount: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
