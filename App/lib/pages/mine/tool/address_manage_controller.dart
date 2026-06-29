import 'package:easy_refresh/easy_refresh.dart';
import 'package:freud/api/api.dart';
import 'package:freud/models/tool/address.dart';
import 'package:get/get.dart';

import '../../../widgets/refresh_loadmore.dart';

class AddressManageController extends GetxController {
  final isManagePage = false.obs;
  late RefreshController refreshController;
  RxList<Address> listData = <Address>[].obs;
  final isLoading = false.obs;

  final defaultAddreddIndex = 1.obs;

  final addressId = 0.obs;
  final addressName = ''.obs;
  final addressPhone = ''.obs;
  final addressArea = ''.obs;
  final addressDetail = ''.obs;
  final addressIsDefault = false.obs;

  @override
  void onInit() {
    super.onInit();
    refreshController = RefreshController(
      controller: EasyRefreshController(controlFinishLoad: false),
    );
    listRefresh();
  }

  @override
  void onClose() {
    refreshController.dispose();
    super.onClose();
  }

  listRefresh() async {
    listData.clear();
    refreshController.resetFooter();
    if (isLoading.value) return;
    int length = listData.length;
    isLoading.value = true;
    listData.value = await ToolApi().addressPage() ?? [];
    isLoading.value = false;
    refreshController.finishLoad(IndicatorResult.noMore, true);
  }

  // 置顶操作
  onAddressTop(int index) async {
    defaultAddreddIndex.value = index;
  }

  // 重置表单各项数据
  resetFormValue(Address? address) {
    addressId.value = address?.id ?? 0;
    addressName.value = address?.name ?? '';
    addressPhone.value = address?.phone ?? '';
    addressArea.value = address?.area ?? '';
    addressDetail.value = address?.address ?? '';
    addressIsDefault.value = address?.isdefault == 1;
  }

  //提交新增和编辑
  Future<bool> onAddressAddOrEdit() async {
    final result = await ToolApi().addressAddOrEdit(
      Address(
        id: addressId.value,
        name: addressName.value,
        phone: addressPhone.value,
        area: addressArea.value,
        address: addressDetail.value,
        isdefault: addressIsDefault.value ? 1 : 0,
      ),
    );
    if (result) {
      listRefresh();
    }
    return result;
  }

  // 删除
  Future<bool> onAddressDel(Address address) async {
    final result = await ToolApi().addressDel(address.id ?? 0);
    if (result) {
      listRefresh();
    }
    return result;
  }

  // 设置默认
  Future<bool> onAddressDefault(Address address, bool isDefault) async {
    address.isdefault = isDefault ? 1 : 0;
    final result = await ToolApi().addressAddOrEdit(address);
    if (result) {
      listRefresh();
    }
    return result;
  }
}
