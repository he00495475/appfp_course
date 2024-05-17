import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper extends ChangeNotifier {
  static Database? _database;
  static const _tableName = 'customer';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    // If _database is null we instantiate it
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), '$_tableName.db'),
      onCreate: (db, version) {
        return db.execute(
          '''CREATE TABLE $_tableName(
            id INTEGER,
            name TEXT,
            type TEXT)''',
        );
      },
      version: 1,
    );
  }

  Future<void> insertData(Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> clearTable() async {
    final db = await database;
    await db.delete(_tableName);
  }

  Future<List<Map<String, dynamic>>> getData() async {
    final db = await database;
    return await db.query(_tableName);
  }
}
