import 'package:freud/models/base/page_request.dart';
import 'package:freud/models/base/page_response.dart';
import 'package:freud/models/tool/address.dart';
import 'package:freud/models/tool/archive.dart';
import 'package:freud/utils/request_util.dart';

import '../../models/base/base_response.dart';

class ToolApi {
  ///==============收货地址管理==============
  //获取收货地址列表
  Future<List<Address>?> addressPage() async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTakeAddress/getAddressPage",
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => (data as List<dynamic>)
          .map((item) => Address.fromJson(item))
          .toList(),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }

  // 获取默认收货地址
  Future<Address?> addressDefault() async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTakeAddress/getDefaultAddress",
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => Address.fromJson(data),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }

  // 新增/修改收货地址
  Future<bool> addressAddOrEdit(Address address) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTakeAddress/editAddAddress",
      data: address.toJson(),
    );
    if (res?.code != 200) return false;
    return true;
  }

  // 删除收货地址
  Future<bool> addressDel(int id) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzTakeAddress/addressDel",
      data: {"id": id},
    );
    if (res?.code != 200) return false;
    return true;
  }

  ///==============收货地址管理==============

  ///==============档案管理==============
  Future<PageData<Archive>?> archivePage(
    PageRequest req, {
    Map<String, dynamic>? filters,
  }) async {
    var data = req.toJson();
    if (filters != null) data.addAll(filters);
    var res = await RequestUtil.getInstance().post(
      "/appXzArchive/page",
      data: data,
    );

    if (res?.code != 200) return null;

    var resJson = PageResponse<Archive>.fromJson(
      res?.data,
      (data) => Archive.fromJson(data),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }

  Future<Archive?> archiveDetail(int id) async {
    var res = await RequestUtil.getInstance().get(
      "/appXzArchive/detail",
      params: {"id": id},
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => Archive.fromJson(data),
    );
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }

  Future<int?> archiveAdd(Archive archive) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzArchive/add",
      data: archive.toJson(),
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse<int>.fromJson(res?.data, (data) => data as int);
    if (resJson.code == 200) {
      return resJson.result;
    }
    return null;
  }

  Future<bool> archiveUpdate(Archive archive) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzArchive/update",
      data: archive.toJson(),
    );
    if (res?.code != 200) return false;
    return true;
  }

  Future<bool> archiveDelete(int id) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzArchive/delete",
      data: {"id": id},
    );
    if (res?.code != 200) return false;
    return true;
  }

  ///==============档案管理==============
}
