import 'dart:math';

/// 天体类型：行星或小行星
enum CelestialType { planet, asteroid }

/// 行星的 code_name 值集合（与 AstrolabeSettingController 中的行星列表 value 一致）
const _planetValues = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 't'};

/// 小行星的 code_name 值集合（与 AstrolabeSettingController 中的小行星列表 value 一致）
const _asteroidValues = {'D', 'F', 'E', 'G', 'H', 'I', '433', '16'};

/// 根据 code_name 判断天体类型
CelestialType _getCelestialType(String codeName) {
  if (_planetValues.contains(codeName)) return CelestialType.planet;
  if (_asteroidValues.contains(codeName)) return CelestialType.asteroid;
  return CelestialType.planet;
}

/// 相位条目：显示两颗行星间的相位关系
class PhaseEntry {
  final String label;    // "太阳 六分相 月亮"
  final bool isInbound;  // true=入相(接近), false=出相(分离)
  final String orb;      // "0°10'"

  PhaseEntry({
    required this.label,
    required this.isInbound,
    required this.orb,
  });
}

/// 相位角度 → 中文名映射
const _aspectNameMap = {
  0: '合相',
  60: '六分相',
  90: '四分相',
  120: '三分相',
  150: '梅花相',
  180: '对冲',
};

/// parseChartData 统一返回结果
class ChartParsedData {
  final List<PlanetPlacement> placements;
  final List<PhaseEntry> phases;
  final List<GrandPattern> patterns;

  ChartParsedData({
    required this.placements,
    required this.phases,
    required this.patterns,
  });
}

/// 星盘格局：由名称和参与行星列表组成
class GrandPattern {
  final String name;
  final List<String> planets;

  GrandPattern({required this.name, required this.planets});
}

/// 行星落点信息：行星落入的星座、宫位及顺逆行状态
class PlanetPlacement {
  final String planetName; // 行星中文名
  final String signName; // 星座中文名
  final int signDeg; // 星座度数（°）
  final int signMin; // 星座分数（'）
  final int houseId; // 宫位编号
  final int houseDeg; // 宫位度数（°）
  final int houseMin; // 宫位分数（'）
  final bool isRetrograde; // 是否逆行
  final CelestialType type; // 天体类型

  PlanetPlacement({
    required this.planetName,
    required this.signName,
    required this.signDeg,
    required this.signMin,
    required this.houseId,
    required this.houseDeg,
    required this.houseMin,
    required this.isRetrograde,
    required this.type,
  });
}

/// 将动态类型安全转换为 int（支持 int / double / String）
int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

/// 将动态类型安全转换为 double（支持 double / int / String）
double _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

/// 构建相位去重键（code_name 对，小在前）
String _pairKey(String a, String b) => a.compareTo(b) < 0 ? '$a|$b' : '$b|$a';

/// 内部格局计算（从预构建的 aspectO 矩阵出发）
List<GrandPattern> _computeGrandPatterns(
  int n,
  Map<int, Map<int, int>> aspectO,
  Map<int, String> planetNames,
  Map<int, double> longitudes,
) {
  final acS = <List<int>>[];
  final acGT = <List<int>>[];
  final acK = <List<int>>[];
  final acTS = <List<int>>[];
  final acZ = <List<int>>[];
  final acY = <List<int>>[];
  final acGC = <List<int>>[];
  final acC = <List<int>>[];
  final acMR = <List<int>>[];

  int? getAspect(int a, int b) => aspectO[min(a, b)]?[max(a, b)];

  double minDist(double a, double b) {
    var d = (a - b).abs();
    if (d > 180) d = 360 - d;
    return d;
  }

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < n; j++) {
      if (j == i) continue;
      for (int k = 0; k < n; k++) {
        if (k == i || k == j) continue;

        final aij = getAspect(i, j);
        final aik = getAspect(i, k);
        final ajk = getAspect(j, k);
        if (aij == null || aik == null || ajk == null) continue;

        if (i < j && j < k && aij == 0 && aik == 0 && ajk == 0) {
          acS.add([i, j, k]);
        } else if (i < j && j < k && aij == 120 && aik == 120 && ajk == 120) {
          acGT.add([i, j, k]);
          for (int l = 0; l < n; l++) {
            if (l == i || l == j || l == k) continue;
            final ail = getAspect(i, l);
            final ajl = getAspect(j, l);
            final akl = getAspect(k, l);
            if (ail == null || ajl == null || akl == null) continue;
            if (ail == 60 && ajl == 60) {
              acK.add([i, j, k, l]);
            } else if (ajl == 60 && akl == 60) {
              acK.add([i, j, k, l]);
            } else if (ail == 60 && akl == 60) {
              acK.add([i, j, k, l]);
            }
          }
        } else if (j < k && ajk == 180 && aij == 90 && aik == 90) {
          acTS.add([i, j, k]);
        } else if (j < k && ajk == 60 && aij == 60 && aik == 120) {
          acZ.add([i, j, k]);
        } else if (j < k && ajk == 60 && aij == 150 && aik == 150) {
          acY.add([i, j, k]);
        }

        for (int l = 0; l < n; l++) {
          if (l == i || l == j || l == k) continue;

          if (i < j && i < k && i < l && j < l) {
            final gcIj = getAspect(i, j);
            final gcIl = getAspect(i, l);
            final gcJk = getAspect(j, k);
            final gcKl = getAspect(k, l);
            if (gcIj == 90 && gcIl == 90 && gcJk == 90 && gcKl == 90) {
              if (minDist(longitudes[i]!, longitudes[k]!) > 150 &&
                  minDist(longitudes[j]!, longitudes[l]!) > 150) {
                acGC.add([i, j, k, l]);
              }
            }
          }

          if (i < l) {
            final cIj = getAspect(i, j);
            final cJk = getAspect(j, k);
            final cKl = getAspect(k, l);
            if (cIj == 60 && cJk == 60 && cKl == 60) {
              if (minDist(longitudes[i]!, longitudes[l]!) > 150) {
                acC.add([i, j, k, l]);
              }
            }
          }

          if (i < j && i < k && i < l) {
            final mrIj = getAspect(i, j);
            final mrKl = getAspect(k, l);
            final mrIk = getAspect(i, k);
            final mrJl = getAspect(j, l);
            if (mrIj == 180 && mrKl == 180 && mrIk == 120 && mrJl == 120) {
              acMR.add([i, j, k, l]);
            }
          }
        }
      }
    }
  }

  final result = <GrandPattern>[];
  void addPattern(String name, List<List<int>> patternList) {
    if (patternList.isEmpty) return;
    for (final indices in patternList) {
      result.add(GrandPattern(
        name: name,
        planets: indices.map((idx) => planetNames[idx] ?? '').toList(),
      ));
    }
  }

  addPattern('星云', acS);
  addPattern('大三角', acGT);
  addPattern('风筝', acK);
  addPattern('中三角', acZ);
  addPattern('T三角形', acTS);
  addPattern('上帝手指', acY);
  addPattern('大十字', acGC);
  addPattern('摇篮', acC);
  addPattern('信封', acMR);

  return result;
}

