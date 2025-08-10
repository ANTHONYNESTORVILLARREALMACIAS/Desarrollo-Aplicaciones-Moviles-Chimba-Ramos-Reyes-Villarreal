import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/search_history.dart';
import '../models/user.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'app_database.db');
    return await openDatabase(path, version: 3, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE search_history (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          query TEXT,
          user_id TEXT,
          timestamp TEXT,
          results_count INTEGER
        )
      ''');
      await db.execute('''
        CREATE TABLE users (
          id TEXT PRIMARY KEY,
          username TEXT,
          email TEXT,
          avatar TEXT,
          created_at TEXT
        )
      ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            username TEXT,
            email TEXT,
            avatar TEXT,
            created_at TEXT
          )
        ''');
      }
      if (oldVersion < 3) {
        // Recrear la tabla search_history con las columnas correctas
        await db.execute('DROP TABLE IF EXISTS search_history');
        await db.execute('''
          CREATE TABLE search_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            query TEXT,
            user_id TEXT,
            timestamp TEXT,
            results_count INTEGER
          )
        ''');
      }
    });
  }

  Future<void> insertSearchHistory(SearchHistory history) async {
    final db = await database;
    await db.insert('search_history', {
      'query': history.query,
      'user_id': history.userId,
      'timestamp': history.timestamp.toIso8601String(),
      'results_count': history.resultsCount,
    });
  }

  Future<List<SearchHistory>> getSearchHistory() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('search_history', orderBy: 'timestamp DESC');
    return maps.map((map) => SearchHistory(
      id: map['id']?.toString() ?? '',
      query: map['query'] ?? '',
      userId: map['user_id'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
      resultsCount: map['results_count'] ?? 0,
    )).toList();
  }

  // Métodos para Usuario
  Future<void> saveUser(User user) async {
    final db = await database;
    await db.insert('users', user.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getSavedUser() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users', limit: 1);
    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<void> clearUser() async {
    final db = await database;
    await db.delete('users');
  }

  // Metodo para guardar la busqueda con el query, user_id, timestamp y results_count
  Future<void> saveSearchHistory(String query, String userId, int resultsCount) async {
    final db = await database;
    await db.insert('search_history', {
      'query': query,
      'user_id': userId,
      'timestamp': DateTime.now().toIso8601String(),
      'results_count': resultsCount,
    });
  }
}
