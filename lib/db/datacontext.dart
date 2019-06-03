import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DataContext {
  static Database _database = null;

  Database get database => _database;

  Future<Database> getDatabase() async {
    if(_database != null) {
      return _database;
    }

    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'weather.db');
    _database = await openDatabase(dbPath, version: 1, onCreate: populateDb);

    return _database;
  }

  

  void populateDb(Database database, int version) async {
    await database.execute("CREATE TABLE info ("
            "key VARCHAR(255) PRIMARY KEY,"
            "value TEXT"
            ")");
  }

  void close() async {
    await database.close();
  }
}