class XingpanChartRequest {
  /// 档案 ID，传此值自动从数据库填充出生信息（longitude/latitude/tz/birthday）
  int? archiveId;

  /// 行星 ID 列表：0=太阳 1=月亮 2=水星 3=金星 4=火星 5=木星 6=土星 7=天王星 8=海王星 9=冥王星
  List<String> planets;

  /// 小行星 ID 列表：10=凯龙星 11=谷神星 12=智神星 13=婚神星
  List<String>? planetXs;

  /// 虚点 ID 列表
  List<String>? virtual;

  /// 宫位制：k=Koch p=Placidus r=Regiomontanus w=Whole sign e=Equal
  String? hSys;

  /// SVG 输出模式：1=标准 0=高级 -1=仅数据（无图）
  String? svgType;

  /// 相位容许度覆盖，key=角度（如"90"）value=容许度（度）
  Map<String, String>? phase;

  /// 是否包含文案：1=包含 0/不传=仅数据
  String? isCorpus;

  /// 推运时间（yyyy-MM-dd HH:mm:ss），天象/行运/法达/次限/三限需要
  String? transitday;

  /// 出生经度（十进制，东经为正），不传 archiveId 时需要
  String? longitude;

  /// 出生纬度（十进制，北纬为正）
  String? latitude;

  /// 时区偏移（小时），如 +8
  String? tz;

  /// 出生时间（yyyy-MM-dd HH:mm:ss）
  String? birthday;

  XingpanChartRequest({
    this.archiveId,
    this.planets = const ["0", "1"],
    this.planetXs,
    this.virtual,
    this.hSys,
    this.svgType,
    this.phase,
    this.isCorpus,
    this.transitday,
    this.longitude,
    this.latitude,
    this.tz,
    this.birthday,
  });

  Map<String, dynamic> toJson() => {
    if (archiveId != null) 'archiveId': archiveId,
    'planets': planets,
    if (planetXs != null) 'planet_xs': planetXs,
    if (virtual != null) 'virtual': virtual,
    if (hSys != null) 'h_sys': hSys,
    if (svgType != null) 'svg_type': svgType,
    if (phase != null) 'phase': phase,
    if (isCorpus != null) 'is_corpus': isCorpus,
    if (transitday != null) 'transitday': transitday,
    if (longitude != null) 'longitude': longitude,
    if (latitude != null) 'latitude': latitude,
    if (tz != null) 'tz': tz,
    if (birthday != null) 'birthday': birthday,
  };
}

class XingpanCorpusRequest {
  /// 命中规则：0=全部 1=已命中
  final int fallInto;

  /// 星盘类型 ID（1-25）
  final int chartType;

  const XingpanCorpusRequest({required this.fallInto, required this.chartType});

  Map<String, dynamic> toJson() => {
    'fallInto': fallInto,
    'chartType': chartType,
  };
}
