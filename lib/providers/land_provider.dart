import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:aikrishi/models/land_model.dart';
import 'package:aikrishi/providers/auth_provider.dart';
import 'package:aikrishi/core/database/database_helper.dart';

class LandProvider with ChangeNotifier {
  final AuthProvider authProvider;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final Uuid _uuid = const Uuid();
  List<Land> _lands = [];

  List<Land> get lands => _lands;

  LandProvider({required this.authProvider}) {
    if (authProvider.isLoggedIn) {
      fetchLands();
    }
  }

  Future<void> fetchLands() async {
    if (authProvider.currentUser == null) return;

    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableLands,
      where: 'userId = ?',
      whereArgs: [authProvider.currentUser!.id],
    );

    _lands = maps.map((map) => Land.fromMap(map)).toList();
    notifyListeners();
  }

  Future<bool> addLand(String landName, double area, String? location) async {
    if (authProvider.currentUser == null) return false;

    final db = await _dbHelper.database;
    final landId = _uuid.v4();
    final newLand = Land(
      id: landId,
      userId: authProvider.currentUser!.id,
      landName: landName,
      area: area,
      location: location,
    );

    await db.insert(DatabaseHelper.tableLands, newLand.toMap());
    _lands.add(newLand);
    notifyListeners();
    return true;
  }

  Future<bool> updateLand(String id, String landName, double area, String? location) async {
     if (authProvider.currentUser == null) return false;

    final db = await _dbHelper.database;
    final updatedLand = Land(
      id: id,
      userId: authProvider.currentUser!.id,
      landName: landName,
      area: area,
      location: location,
    );

    int count = await db.update(
      DatabaseHelper.tableLands,
      updatedLand.toMap(),
      where: 'id = ? AND userId = ?',
      whereArgs: [id, authProvider.currentUser!.id],
    );

    if (count > 0) {
      final index = _lands.indexWhere((land) => land.id == id);
      if (index != -1) {
        _lands[index] = updatedLand;
        notifyListeners();
      }
      return true;
    }
    return false;
  }

  Future<void> deleteLand(String id) async {
    if (authProvider.currentUser == null) return;

    final db = await _dbHelper.database;
    await db.delete(
      DatabaseHelper.tableLands,
      where: 'id = ? AND userId = ?',
      whereArgs: [id, authProvider.currentUser!.id],
    );
    _lands.removeWhere((land) => land.id == id);
    notifyListeners();
  }
}
