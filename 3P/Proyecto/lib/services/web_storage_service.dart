import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user.dart';
import '../models/search_history.dart';

class WebStorageService {
  static const String _userKey = 'current_user';
  static const String _historyKey = 'search_history';

  // Métodos para Usuario
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  static Future<User?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      final userJson = jsonDecode(userString);
      return User.fromJson(userJson);
    }
    return null;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  // Métodos para Historial
  static Future<void> saveSearchHistory(String query, String userId, int resultsCount) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Obtener historial existente
    final historyList = await getSearchHistory();
    
    // Agregar nueva búsqueda
    final newHistory = SearchHistory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      query: query,
      userId: userId,
      timestamp: DateTime.now(),
      resultsCount: resultsCount,
    );
    
    historyList.insert(0, newHistory); // Agregar al inicio
    
    // Mantener solo los últimos 50 elementos
    if (historyList.length > 50) {
      historyList.removeRange(50, historyList.length);
    }
    
    // Guardar lista actualizada
    final historyJsonList = historyList.map((h) => h.toJson()).toList();
    await prefs.setString(_historyKey, jsonEncode(historyJsonList));
  }

  static Future<List<SearchHistory>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyString = prefs.getString(_historyKey);
    
    if (historyString != null) {
      final List<dynamic> historyJsonList = jsonDecode(historyString);
      return historyJsonList.map((json) => SearchHistory.fromJson(json)).toList();
    }
    
    return [];
  }

  static Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
