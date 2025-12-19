import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:aikrishi/models/crop_model.dart';
import 'package:aikrishi/models/crop_log_model.dart'; // Import the new model
import 'package:aikrishi/providers/auth_provider.dart';
import 'package:aikrishi/core/database/database_helper.dart';

class CropProvider with ChangeNotifier {
  final AuthProvider authProvider; // Depend on AuthProvider
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();
  
  List<Crop> _crops = [];
  List<CropLog> _cropLogs = []; // New list for logs

  List<Crop> get crops => _crops;
  List<CropLog> get cropLogs => _cropLogs; // New getter for logs

  CropProvider({required this.authProvider});

  Future<void> fetchCropsByLand(String landId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableCrops,
      where: 'landId = ?',
      whereArgs: [landId],
    );

    _crops = maps.map((map) => Crop.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> fetchAllCropsForUser() async {
    if (authProvider.currentUser == null) return;
    final db = await _dbHelper.database;
    
    // SQL query to get crops by joining through lands table
    final maps = await db.rawQuery('''
      SELECT c.* FROM ${DatabaseHelper.tableCrops} c
      INNER JOIN ${DatabaseHelper.tableLands} l ON c.landId = l.id
      WHERE l.userId = ?
    ''', [authProvider.currentUser!.id]);

    _crops = maps.map((map) => Crop.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addCrop(
      String landId, String cropName, String? variety, DateTime plantingDate) async {
    final db = await _dbHelper.database;
    final cropId = _uuid.v4();
    final newCrop = Crop(
      id: cropId,
      landId: landId,
      cropName: cropName,
      variety: variety,
      plantingDate: plantingDate,
    );

    await db.insert(DatabaseHelper.tableCrops, newCrop.toMap());
    fetchAllCropsForUser(); // Refresh the full list
  }

  Future<void> deleteCrop(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableCrops,
      where: 'id = ?',
      whereArgs: [id],
    );
    _crops.removeWhere((crop) => crop.id == id);
    notifyListeners();
  }
  
  // --- New Crop Log Methods ---

  Future<void> fetchCropLogs(String cropId) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableCropLogs,
      where: 'cropId = ?',
      whereArgs: [cropId],
      orderBy: 'date DESC', // Show newest logs first
    );
    _cropLogs = maps.map((map) => CropLog.fromMap(map)).toList();
    notifyListeners();
  }

  Future<void> addCropLog(String cropId, String activity, String? notes) async {
    final db = await _dbHelper.database;
    final logId = _uuid.v4();
    final newLog = CropLog(
      id: logId,
      cropId: cropId,
      date: DateTime.now(),
      activity: activity,
      notes: notes,
    );
    await db.insert(DatabaseHelper.tableCropLogs, newLog.toMap());
    _cropLogs.insert(0, newLog); // Add to the top of the list
    notifyListeners();
  }
  
  Future<void> updateCrop(Crop crop) async {
    final db = await _dbHelper.database;
    await db.update(
      DatabaseHelper.tableCrops,
      crop.toMap(),
      where: 'id = ?',
      whereArgs: [crop.id],
    );
    // Update the local list as well
    final index = _crops.indexWhere((c) => c.id == crop.id);
    if (index != -1) {
      _crops[index] = crop;
      notifyListeners();
    }
  }
}
