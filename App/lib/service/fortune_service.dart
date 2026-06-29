import 'package:freud/api/xingpan/xingpan_api.dart';
import 'package:freud/models/xingpan/xingpan_request.dart';
import 'package:freud/utils/common_util.dart';
import 'package:freud/utils/sp_util.dart';
import 'package:get/get.dart';

class FortuneService extends GetxService {
  /// 加载今日运势
  Future<Map<String, dynamic>?> loadLuckDay(int archiveId) async {
    final key = 'home_luck_day_$archiveId';
    final today = CommonUtil.formatDate(DateTime.now(), format: 'yyyy-MM-dd');
    try {
      final cached = await SpUtil.getStorage(key);
      if (cached is Map && cached['date'] == today && cached['data'] != null) {
        return Map<String, dynamic>.from(cached['data']);
      }
    } catch (_) {}
    final result = await XingpanApi().luckDay(
      XingpanChartRequest(archiveId: archiveId),
    );
    if (result != null) {
      final data = Map<String, dynamic>.from(result);
      await SpUtil.setStorage(key, {'date': today, 'data': data});
      return data;
    }
    return null;
  }

  /// 加载本月运势
  Future<Map<String, dynamic>?> loadLuckMoon(int archiveId) async {
    final key = 'home_luck_moon_$archiveId';
    final period = CommonUtil.formatDate(DateTime.now(), format: 'yyyy-MM');
    try {
      final cached = await SpUtil.getStorage(key);
      if (cached is Map && cached['date'] == period && cached['data'] != null) {
        return Map<String, dynamic>.from(cached['data']);
      }
    } catch (_) {}
    final result = await XingpanApi().luckMoon(
      XingpanChartRequest(archiveId: archiveId),
    );
    if (result != null) {
      final data = Map<String, dynamic>.from(result);
      await SpUtil.setStorage(key, {'date': period, 'data': data});
      return data;
    }
    return null;
  }

  /// 加载本年运势
  Future<Map<String, dynamic>?> loadLuckYear(int archiveId) async {
    final key = 'home_luck_year_$archiveId';
    final period = CommonUtil.formatDate(DateTime.now(), format: 'yyyy');
    try {
      final cached = await SpUtil.getStorage(key);
      if (cached is Map && cached['date'] == period && cached['data'] != null) {
        return Map<String, dynamic>.from(cached['data']);
      }
    } catch (_) {}
    final result = await XingpanApi().luckYear(
      XingpanChartRequest(archiveId: archiveId),
    );
    if (result != null) {
      final data = Map<String, dynamic>.from(result);
      await SpUtil.setStorage(key, {'date': period, 'data': data});
      return data;
    }
    return null;
  }
}
