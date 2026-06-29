import 'package:get/get.dart';

class ProtocolController extends GetxController {
  String _type = "service";
  final protocolContent = "".obs;

  /// 获取协议内容
  getProtocolContent(String type) {
    _type = type;
    Future.delayed(Duration(milliseconds: 500), () {
      protocolContent.value = _type == 'service' ? "服务协议" : "隐私协议";
    });
  }
}
