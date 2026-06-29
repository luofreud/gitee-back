import 'package:freud/models/base/base_response.dart';
import 'package:freud/utils/request_util.dart';

class ImServerApi {
  Future<Map<String, dynamic>?> getServerConfig() async {
    var res = await RequestUtil.getInstance().get("/imserver/server-config");
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => data as Map<String, dynamic>,
    );
    if (resJson.code != 200 || resJson.result == null) return null;
    return resJson.result?['data'] as Map<String, dynamic>?;
  }
}
