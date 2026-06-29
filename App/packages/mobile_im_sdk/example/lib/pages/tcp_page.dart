import 'package:flutter/material.dart';
import 'package:mobile_im_sdk/mobile_im_sdk.dart';

import 'base_demo_page.dart';

class TcpPage extends BaseImDemoPage {
  const TcpPage({Key? key})
      : super(
          key: key,
          title: 'TCP 演示',
          connectionType: ConnectionType.tcp,
          defaultPort: '8901', // MobileIMSDK TCP 默认端口
        );

  @override
  State<TcpPage> createState() => _TcpPageState();
}

class _TcpPageState extends BaseImDemoPageState<TcpPage> {
  @override
  IMClient createClient() => TcpImClient();
}
