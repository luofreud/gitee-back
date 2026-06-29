import 'package:freud/utils/common_util.dart';
import 'package:freud/utils/dialog_util.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class CreationContentController extends GetxController {
  /// 标题
  final title = ''.obs;

  /// 内容
  final content = ''.obs;

  /// 图片
  final List<AssetEntity> selectAssets = [];
  final selectFilePaths = [].obs;

  List<String> get selectFileHerTags => selectFilePaths
      .asMap()
      .entries
      .map((e) => '${e.value.hashCode}_${e.key}')
      .toList();

  final isTest = false.obs;

  ///话题
  final topicText = ''.obs;

  /// 板块
  final category = '星盘'.obs;
  final categorys = ['星盘', '骰子', '智慧牌', '星1', '骰子2', '智慧牌3'].obs;

  /// 匿名
  final anonymous = false.obs;

  bool get allowPublish => title.value.isNotEmpty && content.value.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  publish(context) async {
    if (!allowPublish) {
      return;
    }
    CommonUtil.hideKeyShowUnfocus();

    await DialogUtil.showSuccess(context: context, title: '发布成功！');

    Get.back(closeOverlays: true);

    // title.value = '';
    // content.value = '';
    // selectAssets.clear();
    // selectFilePaths.clear();
    // topicText.value = '';

    //Get.back(canPop: true, closeOverlays: true);
  }
}
