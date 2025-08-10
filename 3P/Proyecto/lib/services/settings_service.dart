import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language_code';

  // ✅ OPTIMIZADO: Singleton con cache
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  // ✅ OPTIMIZADO: Cache de SharedPreferences
  SharedPreferences? _prefs;
  bool _isInitialized = false;

  // ✅ OPTIMIZADO: Init solo una vez
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      _prefs = await SharedPreferences.getInstance();
      _isInitialized = true;
    }
  }

  // ✅ OPTIMIZADO: Lectura rápida con cache
  Future<bool> isDarkMode() async {
    await _ensureInitialized();
    return _prefs?.getBool(_themeKey) ?? true; // true por defecto
  }

  // ✅ OPTIMIZADO: Escritura sin await innecesario
  Future<void> setDarkMode(bool isDark) async {
    await _ensureInitialized();
    _prefs?.setBool(_themeKey, isDark); // Sin await para ser más rápido
  }

  // ✅ OPTIMIZADO: Lectura rápida con cache
  Future<String> getLanguage() async {
    await _ensureInitialized();
    return _prefs?.getString(_languageKey) ?? 'es'; // 'es' por defecto
  }

  // ✅ OPTIMIZADO: Escritura sin await innecesario
  Future<void> setLanguage(String languageCode) async {
    await _ensureInitialized();
    _prefs?.setString(_languageKey, languageCode); // Sin await para ser más rápido
  }

  // ✅ NUEVO: Método para limpiar cache si es necesario
  void clearCache() {
    _isInitialized = false;
    _prefs = null;
  }
}
