import 'package:my_practice/jsonmodel/users.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "notes.db";
  String users =
      "create table users (userid INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE, password TEXT)";

  //We are done in this section

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(users);
    });
  }


Future<bool> login(Users user) async {
    final Database db = await initDB();

    // I forgot the password to check
    var result = await db.rawQuery(
        "select * from users where username = '${user.username}' AND password = '${user.password}'");
    if (result.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
  //sign up

  Future<int> signup(Users user) async {
    final Database db = await initDB();

    return db.insert('users', user.toMap());
  }
}