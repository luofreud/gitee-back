import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'protocol_controller.dart';

class ProtocolPage extends GetView<ProtocolController> {
  const ProtocolPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ProtocolController());
    var parameters = Get.parameters;
    controller.getProtocolContent(parameters['type'] ?? "");
    return Scaffold(
      appBar: AppBar(
        title: Text(parameters['type'] == 'service' ? '用户服务协议' : '隐私协议'),
      ),
      body: Center(
        child: Obx(() {
          return Text(
            controller.protocolContent.value,
            style: TextStyle(fontSize: 20),
          );
        }),
      ),
    );
  }
}
