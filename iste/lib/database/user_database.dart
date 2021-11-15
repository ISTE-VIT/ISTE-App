import 'package:flutter/material.dart';
import 'package:iste/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();

  static Database? _database;

  UserDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("user.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    final boolType = "BOOLEAN NOT NULL";
    final integerType = "INTEGER NOT NULL";
    final textType = "TEXT";

    await db.execute('''
    CREATE TABLE $tableUser(
      ${UserFields.id} $idType,
      ${UserFields.name} $textType,
      ${UserFields.email} $textType,
      ${UserFields.domain} $textType,
      ${UserFields.type} $textType,
      ${UserFields.picture} $textType
    )
    ''');
  }

  Future<User> create(User user) async {
    final db = await instance.database;
    // final json = note.toJson();
    // final columns = "${NoteFields.title}, ${NoteFields.description}, ${NoteFields.createdTime}";
    // final values = "${json[NoteFields.title]}, ${json[NoteFields.description]}, ${json[NoteFields.createdTime]}";
    // final id = await db.rawInsert("INSERT INTO table_name ($columns) VALUES ($values)");
    final id = await db.insert(tableUser, user.toJson());

    return user.copy(id: id);
  }

  Future<User> readUser(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableUser,
      columns: UserFields.values,
      where: "${UserFields.id} = ?",
      whereArgs: [id], //more secure, prevents sql injection attacks
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      throw Exception("ID $id not found!");
    }
  }

  Future<List<User>> readAllUsers() async {
    final db = await instance.database;
    final result = await db.query(tableUser);

    return result.map((json) => User.fromJson(json)).toList();
  }

  Future<int> update(User user) async {
    final db = await instance.database;

    return db.update(
      tableUser,
      user.toJson(),
      where: "${UserFields.id} = ?",
      whereArgs: [user.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableUser,
      where: "${UserFields.id} = ?",
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
