//import 'dart:html';
import 'package:my_practice/jsonmodel/users.dart';
import 'package:my_practice/jsonmodel/events.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "details.db";
  String eventTable =
      "CREATE TABLE details (eventId INTEGER PRIMARY KEY AUTOINCREMENT, eventName TEXT NOT NULL, eventPlace TEXT NOT NULL,eventDate TEXT NOT NULL,eventTime TEXT NOT NULL, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";
  String users =
      "create table users (userid INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT UNIQUE, password TEXT)";

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(users);
      await db.execute(eventTable);
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
  //Search Method
  Future<List<EventModel>> searchNotes(String keyword) async {
    final Database db = await initDB();
    List<Map<String, Object?>> searchResult = await db
        .rawQuery("select * from details where eventName LIKE ?", ["%$keyword%"]);
    return searchResult.map((e) => EventModel.fromMap(e)).toList();
  }

  //CRUD Methods

  //Create Note
  Future<int> createNote(EventModel note) async {
    final Database db = await initDB();
    return db.insert('details', note.toMap());
  }

  //Get notes
  Future<List<EventModel>> getNotes() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('details');
    return result.map((e) => EventModel.fromMap(e)).toList();
  }

  //Delete Notes
  Future<int> deleteNote(int id) async {
    final Database db = await initDB();
    return db.delete('details', where: 'eventId = ?', whereArgs: [id]);
  }

  //Update Notes
  Future<int> updateNote(name, place, date, time, eventId) async {
    final Database db = await initDB();
    return db.rawUpdate(
        'update details set eventName = ?, eventPlace = ?, eventDate =?, eventTime =? where eventId = ?',
        [name, place, date, time, eventId]);
  }

}

