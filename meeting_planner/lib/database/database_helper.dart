import 'dart:io';

import 'package:meeting_planner/utils/constants.dart';
import 'package:meeting_planner/utils/date_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  final String tableName = 'booking';
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
    String path = directory.path + Constants.databaseName + ".db";
    return await openDatabase(path,
        onCreate: (db, version) => createBookingTable(db), version: 1);
  }

  Future<dynamic> createBookingTable(Database db) async {
    String query = "CREATE TABLE IF NOT EXISTS $tableName"
        "($primaryKey INTEGER PRIMARY KEY AUTOINCREMENT, "
        "title TEXT, "
        "description TEXT,"
        "bookingDate TEXT,"
        "duration INTEGER,"
        "meetingRoomId INTEGER,"
        "priority INTEGER,"
        "reminder INTEGER";
    query += ")";
    return await db.execute(query);
  }

  Future<int> insertData(Map<String, dynamic> data) async {
    Database db = await this.database;
    var result = await db.insert(tableName, data);
    return result;
  }

  Future<int> updateData(int id, Map<String, dynamic> data) async {
    var db = await this.database;
    var result = await db
        .update(tableName, data, where: '$primaryKey = ?', whereArgs: [id]);
    return result;
  }

  Future<int> deleteData(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $tableName WHERE $primaryKey = $id');
    return result;
  }

  Future<List<Map<String, dynamic>>> getBookingData(DateTime dateTime) async {
    Database db = await this.database;
    return await db.query(tableName,
        orderBy: 'priority ASC',
        where: 'bookingDate = ?',
        whereArgs: [
          DateTimeUtils.covertToServerDateTime(
              dateTime, DateTimeUtils.PATTERN_SERVER_DATE_TIME)
        ]);
  }
}
