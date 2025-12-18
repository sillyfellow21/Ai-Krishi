import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:aikrishi/models/crop_model.dart';
import 'package:aikrishi/providers/land_provider.dart';
import 'package:aikrishi/core/database/database_helper.dart';

class CropProvider with ChangeNotifier {
  final LandProvider landProvider;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();
  List<Crop> _crops = [];

  List<Crop> get crops => _crops;

  CropProvider({required this.landProvider});

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
    _crops.add(newCrop);
    notifyListeners();
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
}
