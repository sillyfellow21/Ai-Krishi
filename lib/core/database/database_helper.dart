import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "krishibondhu.db";
  static const _databaseVersion = 1;

  // Table names
  static const tableUsers = 'users';
  static const tableLands = 'lands';
  static const tableCrops = 'crops';

  // Singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tableUsers (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT NOT NULL UNIQUE,
            passwordHash TEXT NOT NULL,
            phone TEXT,
            address TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableLands (
            id TEXT PRIMARY KEY,
            userId TEXT NOT NULL,
            landName TEXT NOT NULL,
            area REAL NOT NULL,
            location TEXT
          )
          ''');

    await db.execute('''
          CREATE TABLE $tableCrops (
            id TEXT PRIMARY KEY,
            landId TEXT NOT NULL,
            cropName TEXT NOT NULL,
            variety TEXT,
            plantingDate TEXT NOT NULL
          )
          ''');
  }
}
