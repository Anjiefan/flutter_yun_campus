import 'dart:async';
import 'dart:io';
import 'dart:core';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "FineritDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("create table messagedata ("
          "id integer primary key,"
          "relate_user text,"
          "user_id text,"
          "info text,"
          "is_show integer,"
          "is_top integer,"
          "type text,"
          "push_date text,"
          "update_date text,"
          "info_num integer,"
          "show_date text)");
    });
  }

  Future<int> insert(String sql, List parameters) async {
    final db = await database;
    return await db.rawInsert(
        sql,
        parameters
    );
  }

  Future<int> delete(String tableName, int id) async {
    final db = await database;
    return db.delete(tableName, where: "id=?", whereArgs: [id]);
  }

  Future<int> update(String tableName, Map<String, dynamic> content, int id) async {
    final db = await database;
    return await db.update(tableName, content,
        where: "id=?",
        whereArgs: [id]);
  }

  Future<Map<String, dynamic>> getById(String tableName, int id) async {
    final db = await database;
    var res = await db.query(tableName, where: "id=?", whereArgs: [id]);
    return res.isNotEmpty ? res.first : null;
  }

  Future<List<Map<String, dynamic>>> getAll(String sql) async {
    final db = await database;
    var res = await db.rawQuery(sql);
    List<Map<String, dynamic>> list = res.isNotEmpty ? res :[];
    return list;
  }
}
