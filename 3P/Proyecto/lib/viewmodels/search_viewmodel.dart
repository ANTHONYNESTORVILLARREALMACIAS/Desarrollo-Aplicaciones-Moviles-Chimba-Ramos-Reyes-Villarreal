import 'package:flutter/foundation.dart';
import '../models/search_result.dart';
import '../models/search_history.dart';
import '../services/api_service.dart';
import '../services/web_storage_service.dart';

class SearchViewModel extends ChangeNotifier {
  List<SearchResult> _results = [];
  List<SearchHistory> _history = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SearchResult> get results => _results;
  List<SearchHistory> get history => _history;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> search(String query, String userId) async {
    if (query.trim().isEmpty) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('🔎 Iniciando búsqueda: $query');
      
      _results = await ApiService.searchDocuments(query, userId);
      
      print('✅ Búsqueda completada: ${_results.length} resultados');
      
      // Guardar en historial usando Web Storage
      await WebStorageService.saveSearchHistory(
        query,
        userId,
        _results.length,
      );
      
      await loadHistory();
      
    } catch (e) {
      print('💥 Error en búsqueda: $e');
      _errorMessage = 'Error al buscar: ${e.toString()}';
      _results = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadHistory() async {
    try {
      _history = await WebStorageService.getSearchHistory();
      notifyListeners();
    } catch (e) {
      print('💥 Error cargando historial: $e');
    }
  }

  void clearResults() {
    _results = [];
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}