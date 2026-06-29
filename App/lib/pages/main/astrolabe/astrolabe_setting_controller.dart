import 'package:freud/utils/sp_util.dart';
import 'package:get/get.dart';

class AstrolabeSettingController extends GetxController {
  /// 本地缓存键名，存储所有星盘设置
  static const _cacheKey = 'astrolabe_setting';

  @override
  void onInit() {
    super.onInit();
    loadFromCache();
  }

  /// 从本地缓存加载星盘设置，覆盖默认值
  Future<void> loadFromCache() async {
    final data = await SpUtil.getStorage(_cacheKey);
    if (data == null || data is! Map) return;
    if (data['planetSelectedValues'] != null) {
      planetSelectedValues.value = Set<String>.from(
        data['planetSelectedValues'] as List,
      );
    }
    if (data['pointSelectedValues'] != null) {
      pointSelectedValues.value = Set<String>.from(
        data['pointSelectedValues'] as List,
      );
    }
    if (data['asteroidSelectedValues'] != null) {
      asteroidSelectedValues.value = Set<String>.from(
        data['asteroidSelectedValues'] as List,
      );
    }
    if (data['selectedStarMode'] != null) {
      selectedStarMode.value = data['selectedStarMode'] as String;
    }
    if (data['selectedHouse'] != null) {
      selectedHouse.value = data['selectedHouse'] as String;
    }
    if (data['phaseSelectedValues'] != null) {
      phaseSelectedValues.value = Set<String>.from(
        data['phaseSelectedValues'] as List,
      );
    }
    if (data['phaseValues'] != null) {
      phaseValues.value = Map<String, String>.from(data['phaseValues'] as Map);
    }
  }

  /// 行星列表
  final planetList = [
    {'name': '太阳', 'value': '0', 'alwaysSelected': true},
    {'name': '月亮', 'value': '1', 'alwaysSelected': true},
    {'name': '水星', 'value': '2'},
    {'name': '金星', 'value': '3'},
    {'name': '火星', 'value': '4'},
    {'name': '木星', 'value': '5'},
    {'name': '土星', 'value': '6'},
    {'name': '天王星', 'value': '7'},
    {'name': '海王星', 'value': '8'},
    {'name': '冥王星', 'value': '9'},
    {'name': '真实的月切点', 'value': 't'},
  ];

  /// 行星选中值集合（默认选中太阳、月亮）
  final planetSelectedValues = <String>{'0', '1'}.obs;

  /// 是否展开显示全部行星
  final planetShowAll = false.obs;

  /// 当前显示的行星列表（未展开时仅前5个）
  List<Map<String, dynamic>> get planetDisplayList {
    return planetShowAll.value
        ? List.from(planetList)
        : planetList.sublist(0, 5);
  }

  /// 切换展开/收起全部行星
  void togglePlanetShowAll() => planetShowAll.toggle();

  /// 虚点列表
  final pointList = [
    {'name': '上升', 'value': '10'},
    {'name': '中天', 'value': '11'},
    {'name': '天底点', 'value': '19'},
    {'name': '下降点', 'value': '18'},
    {'name': '北交点', 'value': 'm'},
    {'name': '南交点', 'value': '21'},
    {'name': '莉莉丝点', 'value': 'A'},
    {'name': '福点', 'value': 'pFortune'},
    {'name': '宿命点', 'value': '13'},
    {'name': '东升点', 'value': '14'},
    {'name': '日月中点', 'value': '20'},
  ];

  /// 虚点选中值集合（默认全不选）
  final pointSelectedValues = <String>{}.obs;

  /// 是否展开显示全部虚点
  final pointShowAll = false.obs;

  /// 当前显示的虚点列表（未展开时仅前3个）
  List<Map<String, dynamic>> get pointDisplayList {
    return pointShowAll.value ? List.from(pointList) : pointList.sublist(0, 3);
  }

  /// 切换展开/收起全部虚点
  void togglePointShowAll() => pointShowAll.toggle();

  /// 小行星列表
  final asteroidList = [
    {'name': '凯龙星', 'value': 'D'},
    {'name': '谷神星', 'value': 'F'},
    {'name': '人龙星', 'value': 'E'},
    {'name': '智神星', 'value': 'G'},
    {'name': '婚神星', 'value': 'H'},
    {'name': '灶神星', 'value': 'I'},
    {'name': '爱神星', 'value': '433'},
    {'name': '灵神星', 'value': '16'},
  ];

  /// 小行星选中值集合（默认全不选）
  final asteroidSelectedValues = <String>{}.obs;

  /// 是否展开显示全部小行星
  final asteroidShowAll = false.obs;

  /// 当前显示的小行星列表（未展开时仅前3个）
  List<Map<String, dynamic>> get asteroidDisplayList {
    return asteroidShowAll.value
        ? List.from(asteroidList)
        : asteroidList.sublist(0, 3);
  }

  /// 切换展开/收起全部小行星
  void toggleAsteroidShowAll() => asteroidShowAll.toggle();

