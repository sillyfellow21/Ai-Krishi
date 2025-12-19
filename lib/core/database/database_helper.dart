import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "krishibondhu.db";
  static const _databaseVersion = 3; // Incremented version for new features

  static const tableUsers = 'users';
  static const tableLands = 'lands';
  static const tableCrops = 'crops';
  static const tableCropLogs = 'crop_logs'; // New table

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
        version: _databaseVersion,
        onConfigure: _onConfigure,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade);
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    await _createTables(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Add new columns to crops table
      await db.execute('''
        ALTER TABLE $tableCrops ADD COLUMN status TEXT
      ''');
      await db.execute('''
        ALTER TABLE $tableCrops ADD COLUMN harvestDate TEXT
      ''');
      await db.execute('''
        ALTER TABLE $tableCrops ADD COLUMN expectedYield REAL
      ''');
      await db.execute('''
        ALTER TABLE $tableCrops ADD COLUMN actualYield REAL
      ''');
      // Create the new crop_logs table
      await db.execute(_createCropLogsTableSql());
    }
  }

  String _createCropLogsTableSql() {
    return '''
      CREATE TABLE $tableCropLogs (
        id TEXT PRIMARY KEY,
        cropId TEXT NOT NULL,
        date TEXT NOT NULL,
        activity TEXT NOT NULL, 
        notes TEXT,
        FOREIGN KEY (cropId) REFERENCES $tableCrops (id) ON DELETE CASCADE
      )
    ''';
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE $tableUsers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        passwordHash TEXT NOT NULL,
        phone TEXT UNIQUE,
        address TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableLands (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        landName TEXT NOT NULL,
        area REAL NOT NULL,
        location TEXT,
        FOREIGN KEY (userId) REFERENCES $tableUsers (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableCrops (
        id TEXT PRIMARY KEY,
        landId TEXT NOT NULL,
        cropName TEXT NOT NULL,
        variety TEXT,
        plantingDate TEXT NOT NULL,
        status TEXT, -- Planting, Growing, Harvested
        harvestDate TEXT,
        expectedYield REAL,
        actualYield REAL,
        FOREIGN KEY (landId) REFERENCES $tableLands (id) ON DELETE CASCADE
      )
    ''');
    
    await db.execute(_createCropLogsTableSql());
  }
}
