import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DBHelper {
  // 1- Create DB
  // 2- Create Table
  // 3- Open DB
  // 4- Insert to DB
  // 5- Update
  // 6- Remove
  static Database? db;
  static String tableName = 'Tasks';
  static int version = 1;

  static Future<void> initDB() async {
    try {
      // Initilaize DB path and Name
      String path = await getDatabasesPath() + 'TODO.db';
      print('DB Path');
      db = await openDatabase(
        path,
        version: version,
        onCreate: (Database db, int version) async {
          // Create DB & Tabels by SQL
          await db.execute(
            'CREATE TABLE $tableName ('
            'id INTEGER PRIMARY KEY,'
            'title TEXT,'
            'note TEXT,'
            'isCompleted INTEGER,'
            'date TEXT,'
            'startTime TEXT,'
            'endTime TEXT,'
            'color INTEGER,'
            'remind INTEGER,'
            'repeat TEXT)',
          );
          print('Creating DB Successfully');
        },
      );
    } catch (erorr) {
      print(erorr);
    }
  }

  static Future<int> insert(Task task) async {
    print('Insert Called');
    return await db!.insert(tableName, task.toJson());
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('Query Called');
    return await db!.query(tableName);
  }

  static Future<int> delete(Task task) async {
    print('Delete Called');
    return await db!.delete(tableName, where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<int> deleteAll() async {
    print('Delete All Called');
    return await db!.delete(tableName);
  }

  static Future<int> updateCompelete(int id) async {
    print('Update Called');
    return await db!.rawUpdate(
        ''' UPDATE $tableName 
      SET isCompleted = ?
      WHERE id = ?
    ''',
        [1, id]);
  }
  static Future<int> updatetodo(int id) async {
    print('Update Called');
    return await db!.rawUpdate(
        ''' UPDATE $tableName 
      SET isCompleted = ?
      WHERE id = ?
    ''',
        [0, id]);
  }
}
