import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sqlite/person.dart';
import 'package:sqflite/sqflite.dart';

class PersonDatabaseProvider {
  PersonDatabaseProvider._();

  static final PersonDatabaseProvider db = PersonDatabaseProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstance();
    return _database;
  }

  getDatabaseInstance() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "person.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Person ("
          "id integer primary key,"
          "name TEXT,"
          "city TEXT"
          ")");
    });
  }

  addPerson(Person person) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Person");
    int id = table.first["id"];
    person.id=id;
    var raw = await db.insert(
      "Person",
      person.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return raw;
  }

  updatePerson(Person person) async {
    final db = await database;
    var response = await db.update("Person", person.toMap(),
        where: "id = ?", whereArgs: [person.id]);
    return response;
  }

  getPerson(int id) async {
    final db = await database;
    var response = await db.query("Person", where: "id = ?", whereArgs: [id]);
    return response.isNotEmpty ? Person.fromMap(response.first) : null;
  }

  Future<List<Person>> getAllPersons() async {
    final db = await database;
    var response = await db.query("Person");
    List<Person> list = response.map((c) => Person.fromMap(c)).toList();
    return list;
  }

  deletePerson(int id) async {
    final db = await database;
    return db.delete("Person", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.delete("Person");
  }
}
