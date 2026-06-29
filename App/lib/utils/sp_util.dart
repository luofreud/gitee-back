import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'common_util.dart';

class SpUtil {
  static SharedPreferences? _storage;

  SpUtil._();

  static Future<SharedPreferences> getInstance() async {
    _storage ??= await SharedPreferences.getInstance();
    return _storage!;
  }

  /// 设置 bool 缓存
  static Future<bool> setBool(String key, bool value) async {
    await getInstance();
    return _storage!.setBool(key, value);
  }

  /// 读取 bool 缓存（返回 null 表示 key 不存在）
  static Future<bool?> getBool(String key) async {
    await getInstance();
    return _storage!.getBool(key);
  }

  ///设置缓存
  static Future setStorage(
    String key,
    dynamic value, {
    bool encrypt = false,
  }) async {
    await getInstance();
    String type;
    if (value is Map || value is List) {
      type = "String";
      value = jsonEncode(value);
    } else {
      type = value.runtimeType.toString();
    }

    if (encrypt) {
      value = CommonUtil.encryptAES(value);
    }

    switch (type) {
      case "String":
        _storage?.setString(key, value);
        break;
      case "int":
        _storage?.setInt(key, value);
        break;
      case "double":
        _storage?.setDouble(key, value);
        break;
      case "bool":
        _storage?.setBool(key, value);
        break;
      default:
    }
  }

  ///读取缓存
  static Future<dynamic> getStorage(String key, {bool encrypt = false}) async {
    await getInstance();
    dynamic value = _storage?.get(key);
    if (encrypt && value != null) {
      value = CommonUtil.decryptAES(value);
    }
    if (_isJson(value)) {
      return jsonDecode(value);
    } else {
      return value;
    }
  }

  ///判断某个key是否存在
  static Future<bool> containsKey(String key) async {
    await getInstance();
    return _storage!.containsKey(key);
  }

  ///移除缓存
  static Future<bool> removeStorage(String key) async {
    await getInstance();
    if (await containsKey(key)) {
      return _storage!.remove(key);
    }
    return false;
  }

  ///清空缓存
  static Future<bool> clear() async {
    await getInstance();
    return _storage!.clear();
  }

  ///获取素有key
  static Future<Set<String>> getKeys() async {
    await getInstance();
    return _storage!.getKeys();
  }

  ///判断字符串是否是json
  static _isJson(dynamic value) {
    try {
      jsonDecode(value);
      return true;
    } catch (e) {
      return false;
    }
  }
}
