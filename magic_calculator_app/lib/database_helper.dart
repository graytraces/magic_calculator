import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'key_value_map.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {

    String path = join(await getDatabasesPath(), 'key_value_map.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE key_value_map(key TEXT PRIMARY KEY, value TEXT)");
  }

  Future<KeyValueMap> selectKeyValueMap(String key) async{
    Database db = await instance.database;
    var result = await db.query('key_value_map',where: 'key = \'$key\'' );
    return result.isNotEmpty ?  KeyValueMap.fromMap(result.first) : KeyValueMap();  // 1개만 나오는게 정상
  }

  Future<int> insertKeyValueMap(String paramKey, String paramValue) async {
    KeyValueMap keyValueMap = new KeyValueMap(key: paramKey, value: paramValue);
    Database db = await instance.database;
    return await db.insert('key_value_map', keyValueMap.toMap());
  }

  Future<int> updateKeyValueMap(String paramKey, String paramValue) async {
    KeyValueMap keyValueMap = new KeyValueMap(key: paramKey, value: paramValue);
    Database db = await instance.database;
    return await db.update('key_value_map', keyValueMap.toMap());
  }


  Future<int> deleteKeyValueMap() async {
    Database db = await instance.database;
    return await db.delete('key_value_map');
  }
}