  /// 切换小行星选中状态
  void toggleAsteroid(String value, bool selected) {
    if (selected) {
      asteroidSelectedValues.add(value);
    } else {
      asteroidSelectedValues.remove(value);
    }
    _saveToCache();
  }

  /// 切换虚点选中状态
  void togglePoint(String value, bool selected) {
    if (selected) {
      pointSelectedValues.add(value);
    } else {
      pointSelectedValues.remove(value);
    }
    _saveToCache();
  }

  /// 切换行星选中状态
  void togglePlanet(String value, bool selected) {
    if (selected) {
      planetSelectedValues.add(value);
    } else {
      planetSelectedValues.remove(value);
    }
    _saveToCache();
  }

  /// 恒星模式列表
  final starModeList = [
    {'name': '无', 'value': '-1'},
    {'name': 'Fagan/Bradley', 'value': '0'},
    {'name': 'Lahiri', 'value': '1'},
    {'name': 'De Luce', 'value': '2'},
    {'name': 'Raman', 'value': '3'},
    {'name': 'Usha/Shashi', 'value': '4'},
    {'name': 'Krishnamurti', 'value': '5'},
    {'name': 'Djwhal Khul', 'value': '6'},
    {'name': 'Yukteshwar', 'value': '7'},
    {'name': 'J.N. Bhasin', 'value': '8'},
    {'name': 'Babylonian/Kugler 1', 'value': '9'},
    {'name': 'Babylonian/Kugler 2', 'value': '10'},
    {'name': 'Babylonian/Kugler 3', 'value': '11'},
    {'name': 'Babylonian/Huber', 'value': '12'},
    {'name': 'Babylonian/Eta Piscium', 'value': '13'},
    {'name': 'Babylonian/Aldebaran = 15 Tau', 'value': '14'},
    {'name': 'Hipparchos', 'value': '15'},
    {'name': 'Sassanian', 'value': '16'},
    {'name': 'Galact. Center = 0 Sag', 'value': '17'},
    {'name': 'J2000', 'value': '18'},
    {'name': 'J1900', 'value': '19'},
    {'name': 'B1950', 'value': '20'},
    {'name': 'Suryasiddhanta', 'value': '21'},
    {'name': 'Suryasiddhanta, mean Sun', 'value': '22'},
    {'name': 'Aryabhata', 'value': '23'},
    {'name': 'Aryabhata, mean Sun', 'value': '24'},
    {'name': 'SS Revati', 'value': '25'},
    {'name': 'SS Citra', 'value': '26'},
    {'name': 'True Citra', 'value': '27'},
    {'name': 'True Revati', 'value': '28'},
    {'name': 'True Pushya (PVRN Rao)', 'value': '29'},
    {'name': 'Galactic (Gil Brand)', 'value': '30'},
    {'name': 'Galactic Equator (IAU1958)', 'value': '31'},
    {'name': 'Galactic Equator', 'value': '32'},
    {'name': 'Galactic Equator mid-Mula', 'value': '33'},
    {'name': 'Skydram (Mardyks)', 'value': '34'},
    {'name': 'True Mula (Chandra Hari)', 'value': '35'},
    {'name': 'Dhruva/Gal.Center/Mula (Wilhelm)', 'value': '36'},
    {'name': 'Aryabhata 522', 'value': '37'},
    {'name': 'Babylonian/Britton', 'value': '38'},
    {'name': 'Vedic/Sheoran', 'value': '39'},
    {'name': 'Cochrane (Gal.Center = 0 Cap)', 'value': '40'},
    {'name': 'Galactic Equator (Fiorenza)', 'value': '41'},
    {'name': 'Vettius Valens', 'value': '42'},
    {'name': 'Lahiri 1940', 'value': '43'},
    {'name': 'Lahiri VP285 (1980)', 'value': '44'},
    {'name': 'Krishnamurti VP291', 'value': '45'},
    {'name': 'Lahiri ICRC', 'value': '46'},
  ];

  /// 当前选择的恒星模式值（默认 无 → '-1'）
  final selectedStarMode = '-1'.obs;

  /// 当前显示的恒星模式名称
  String get selectedStarModeName {
    final entry = starModeList.firstWhereOrNull(
      (h) => h['value'] == selectedStarMode.value,
    );
    return entry != null ? entry['name'] as String : selectedStarMode.value;
  }

  /// 宫位系统列表
  final houseList = [
    {'name': 'Koch', 'value': 'K'},
    {'name': 'Placidus', 'value': 'P'},
    {'name': 'Porphyrius', 'value': 'O'},
    {'name': 'Regiomontanus', 'value': 'R'},
    {'name': 'Campanus', 'value': 'C'},
    {'name': 'Equal', 'value': 'E'},
    {'name': 'Vehlow equal', 'value': 'V'},
    {'name': 'Whole sign', 'value': 'W'},
    {'name': 'Axial rotation system', 'value': 'X'},
    {'name': 'Azimuthal or horizontal system', 'value': 'H'},
    {'name': 'Polich/Page', 'value': 'T'},
    {'name': 'Alcabitus', 'value': 'B'},
    {'name': 'Morinus', 'value': 'M'},
    {'name': 'Krusinski-Pisa', 'value': 'U'},
  ];

