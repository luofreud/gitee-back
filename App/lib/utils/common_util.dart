import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class CommonUtil {
  ///格式化日期时间
  ///dateStr 时间格式的字符串
  ///format 格式化表达式 yyyy-MM-dd hh:mm:ss
  static String formatDate(
    dynamic datetime, {
    String format = "yyyy-MM-dd hh:mm:ss",
  }) {
    if (datetime == null) return "";
    DateTime? dt = DateTime.now();
    if (datetime.runtimeType.toString() == 'DateTime') {
      dt = datetime;
    } else {
      String datetimeStr = datetime
          .replaceAll("T", " ")
          .replaceAll("/", "-")
          .toString();
      datetimeStr = datetimeStr
          .split('-')
          .map((e) {
            List<String> dayTimeList = e.split(' ');
            if (dayTimeList.length > 1) {
              return (dayTimeList[0].length < 2
                      ? dayTimeList[0].padLeft(2, '0')
                      : dayTimeList[0]) +
                  ' ' +
                  dayTimeList[1];
            }
            return e.length < 2 ? e.padLeft(2, '0') : e;
          })
          .toList()
          .join('-');
      datetimeStr = datetimeStr
          .split(':')
          .map((e) {
            return e.length < 2 ? e.padLeft(2, '0') : e;
          })
          .toList()
          .join(':');
      if (datetime.contains("0001-01-01")) {
        return "";
      }
      dt = DateTime.tryParse(datetimeStr);
    }

    if (dt != null) {
      Map<String, int> dtMap = {
        'yyyy': dt.year,
        'yy': dt.year - 2000,
        'MM': dt.month,
        'dd': dt.day,
        'hh': dt.hour,
        'mm': dt.minute,
        'ss': dt.second,
      };
      return format.replaceAllMapped(
        RegExp(r'yyyy|yy|MM|dd|hh|mm|ss', caseSensitive: true),
        (match) {
          String key = match[0].toString();
          return dtMap[key].toString().padLeft(key.length, "0");
        },
      );
    }
    return datetime;
  }

  ///格式化日期时间字符串,显示为今天、昨天、其他日期
  static String formatDateStr(dynamic datetime) {
    String timeStr = formatDate(datetime, format: "yyyy-MM-dd hh:mm:ss");
    DateTime dt = DateTime.parse(timeStr);
    String timeStr2 =
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";

    var dtDifference = DateTime.now().difference(dt);
    if (dtDifference.inDays == 0) {
      return "今天 $timeStr2";
    } else if (dtDifference.inDays == 1) {
      return "昨天  $timeStr2";
    } else if (dt.year == DateTime.now().year) {
      return timeStr.replaceAll("${dt.year}-", "");
    } else if (dt.year != DateTime.now().year) {
      return timeStr;
    }
    return timeStr;
  }

  static const String _aesKey = "EC4FZ6TUW0F9KC7B";

  ///iv长度必须为16位
  static const String _aesIv = "EC4FZ6TUW0F9KC7B";

  ///加密aes
  static String encryptAES(String content) {
    // final plainText = content;
    // final key = encrypt.Key.fromUtf8(_aesKey);
    // final iv = encrypt.IV.fromUtf8(_aesIv);
    // final encrypter = encrypt.Encrypter(
    //   encrypt.AES(key, mode: encrypt.AESMode.cbc),
    // );
    // final encrypted = encrypter.encrypt(plainText, iv: iv);
    // final encryptStr = encrypted.base64;

    return content;
  }

  ///解密aes
  static String decryptAES(String content) {
    // final key = encrypt.Key.fromUtf8(_aesKey);
    // final iv = encrypt.IV.fromUtf8(_aesIv);
    // final encrypter = encrypt.Encrypter(
    //   encrypt.AES(key, mode: encrypt.AESMode.cbc),
    // );
    // final decrypted = encrypter.decrypt64(content, iv: iv);
    return content;
  }

  ///解密JWT
  static Map<String, dynamic> decryptJWT(String content) {
    content = content.replaceAll('_', '/').replaceAll('-', '+');
    return jsonDecode(base64UrlDecode(content.split('.')[1]));
  }

  ///将base64转换为字符串
  static String base64UrlDecode(String base64) {
    String padding = '=' * (4 - (base64.length % 4));
    String paddedBase64 = base64.length % 4 == 0
        ? base64
        : base64.replaceAll('=', '') + padding;
    return utf8.decode(base64Decode(paddedBase64));
  }

  /// 关闭键盘并保留焦点
  static Future<void> hideKeyShowfocus() async {
    await SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// 关闭键盘并失去焦点
  static Future<void> hideKeyShowUnfocus() async {
    ///可以使用这个方法将焦点移到一个新的不存在的节点上
    ///FocusScope.of(context).requestFocus(FocusNode());
    ///也可以用这个方法关闭键盘并失去当前组件焦点
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /// 将16进制颜色转换为color
  static Color hexToColor(String code) {
    String hex = code.replaceAll('#', '');

    // 处理短格式（如 #f00 → ff0000，或 #a1b → aa11bb）
    if (hex.length == 3 || hex.length == 4) {
      hex = hex.split('').map((c) => c * 2).join();
    }

    // 补全透明度（默认不透明）
    if (hex.length == 6) hex = 'FF$hex'; // 关键修正：用字符串拼接代替insert
    if (hex.length != 8) throw const FormatException('Invalid color code');

    return Color(int.parse(hex, radix: 16));
  }

  ///将颜色变浅
  static Color lightenColor(Color color, double factor) {
    assert(factor >= 0 && factor <= 1, "Factor 必须在 0 到 1 之间");
    // 转换为 HSL 颜色空间
    HSLColor hsl = HSLColor.fromColor(color);
    // 增加亮度（Lightness），确保不超过 1.0
    hsl = hsl.withLightness((hsl.lightness + factor).clamp(0.0, 1.0));
    // 转回 Color 并保留原始透明度
    return hsl.toColor();
  }

  /// 随机深色颜色
  ///
  /// isDark 是否深色，默认深色，否则将随机生成颜色
  static Color randomColor({bool isDark = true}) {
    if (isDark == false) {
      return Color.fromARGB(
        255,
        Random().nextInt(256),
        Random().nextInt(256),
        Random().nextInt(256),
      );
    }
    // 随机生成HSV颜色
    final hsvColor = HSVColor.fromAHSV(
      1.0,
      Random().nextDouble() * 360, // 随机生成主色相值 (0-360)
      0.5 + Random().nextDouble() * 0.2, // 饱和度 (50-90%)
      0.2 + Random().nextDouble() * 0.2, // 明度 (20-40%)
    );

    // 转换为Color对象
    return hsvColor.toColor();
  }

  // static WebViewController? _webViewController;
  //
  // ///运行js并返回结果
  // static Future<Object> runJavaScriptReturningResult(String jsStr) async {
  //   _webViewController ??=
  //       WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
  //   return _webViewController!.runJavaScriptReturningResult(jsStr);
  // }

  /// 选择本地图片
  static Future<List<AssetEntity>?> selectImage(
    context, {
    int? maxCount,
    RequestType? requestType,
  }) async {
    return AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        // pickerTheme: ThemeUtil.lightThemeData(),
        requestType: requestType ?? RequestType.all,
        // specialPickerType: SpecialPickerType.wechatMoment,
        // pickerTheme: PickerTheme.light,
        pathNameBuilder: (AssetPathEntity path) => switch (path) {
          final p when p.isAll => '所有照片',
          final p when p.name == 'Camera' => '相机',
          final p when p.name == 'Screenshots' => '截屏',
          final p when p.name == 'Download' => '下载',
          _ => path.name,
        },
        maxAssets: maxCount ?? defaultMaxAssetsCount,
      ),
    );
  }

  /// 调用相机拍照
  static Future<AssetEntity?> takePhoto(context) async {
    return CameraPicker.pickFromCamera(context);
  }

  /// 获取星座名称
  static String getConstellationName(DateTime date) {
    int month = date.month;
    int day = date.day;

    // 定义每个月份对应的星座分界日
    // 索引 0 代表 1 月，索引 11 代表 12 月
    // 数值代表该月几号开始变换星座（例如 1 月 20 日之后是水瓶座）
    // 注意：这里定义的是“分界线”，分界线之前是上一个星座，之后是当前星座
    const List<int> dates = [20, 19, 21, 20, 21, 22, 23, 23, 23, 24, 22, 22];

    // 星座名称列表（顺序对应：摩羯, 水瓶, 双鱼... 射手）
    // 这里的顺序是为了配合下面的逻辑：如果是 1 月且小于 20 号，它是摩羯座（列表最后一个）
    const List<String> constellations = [
      '水瓶座',
      '双鱼座',
      '白羊座',
      '金牛座',
      '双子座',
      '巨蟹座',
      '狮子座',
      '处女座',
      '天秤座',
      '天蝎座',
      '射手座',
      '摩羯座',
    ];

    // 逻辑说明：
    // 如果当前日期 < 当月的分界日，说明还没换座，属于“上一个星座”
    // 如果当前日期 >= 当月的分界日，说明已经换座，属于“当前索引对应的星座”

    if (day < dates[month - 1]) {
      // 还没到当月的分界日，属于上一个星座
      // 如果是 1 月 (month-1 = 0)，上一个星座就是列表最后一个 (摩羯座)
      return constellations[month - 2 < 0 ? 11 : month - 2];
    } else {
      // 已经过了分界日，属于当月对应的星座
      return constellations[month - 1];
    }
  }
}
