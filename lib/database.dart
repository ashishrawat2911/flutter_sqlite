import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sqlite/person.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider dbProvider = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "person.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Person ("
          "id integer primary key,"
          "name TEXT,"
          "city TEXT"
          ")");
    });
  }

  newPerson(Person person) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Person");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT INTO Person (id,name,city)"
        " VALUES (?,?,?)",
        [id, person.name, person.city]);
    return raw;
  }
  updatePerson(Person person) async {
    final db = await database;
    var res = await db.update("Person", person.toMap(),
        where: "id = ?", whereArgs: [person.id]);
    return res;
  }
  getPerson(int id) async {
    final db = await database;
    var res = await db.query("Person", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Person.fromMap(res.first) : null;
  }

  Future<List<Person>> getAllPersons() async {
    final db = await database;
    var res = await db.query("Person");
    List<Person> list =
    res.isNotEmpty ? res.map((c) => Person.fromMap(c)).toList() : [];
    return list;
  }
  deletePerson(int id) async {
    final db = await database;
    return db.delete("Person", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("DELETE FROM Person");
  }
}
