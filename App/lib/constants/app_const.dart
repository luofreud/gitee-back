import 'package:flutter/material.dart';

class AppConst {
  static const String APP_NAME = "问问星座";

  static const String API_BASE_URL =
      "http://192.168.1.90:5006/api"; //"http://106.52.53.133:5005/api" http://192.168.1.90:5006/api;

  static const Color PRIMARY_COLOR = Color(0xff4D1FAE);

  static const Color PAGE_BACKGROUND_COLOR = Color(0xffF5F7F9);

  ///页面边距
  static const double PAGE_PADDING = 12.0;

  /// 星盘数据列表（索引即 ID 0-13）
  /// 0-9 行星，10 上升，11 天顶，12 北交点，13 地球
  static const List<({String name, String icon})> XINGXING_ICON = [
    (name: '太阳', icon: 'taiyang'),
    (name: '月亮', icon: 'yueliang'),
    (name: '水星', icon: 'shuixing'),
    (name: '金星', icon: 'jinxing'),
    (name: '火星', icon: 'huoxing'),
    (name: '木星', icon: 'muxing'),
    (name: '土星', icon: 'tuxing'),
    (name: '天王星', icon: 'tianwangxing'),
    (name: '海王星', icon: 'haiwangxing'),
    (name: '冥王星', icon: 'mingwangxing'),
    (name: '上升', icon: 'shangsheng'),
    (name: '天顶', icon: 'tianding'),
    (name: '北交点', icon: 'beijiao'),
    (name: '地球', icon: 'diqiu'),
  ];

  /// 按 ID（0-13）取中文名
  static String XINGXING_ICON_ID(int id) => XINGXING_ICON[id].name;

  /// 按中文名取图标文件名（找不到返回 null）
  static String? XINGXING_ICON_NAME(String name) {
    final i = XINGXING_ICON.indexWhere((e) => e.name == name);
    return i >= 0 ? XINGXING_ICON[i].icon : null;
  }

  /// 星座列表（黄道顺序），name=中文名，icon=icon_circle_文件名
  static const List<({String name, String icon})> CONSTELLATION = [
    (name: '白羊座', icon: 'icon_circle_by'),
    (name: '金牛座', icon: 'icon_circle_jn'),
    (name: '双子座', icon: 'icon_circle_sz'),
    (name: '巨蟹座', icon: 'icon_circle_jx'),
    (name: '狮子座', icon: 'icon_circle_shizi'),
    (name: '处女座', icon: 'icon_circle_cn'),
    (name: '天秤座', icon: 'icon_circle_tc'),
    (name: '天蝎座', icon: 'icon_circle_tx'),
    (name: '射手座', icon: 'icon_circle_ss'),
    (name: '摩羯座', icon: 'icon_circle_mj'),
    (name: '水瓶座', icon: 'icon_circle_sp'),
    (name: '双鱼座', icon: 'icon_circle_sy'),
  ];

  /// 塔罗牌 0-77 → 文件名（对应 assets/images/taluopai/{name}.jpg）
  static const List<String> TAROT_CARD_NAMES = [
    // 大阿卡那 Major Arcana (0-21)
    '0-fool',
    '1-magician',
    '2-high-priestess',
    '3-empress',
    '4-emperor',
    '5-hierophant',
    '6-lovers',
    '7-chariot',
    '8-strength',
    '9-hermit',
    '10-fortune-wheel',
    '11-justice',
    '12-hanged-man',
    '13-death',
    '14-temperance',
    '15-devil',
    '16-tower',
    '17-stars',
    '18-moon',
    '19-sun',
    '20-judgement',
    '21-world',
    // 权杖 Wands (22-35)
    'wands-1-ace-wands',
    'wands-2-two-wands',
    'wands-3-three-wands',
    'wands-4-four-wands',
    'wands-5-five-wands',
    'wands-6-six-wands',
    'wands-7-seven-wands',
    'wands-8-eight-wands',
    'wands-9-nine-wands',
    'wands-10-ten-wands',
    'wands-11-page-wands',
    'wands-12-knight-wands',
    'wands-13-queen-wands',
    'wands-14-king-wands',
    // 圣杯 Cups (36-49)
    'cups-1-ace-cups',
    'cups-2-two-cups',
    'cups-3-three-cups',
    'cups-4-four-cups',
    'cups-5-five-cups',
    'cups-6-six-cups',
    'cups-7-seven-cups',
    'cups-8-eight-cups',
    'cups-9-nine-cups',
    'cups-10-ten-cups',
    'cups-11-page-cups',
    'cups-12-knight-cups',
    'cups-13-queen-cups',
    'cups-14-king-cups',
    // 宝剑 Swords (50-63)
    'swords-1-ace-swords',
    'swords-2-two-swords',
    'swords-3-three-swords',
    'swords-4-four-swords',
    'swords-5-five-swords',
    'swords-6-six-swords',
    'swords-7-seven-swords',
    'swords-8-eight-swords',
    'swords-9-nine-swords',
    'swords-10-ten-swords',
    'swords-11-page-swords',
    'swords-12-knight-swords',
    'swords-13-queen-swords',
    'swords-14-king-swords',
    // 星币 Pentacles (64-77)
    'pentacles-1-ace-pentacles',
    'pentacles-2-two-pentacles',
    'pentacles-3-three-pentacles',
    'pentacles-4-four-pentacles',
    'pentacles-5-five-pentacles',
    'pentacles-6-six-pentacles',
    'pentacles-7-seven-pentacles',
    'pentacles-8-eight-pentacles',
    'pentacles-9-nine-pentacles',
    'pentacles-10-ten-pentacles',
    'pentacles-11-page-pentacles',
    'pentacles-12-knight-pentacles',
    'pentacles-13-queen-pentacles',
    'pentacles-14-king-pentacles',
  ];
}

/// 字符串扩展
extension StringExtension on String {
  /// 隐藏手机号中间4位
  String get masked {
    if (this.length != 11) return this; // 如果不是11位，直接返回原值（或者按需处理）

    // 这里使用 substring 方式，性能略优于正则
    return '${this.substring(0, 3)}****${this.substring(7)}';
  }
}
