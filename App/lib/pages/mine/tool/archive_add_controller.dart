import 'package:flutter/material.dart';
import 'package:freud/api/api.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/utils/toast_util.dart';
import 'package:freud/utils/utils.dart';
import 'package:get/get.dart';

class ArchiveAddController extends GetxController {
  late TextEditingController nameController;
  final name = ''.obs;

  final relationList = ['伴侣', '家人', '自己', '其他'];
  final relation = ''.obs;

  final sex = 1.obs;
  final Rx<DateTime?> birthday = Rx<DateTime?>(null);

  final address = ''.obs;
  final addresslat = ''.obs;
  final addresslong = ''.obs;

  final nowaddress = ''.obs;
  final nowaddresslat = ''.obs;
  final nowaddresslong = ''.obs;

  final timezoneJson = [
    {"name": "美国夏威夷", "utc_offset": "-11"},
    {"name": "美国夏威夷", "utc_offset": "-10"},
    {"name": "美国阿拉斯加地区", "utc_offset": "-9"},
    {"name": "土阿莫土群岛", "utc_offset": "-8"},
    {"name": "美国西部洛杉矶", "utc_offset": "-7"},
    {"name": "墨西哥（美国中部）", "utc_offset": "-6"},
    {"name": "美国东部", "utc_offset": "-5"},
    {"name": "巴拉圭", "utc_offset": "-4"},
    {"name": "巴西", "utc_offset": "-3"},
    {"name": "亚述尔群岛", "utc_offset": "-2"},
    {"name": "冰岛", "utc_offset": "-1"},
    {"name": "英格兰", "utc_offset": "0"},
    {"name": "意大利", "utc_offset": "1"},
    {"name": "土耳其", "utc_offset": "2"},
    {"name": "沙特", "utc_offset": "3"},
    {"name": "土库曼斯坦", "utc_offset": "4"},
    {"name": "印度", "utc_offset": "5"},
    {"name": "斯里兰卡", "utc_offset": "6"},
    {"name": "泰国", "utc_offset": "5"},
    {"name": "中国", "utc_offset": "8"},
    {"name": "日本", "utc_offset": "9"},
    {"name": "巴布亚新几内亚", "utc_offset": "10"},
    {"name": "所罗门群岛", "utc_offset": "11"},
    {"name": "斐济", "utc_offset": "12"},
  ];
  final timezone = '+08'.obs;

  final isdst = false.obs;

  final id = ''.obs;

  String get timezoneDisplay {
    final entry = timezoneJson.firstWhereOrNull(
      (e) => e['utc_offset'] == timezone.value,
    );
    if (entry != null) return '${entry['name']} (UTC${entry['utc_offset']})';
    return timezone.value;
  }

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments != null) {
      final archive = arguments as Archive;
      print(archive.toJson());
      name.value = archive.name ?? '';
      relation.value = archive.relation ?? '';
      sex.value = archive.sex ?? 1;
      birthday.value = DateTime.parse(archive.birthday ?? '');
      address.value = archive.address ?? '';
      addresslat.value = archive.addresslat ?? '';
      addresslong.value = archive.addresslong ?? '';
      nowaddress.value = archive.nowaddress ?? '';
      nowaddresslat.value = archive.nowaddresslat ?? '';
      nowaddresslong.value = archive.nowaddresslong ?? '';
      timezone.value = archive.timezone ?? '+08';
      isdst.value = archive.isdst == 1;
      id.value = archive.id?.toString() ?? '';
    }
    nameController = TextEditingController(text: name.value);
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }

  archiveSubmit() async {
    if (name.value.isEmpty) {
      ToastUtil.info('请填写姓名');
      return;
    }
    if (relation.value.isEmpty) {
      ToastUtil.info('请选择备注');
      return;
    }
    if (birthday.value == null) {
      ToastUtil.info('请选择出生时间');
      return;
    }
    if (address.value.isEmpty) {
      ToastUtil.info('请选择出生地点');
      return;
    }
    if (nowaddress.value.isEmpty) {
      ToastUtil.info('请选择现居地');
      return;
    }
    final data = Archive(
      id: int.tryParse(id.value),
      name: name.value,
      relation: relation.value,
      sex: sex.value,
      birthday: CommonUtil.formatDate(
        birthday.value,
        format: 'yyyy-MM-dd hh:mm',
      ),
      address: address.value,
      addresslat: addresslat.value,
      addresslong: addresslong.value,
      nowaddress: nowaddress.value,
      nowaddresslat: nowaddresslat.value,
      nowaddresslong: nowaddresslong.value,
      timezone: timezone.value,
      isdst: isdst.value ? 1 : 0,
    );
    if (id.value.isEmpty) {
      final newId = await ToolApi().archiveAdd(data);
      if (newId != null) {
        ToastUtil.success('保存成功');
        Get.back<int>(result: newId);
      }
    } else {
      final result = await ToolApi().archiveUpdate(data);
      if (result) {
        ToastUtil.success('保存成功');
        Get.back<int>(result: int.parse(id.value));
      }
    }
  }
}
