import '../../models/base/base_response.dart';
import '../../models/tool/astrocalendar.dart';
import '../../models/xingpan/xingpan_request.dart';
import '../../utils/request_util.dart';

class XingpanApi {
  ///==============星象日历==============
  Future<List<XzAstrocalendar>?> getCalendarByDay({
    int? year,
    int? month,
    int? day,
  }) async {
    var res = await RequestUtil.getInstance().get(
      "/appXzAstrocalendar/getCalendarByDay",
      params: {
        if (year != null) 'year': year,
        if (month != null) 'month': month,
        if (day != null) 'day': day,
      },
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => (data as List<dynamic>)
          .map((item) => XzAstrocalendar.fromJson(item))
          .toList(),
    );
    if (resJson.code == 200) return resJson.result;
    return null;
  }

  Future<Map<int, XzAstrocalendar>?> getCalendarByMonth({
    int? year,
    int? month,
  }) async {
    var res = await RequestUtil.getInstance().get(
      "/appXzAstrocalendar/getCalendarByMonth",
      params: {
        if (year != null) 'year': year,
        if (month != null) 'month': month,
      },
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(
      res?.data,
      (data) => (data as List<dynamic>)
          .map((item) => XzAstrocalendar.fromJson(item))
          .toList(),
    );
    if (resJson.code != 200 || resJson.result == null) return null;
    return {
      for (var e in resJson.result!)
        if (e.day != null) e.day!: e,
    };
  }

  ///==============星象日历==============

  ///==============星盘运算==============
  /// 星盘运算通用 POST 请求
  /// [path] API 路径（如 natal/current/transit），[data] 请求体参数
  Future<dynamic> _post(String path, Map<String, dynamic> data) async {
    var res = await RequestUtil.getInstance().post(
      "/appXzXingpan/$path",
      data: data,
    );
    if (res?.code != 200) return null;
    var resJson = BaseResponse.fromJson(res?.data, (data) => data);
    if (resJson.code == 200) return resJson.result;
    return null;
  }

  /// 获取本命盘
  Future<dynamic> natal(XingpanChartRequest data) =>
      _post('natal', data.toJson());

  /// 获取天象盘
  Future<dynamic> current(XingpanChartRequest data) =>
      _post('current', data.toJson());

  /// 获取行运盘
  Future<dynamic> transit(XingpanChartRequest data) =>
      _post('transit', data.toJson());

  /// 获取三限盘
  Future<dynamic> thirdProgressed(XingpanChartRequest data) =>
      _post('thirdProgressed', data.toJson());

  /// 获取法达盘
  Future<dynamic> developed(XingpanChartRequest data) =>
      _post('developed', data.toJson());

  /// 获取副限盘
  Future<dynamic> secondaryLimit(XingpanChartRequest data) =>
      _post('secondaryLimit', data.toJson());

  /// 获取双限盘
  Future<dynamic> thirdProgressedDouble(XingpanChartRequest data) =>
      _post('thirdProgressedDouble', data.toJson());

  /// 获取星盘文案列表
  Future<dynamic> corpusGetList(XingpanCorpusRequest data) =>
      _post('corpusGetList', data.toJson());

  /// 获取组合盘（[data] 第一人星盘参数 + archiveId，[archiveId2] 第二人档案 ID）
  Future<dynamic> composite(XingpanChartRequest data, int archiveId2) {
    final map = data.toJson();
    map['archiveId1'] = data.archiveId;
    map['archiveId2'] = archiveId2;
    map.remove('archiveId');
    return _post('composite', map);
  }

  /// 获取日返照盘
  Future<dynamic> solarReturn(XingpanChartRequest data, int archiveId2) {
    final map = data.toJson();
    map['archiveId1'] = data.archiveId;
    map['archiveId2'] = archiveId2;
    map.remove('archiveId');
    return _post('solarReturn', map);
  }

  /// 获取月返照盘
  Future<dynamic> lunarReturn(XingpanChartRequest data, int archiveId2) {
    final map = data.toJson();
    map['archiveId1'] = data.archiveId;
    map['archiveId2'] = archiveId2;
    map.remove('archiveId');
    return _post('lunarReturn', map);
  }

  ///==============星盘运算==============

  /// 韦特塔罗占卜（[number] 抽牌张数，1-78，>78 即整副）
  Future<dynamic> tarotGenerate({int number = 3}) =>
      _post('tarotGenerate', {'number': number});

  /// 骰子占卜
  Future<dynamic> diceGenerate() => _post('diceGenerate', {});

  ///==============运势==============
  /// 获取日运（今日运势）
  Future<dynamic> luckDay(XingpanChartRequest data) =>
      _post('luckDay', data.toJson());

  /// 获取周运（本周运势）
  Future<dynamic> luckWeeks(XingpanChartRequest data) =>
      _post('luckWeeks', data.toJson());

  /// 获取月运（本月运势）
  Future<dynamic> luckMoon(XingpanChartRequest data) =>
      _post('luckMoon', data.toJson());

  /// 获取年运（本年运势）
  Future<dynamic> luckYear(XingpanChartRequest data) =>
      _post('luckYear', data.toJson());
  ///==============运势==============
}
