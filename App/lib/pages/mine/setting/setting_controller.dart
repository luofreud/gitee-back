import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class SettingController extends GetxController {
  final recommend = false.obs;
  final teenMode = false.obs;
  final cacheSize = '0B'.obs;

  @override
  void onInit() {
    super.onInit();
    getCacheSize();
  }

  void getCacheSize() async {
    try {
      cacheSize.value = await _CacheManager.getCacheSize();
    } catch (e) {}
  }

  void clearCache() async {
    try {
      // 获取应用的缓存目录
      await _CacheManager.clearCache();
      cacheSize.value = await _CacheManager.getCacheSize();
    } catch (e) {}
  }
}

class _CacheManager {
  // 获取缓存大小
  static Future<String> getCacheSize() async {
    String _cacheSize = '';
    try {
      final cacheDir = await getTemporaryDirectory();
      if (await cacheDir.exists()) {
        double totalSize = 0;
        // 递归计算目录大小
        final files = await _getAllFiles(cacheDir);
        for (var file in files) {
          totalSize += await file.length();
        }

        if (totalSize < 1024) {
          _cacheSize = '${totalSize}B';
        } else if (totalSize < 1024 * 1024) {
          _cacheSize = '${(totalSize / 1024).toStringAsFixed(1)}KB';
        } else {
          _cacheSize = '${(totalSize / (1024 * 1024)).toStringAsFixed(1)}MB';
        }
      } else {
        _cacheSize = '0B';
      }
    } catch (e) {
      _cacheSize = '获取失败';
    }
    return _cacheSize;
  }

  // 递归获取所有文件
  static Future<List<File>> _getAllFiles(Directory dir) async {
    final files = <File>[];

    try {
      final entities = dir.listSync(recursive: true);
      for (var entity in entities) {
        if (entity is File) {
          files.add(entity);
        }
      }
    } catch (e) {
      print('获取文件列表出错: $e');
    }

    return files;
  }

  // 清除缓存
  static Future<void> clearCache() async {
    try {
      // 获取默认缓存目录
      final cacheDir = await getTemporaryDirectory();
      if (await cacheDir.exists()) {
        // 删除缓存目录中的所有内容
        await cacheDir.delete(recursive: true);
        // 重新创建目录
        await cacheDir.create();
      }

      // 重新计算缓存大小
      await getCacheSize();
    } catch (e) {
    } finally {}
  }
}
