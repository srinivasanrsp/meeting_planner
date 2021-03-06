import 'dart:io';

import 'package:meeting_planner/utils/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String primaryKey = 'id';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + AppStrings.DB_NAME + ".db";
    return await openDatabase(path, version: 1);
  }

  Future<void> createTable(String tableName, Map<String, dynamic> data) async {
    String query =
        "CREATE TABLE IF NOT EXISTS $tableName($primaryKey INTEGER PRIMARY KEY AUTOINCREMENT";
    for (var entry in data.entries) {
      if (entry.value != null) {
        if (entry.value is int) {
          query += ", ${entry.key} INTEGER";
        } else if (entry.value is String) {
          query += ", ${entry.key} TEXT";
        }
      }
    }
    query += ")";
    Database db = await this.database;
    await db.execute(query);
  }

  Future<int> insertData(String tableName, Map<String, dynamic> data) async {
    Database db = await this.database;
    var result = await db.insert(tableName, data);
    return result;
  }

  Future<int> updateData(
      String tableName, Map<String, dynamic> data, int id) async {
    var db = await this.database;
    var result = await db
        .update(tableName, data, where: '$primaryKey = ?', whereArgs: [id]);
    return result;
  }

  Future<int> deleteData(String tableName, int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $tableName WHERE $primaryKey = $id');
    return result;
  }

  Future<List<Map<String, dynamic>>> get(
      {String tableName, String query}) async {
    Database db = await this.database;
    var result = await db.query(tableName, orderBy: ' ASC', where: "");
    return result;
  }
}
