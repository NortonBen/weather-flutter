
import 'package:sqflite/sqlite_api.dart';
import 'package:weather/db/info.dart';


class InfoRepository {
  final Database database;
  final String table_name = "info";

  InfoRepository({ this.database });

  Future<List<Info>> all() async  {

    final List<Map<String, dynamic>> maps = await database.query(table_name);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return new Info.fromMap(maps[i]);
    });
    
  }


  Future<Info> selectOne(String key) async  {

    var results = await database.rawQuery('SELECT * FROM $table_name WHERE key = "$key"');

    if (results.length > 0) {
      return new Info.fromMap(results.first);
    }

    return null;
  }

  Future<void> insert(Info info) async  {
    await database.insert(
      table_name,
      info.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(Info info) async  {
    await database.update(
      table_name,
      info.toMap(),
      // Ensure we only update the Dog with a matching id
      where: "key = ?",
      // Pass the Dog's id through as a whereArg to prevent SQL injection
      whereArgs: [info.key],
    );
      
  }

  Future<void> delete(String key) async {

    // Remove the Dog from the Database
    await database.delete(
       table_name,
      // Use a `where` clause to delete a specific dog
      where: "key = ?",
      // Pass the Dog's id through as a whereArg to prevent SQL injection
      whereArgs: [key],
    );
  }
  
}