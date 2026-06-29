import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqliteUtil {
  // 单例模式，全局只用一个数据库实例
  SqliteUtil._privateConstructor();

  static final SqliteUtil instance = SqliteUtil._privateConstructor();

  // 数据库对象
  static Database? _database;

  // 你的数据库文件名（和 assets 里一致）
  static const String _dbName = "address.db";

  // 获取数据库对象
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // 初始化：复制 assets 数据库到本地路径
  _initDatabase() async {
    // 1. 获取 App 文档目录（可读写）
    Directory documentsDir = await getApplicationDocumentsDirectory();
    String dbPath = join(documentsDir.path, _dbName);

    // 2. 检查数据库是否已经复制过
    bool dbExists = await File(dbPath).exists();

    if (!dbExists) {
      // 3. 从 assets 复制数据库到本地
      ByteData data = await rootBundle.load(join("assets/other", _dbName));
      List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );
      await File(dbPath).writeAsBytes(bytes);
    }

    // 4. 打开数据库
    return await openDatabase(
      dbPath,
      version: 1,
      // 因为是已有数据库，onCreate 不会执行
    );
  }

  // ====================== 示例：查询数据 ======================
  Future<List<Map<String, dynamic>>> queryAllData(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  // ====================== 示例：条件查询 ======================
  Future<List<Map<String, dynamic>>> queryDataById(
    String tableName,
    int id,
  ) async {
    Database db = await instance.database;
    return await db.query(tableName, where: "id = ?", whereArgs: [id]);
  }

  // ====================== 示例：插入数据 ======================
  Future<int> insertData(String tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tableName, row);
  }

  // ====================== 示例：更新数据 ======================
  Future<int> updateData(String tableName, Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update(tableName, row, where: "id = ?", whereArgs: [id]);
  }

  // ====================== 示例：删除数据 ======================
  Future<int> deleteData(String tableName, int id) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: "id = ?", whereArgs: [id]);
  }
}
