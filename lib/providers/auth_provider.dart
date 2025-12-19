import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:aikrishi/core/database/database_helper.dart';
import 'package:aikrishi/core/utils/password_helper.dart';
import 'package:aikrishi/models/user_model.dart';

class AuthProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  User? _currentUser;
  bool _isLoggedIn = false;
  final Uuid _uuid = const Uuid();

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _loadUserFromSession();
  }

  Future<void> _loadUserFromSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      final db = await _dbHelper.database;
      final maps = await db.query(
        DatabaseHelper.tableUsers,
        where: 'id = ?',
        whereArgs: [userId],
      );
      if (maps.isNotEmpty) {
        _currentUser = User.fromMap(maps.first);
        _isLoggedIn = true;
        notifyListeners();
      }
    }
  }

  Future<bool> login(String identifier, String password) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      DatabaseHelper.tableUsers,
      where: 'email = ? OR phone = ?',
      whereArgs: [identifier, identifier],
    );

    if (maps.isNotEmpty) {
      final userMap = maps.first;
      final hashedPassword = userMap['passwordHash'] as String;
      if (PasswordHelper.verifyPassword(password, hashedPassword)) {
        _currentUser = User.fromMap(userMap);
        _isLoggedIn = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', _currentUser!.id);
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<bool> register(String name, String email, String? phone, String password) async {
    final db = await _dbHelper.database;
    try {
      final userId = _uuid.v4();
      await db.insert(
        DatabaseHelper.tableUsers,
        {
          'id': userId,
          'name': name,
          'email': email,
          'phone': phone,
          'passwordHash': PasswordHelper.hashPassword(password),
        },
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      // Upon successful registration, just return true. Do not log the user in.
      return true;
    } catch (e) {
      // Likely a UNIQUE constraint violation on email or phone
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    notifyListeners();
  }
}