  /// 当前选择的宫位系统值（默认 Equal → E）
  final selectedHouse = 'K'.obs;

  /// 当前显示的宫位系统名称
  String get selectedHouseName {
    final entry = houseList.firstWhereOrNull(
      (h) => h['value'] == selectedHouse.value,
    );
    return entry != null ? entry['name'] as String : selectedHouse.value;
  }

  final xiangweiList1 = [
    0.5,
    1,
    1.5,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
  ];
  final xiangweiList2 = [0.5, 1, 1.5, 2, 3, 4, 5, 6];

  /// 相位容许度列表
  final phaseList = [
    {'name': '合相(0°)', 'value': '0', 'listType': 1},
    {'name': '冲相(180°)', 'value': '180', 'listType': 1},
    {'name': '拱相(120°)', 'value': '120', 'listType': 1},
    {'name': '刑相(90°)', 'value': '90', 'listType': 1},
    {'name': '六合相(60°)', 'value': '60', 'listType': 1},
    {'name': '十二分相(30°)', 'value': '30', 'listType': 2},
    {'name': '十分相(36°)', 'value': '36', 'listType': 2},
    {'name': '八分相(45°)', 'value': '45', 'listType': 2},
    {'name': '五分相(72°)', 'value': '72', 'listType': 2},
    {'name': '补八分相(135°)', 'value': '135', 'listType': 2},
    {'name': '补五分相(144°)', 'value': '144', 'listType': 2},
    {'name': '梅花相(150°)', 'value': '150', 'listType': 2},
  ];

  /// 相位选中值集合（默认全选）
  final phaseSelectedValues = <String>{
    '0',
    '180',
    '120',
    '90',
    '60',
    '30',
    '36',
    '45',
    '72',
    '135',
    '144',
    '150',
  }.obs;

  /// 相位容许度值，key=角度 value=容许度
  final phaseValues = <String, String>{
    '0': '0.5',
    '180': '6',
    '120': '6',
    '90': '6',
    '60': '6',
    '30': '2',
    '36': '2',
    '45': '2',
    '72': '2',
    '135': '0.5',
    '144': '2',
    '150': '2',
  }.obs;

  /// 是否展开显示全部相位
  final phaseShowAll = false.obs;

  /// 当前显示的相位列表（未展开时仅前5个）
  List<Map<String, dynamic>> get phaseDisplayList {
    return phaseShowAll.value ? List.from(phaseList) : phaseList.sublist(0, 5);
  }

  /// 切换展开/收起全部相位
  void togglePhaseShowAll() => phaseShowAll.toggle();

  /// 切换相位选中状态
  void togglePhase(String value, bool selected) {
    if (selected) {
      phaseSelectedValues.add(value);
    } else {
      phaseSelectedValues.remove(value);
    }
    _saveToCache();
  }

  /// 更新相位容许度值
  void updatePhaseValue(String key, String value) {
    phaseValues[key] = value;
    _saveToCache();
  }

  /// 保存所有星盘设置到本地缓存
  void _saveToCache() {
    SpUtil.setStorage(_cacheKey, {
      'planetSelectedValues': planetSelectedValues.toList(),       // 行星选中值集合，如 ['0','1']
      'pointSelectedValues': pointSelectedValues.toList(),        // 虚点选中值集合，如 ['10','11']
      'asteroidSelectedValues': asteroidSelectedValues.toList(),  // 小行星选中值集合，如 ['D','F']
      'selectedStarMode': selectedStarMode.value,                 // 恒星模式值，如 '0'=Fagan/Bradley
      'selectedHouse': selectedHouse.value,                       // 宫位系统值，如 'K'=Koch
      'phaseSelectedValues': phaseSelectedValues.toList(),        // 相位选中值集合，如 ['0','180']
      'phaseValues': phaseValues,                                 // 相位容许度映射，如 {'0':'0.5','180':'6'}
    });
  }

  /// 设置恒星模式并自动保存
  void setSelectedStarMode(String value) {
    selectedStarMode.value = value;
    _saveToCache();
  }

  /// 设置宫位系统并自动保存
  void setSelectedHouse(String value) {
    selectedHouse.value = value;
    _saveToCache();
  }

  /// 重置所有数据到默认值
  void resetToDefault() {
    planetSelectedValues.value = {'0', '1'};
    planetShowAll.value = false;
    pointSelectedValues.value = <String>{};
    pointShowAll.value = false;
    asteroidSelectedValues.value = <String>{};
    asteroidShowAll.value = false;
    selectedStarMode.value = '-1';
    selectedHouse.value = 'K';
    phaseSelectedValues.value = {
      '0',
      '180',
      '120',
      '90',
      '60',
      '30',
      '36',
      '45',
      '72',
      '135',
      '144',
      '150',
    };
    phaseValues.value = {
      '0': '0.5',
      '180': '6',
      '120': '6',
      '90': '6',
      '60': '6',
      '30': '2',
      '36': '2',
      '45': '2',
      '72': '2',
      '135': '0.5',
      '144': '2',
      '150': '2',
    };
    phaseShowAll.value = false;
    _saveToCache();
  }
}
