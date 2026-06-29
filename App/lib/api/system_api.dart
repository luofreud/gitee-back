import 'package:dio/dio.dart';
import 'package:freud/models/system/upload_response.dart';
import 'package:freud/utils/request_util.dart';

import '../models/base/base_response.dart';

class SystemApi {
  ///
  /// 上传文件
  Future<UploadResponse?> upload(
    String filePath, {
    String? filename,
    ProgressCallback? onSendProgress,
  }) async {
    var res = await RequestUtil.getInstance().upload(
      "/appXzUser/uploadFile",
      FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath, filename: filename),
      }),
      onSendProgress: onSendProgress,
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse<UploadResponse>.fromJson(
      res?.data,
      (result) => UploadResponse.fromJson(result),
    );
    // var resJson = BaseRes<UploadRes?>.fromJson(res?.data, (result) {
    //   var resList = (res?.data as List<dynamic>)
    //       .map((e) => UploadRes.fromJson(e))
    //       .toList();
    //   return (resList != null && resList.isNotEmpty) ? resList[0] : null;
    // });
    return resJson.result;
  }
}
