import 'package:flutter/material.dart';
import 'package:aikrishi/models/user_model.dart';
import 'package:aikrishi/providers/auth_provider.dart';
import 'package:aikrishi/core/database/database_helper.dart';

class UserProfileProvider with ChangeNotifier {
  final AuthProvider authProvider;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  User? _userProfile;

  User? get userProfile => _userProfile;

  UserProfileProvider({required this.authProvider}) {
    if (authProvider.isLoggedIn) {
      loadUserProfile();
    }
  }

  Future<void> loadUserProfile() async {
    if (authProvider.currentUser == null) return;

    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableUsers,
      where: 'id = ?',
      whereArgs: [authProvider.currentUser!.id],
    );

    if (maps.isNotEmpty) {
      _userProfile = User.fromMap(maps.first);
      notifyListeners();
    }
  }

  Future<bool> updateProfile(String name, String? phone, String? address) async {
    if (authProvider.currentUser == null) return false;

    final db = await _dbHelper.database;
    final updatedUser = User(
      id: authProvider.currentUser!.id,
      email: authProvider.currentUser!.email,
      name: name,
      phone: phone,
      address: address,
    );

    int count = await db.update(
      DatabaseHelper.tableUsers,
      {
        'name': name,
        'phone': phone,
        'address': address,
      },
      where: 'id = ?',
      whereArgs: [authProvider.currentUser!.id],
    );

    if (count > 0) {
      _userProfile = updatedUser;
      // Also update the user in AuthProvider to ensure consistency
      authProvider.currentUser?.name = name;
      notifyListeners();
      return true;
    }
    return false;
  }
}
