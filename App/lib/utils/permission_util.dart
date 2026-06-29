import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<bool> requestAllPermission() async {
    var statusLocation = await requestLocationPermission();
    var statusBluetooth = await requestBluetoothPermission();
    var statusCamera = await requestCameraPermission();
    // var statusStorage = await _requestStoragePermission();
    return statusLocation.isGranted &&
        statusBluetooth.isGranted &&
        statusCamera.isGranted;
    // var statusNotification = await _requestNotificationPermission();
    // var statusPhone = await _requestPhonePermission();
  }

  static Future<PermissionStatus> requestLocationPermission() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      status = await Permission.location.request();
    } else {
      status = await Permission.locationWhenInUse.request();
    }

    if (status.isGranted) {
      print("Android: 位置权限已授予");
    } else if (status.isPermanentlyDenied) {
      print("Android: 位置权限被永久拒绝，请前往设置开启");
    } else {
      print("Android: 位置权限被拒绝");
    }
    return status;
  }

  static Future<PermissionStatus> requestBluetoothPermission() async {
    PermissionStatus status;
    if (Platform.isAndroid) {
      status = await Permission.bluetoothScan.request();
      status = await Permission.bluetoothConnect.request();
    } else {
      status = await Permission.bluetooth.request();
    }

    if (status.isGranted) {
      print("Android: 蓝牙权限已授予");
    } else {
      print("Android: 蓝牙权限被拒绝");
    }
    return status;
  }

  static Future<PermissionStatus> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();
    if (status.isGranted) {
      print("Android: 相机权限已授予");
    } else if (status.isPermanentlyDenied) {
      print("Android: 相机权限被永久拒绝，请前往设置开启");
    } else {
      print("Android: 相机权限被拒绝");
    }
    return status;
  }

  /// 检查单个权限状态
  /// [permission] 需要检查的权限类型
  /// 返回权限状态枚举 PermissionStatus
  static Future<PermissionStatus> checkPermission(Permission permission) async {
    try {
      final status = await permission.status;
      return status;
    } catch (e) {
      return PermissionStatus.denied;
    }
  }

  /// 请求单个权限
  /// [permission] 需要请求的权限类型
  /// [rationale] 可选参数，当权限被拒绝时显示的说明文字
  /// 返回布尔值表示是否授予权限
  static Future<bool> requestPermission(
    Permission permission, {
    String? rationale,
  }) async {
    try {
      // 先检查当前权限状态
      var status = await permission.status;

      // 如果权限被永久拒绝，需要跳转设置
      if (status.isPermanentlyDenied) {
        // 可选：显示对话框引导用户去设置
        return false;
      }

      // 如果权限被拒绝或限制访问，发起请求
      if (status.isDenied || status.isRestricted) {
        // iOS 需要先请求[权限状态]
        if (Platform.isIOS) {
          status = await permission.request();
        } else {
          // Android 可以带说明信息
          if (rationale != null) {
            // 使用系统的权限请求对话框显示说明
            await permission.request();
          } else {
            status = await permission.request();
          }
        }
      }

      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// 批量请求多个权限
  /// [permissions] 需要请求的权限列表
  /// 返回权限与结果的映射表
  static Future<Map<Permission, PermissionStatus>> requestMultiplePermissions(
    List<Permission> permissions,
  ) async {
    try {
      final results = await permissions.request();
      return results;
    } catch (e) {
      return {};
    }
  }

  /// 检查权限是否被永久拒绝（需要跳转设置）
  /// [permission] 需要检查的权限类型
  static Future<bool> isPermanentlyDenied(Permission permission) async {
    final status = await permission.status;
    return status.isPermanentlyDenied;
  }

  /// 跳转到应用设置页面
  static Future<bool> openAppSettings() async {
    try {
      final result = await openAppSettings();
      return result;
    } catch (e) {
      return false;
    }
  }

  /// 检查并处理权限（组合方法）
  /// 1. 检查权限状态
  /// 2. 如果未授予则请求权限
  /// 3. 如果被永久拒绝则跳转设置
  /// [permission] 需要处理的权限类型
  /// [rationale] 权限说明文字
  /// 返回布尔值表示最终是否拥有权限
  static Future<bool> checkAndRequestPermission(
    Permission permission, {
    String? rationale,
  }) async {
    // 1. 检查权限状态
    final status = await checkPermission(permission);
    if (status.isGranted) {
      return true;
    }

    // 2. 请求权限
    final result = await requestPermission(permission, rationale: rationale);

    if (result) {
      return true;
    }

    // 3. 检查是否永久拒绝
    final isPermanent = await isPermanentlyDenied(permission);
    if (isPermanent) {
      // 这里可以添加跳转设置的逻辑
      // 例如显示对话框引导用户前往设置
      final openResult = await openAppSettings();
      return openResult; // 注意：这里返回的是设置页面是否成功打开，而不是权限状态
    }

    return false;
  }
}
