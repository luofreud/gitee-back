import 'package:freud/api/api.dart';
import 'package:freud/router/app_routes.dart';
import 'package:get/get.dart';

class DeleteAccountController extends GetxController {
  final agree = false.obs;

  void deleteAccount() async {
    final res = await UserApi().delete();
    if (res) {
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}