/// 一次遍历 planetData，统一提取落点、相位、格局三种数据
///
/// [planetData] — API 响应中的 `planet` 字段（List<Map>）
ChartParsedData parseChartData(dynamic planetData) {
  if (planetData == null || planetData is! List || planetData.isEmpty) {
    return ChartParsedData(placements: [], phases: [], patterns: []);
  }

  final data = planetData;
  final n = data.length;

  final placements = <PlanetPlacement>[];
  final phases = <PhaseEntry>[];
  final seenKeys = <String>{};
  final aspectO = <int, Map<int, int>>{};
  final planetNames = <int, String>{};
  final longitudes = <int, double>{};

  for (int pp = 0; pp < n; pp++) {
    final item = data[pp];
    if (item is! Map) continue;
    final codeName = item['code_name'] as String? ?? '';
    final planetName = item['planet_chinese'] as String? ?? '';
    if (planetName.isEmpty) continue;

    // === PlanetPlacement ===
    final sign = item['sign'];
    final speed = item['speed'] as String? ?? '0';
    placements.add(PlanetPlacement(
      planetName: planetName,
      signName: sign is Map ? sign['sign_chinese'] as String? ?? '' : '',
      signDeg: sign is Map ? _toInt(sign['deg']) : 0,
      signMin: sign is Map ? _toInt(sign['min']) : 0,
      houseId: _toInt(item['house_id']),
      houseDeg: _toInt(item['house_deg']),
      houseMin: _toInt(item['house_min']),
      isRetrograde: (double.tryParse(speed) ?? 0) < 0,
      type: _getCelestialType(codeName),
    ));

    // === Grand pattern data ===
    planetNames[pp] = planetName;
    longitudes[pp] = _toDouble(item['longitude']);
    aspectO[pp] ??= {};

    // === Phase + aspectO ===
    final allowDegree = item['planet_allow_degree'];
    if (allowDegree is! List) continue;

    for (final aa in allowDegree) {
      if (aa is! Map) continue;

      final planetNumber = aa['planet_number'];
      final allow = aa['allow'];
      if (planetNumber is int && allow is int) {
        aspectO[pp]![planetNumber] = allow;
      }

      final bCodeName = aa['code_name'] as String? ?? '';
      final bName = aa['planet_chinese'] as String? ?? '';
      if (bCodeName.isEmpty || bName.isEmpty) continue;

      final key = _pairKey(codeName, bCodeName);
      if (seenKeys.contains(key)) continue;
      seenKeys.add(key);

      final angle = _toInt(aa['allow']);
      final aspectName = _aspectNameMap[angle] ?? '$angle°';
      final inOut = aa['in_out'] as String? ?? '';
      final orb = '${_toInt(aa['deg'])}°${_toInt(aa['min'])}';

      phases.add(PhaseEntry(
        label: bCodeName.compareTo(codeName) < 0
            ? '$bName $aspectName $planetName'
            : '$planetName $aspectName $bName',
        isInbound: inOut == '1',
        orb: orb,
      ));
    }
  }

  final patterns = _computeGrandPatterns(n, aspectO, planetNames, longitudes);
  return ChartParsedData(placements: placements, phases: phases, patterns: patterns);
}


