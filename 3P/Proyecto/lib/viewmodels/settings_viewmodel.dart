import 'package:flutter/material.dart';
import '../services/settings_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();
  
  // ✅ Valores por defecto inmediatos (sin await)
  bool _isDarkMode = true; // Modo oscuro por defecto
  String _languageCode = 'es'; // Español por defecto
  bool _isInitialized = false;
  
  bool get isDarkMode => _isDarkMode;
  String get languageCode => _languageCode;
  bool get isInitialized => _isInitialized;

  ThemeData get currentTheme {
    if (_isDarkMode) {
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.deepPurple,
        ).copyWith(
          surface: const Color(0xFF1A1A1A),
          primary: Colors.deepPurple,
          secondary: Colors.tealAccent,
        ),
        cardColor: const Color(0xFF2D2D2D),
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
      );
    } else {
      return ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.deepPurple,
        ).copyWith(
          surface: Colors.white,
          primary: Colors.deepPurple,
          secondary: Colors.tealAccent,
        ),
        cardColor: Colors.grey[100],
        scaffoldBackgroundColor: Colors.white,
      );
    }
  }

  // Textos localizados
  final Map<String, Map<String, String>> _texts = {
    'es': {
      'appTitle': 'Villaneta IA',
      'hello': '¡Hola! ¿En qué puedo ayudarte?',
      'subtitle': 'Pregunta sobre normativas, regulaciones o documentos legales',
      'publicContracts': 'Contratos públicos',
      'dataProtection': 'Protección de datos',
      'environmentalNorms': 'Normas ambientales',
      'humanResources': 'Recursos humanos',
      'typeQuery': 'Escribe tu consulta aquí...',
      'thinking': 'Pensando...',
      'you': 'Tú',
      'relevance': 'Relevancia',
      'newConversation': 'Nueva conversación',
      'history': 'Historial',
      'settings': 'Configuración',
      'logout': 'Cerrar sesión',
      'foundResults': 'Encontré',
      'relevantDocuments': 'documentos relevantes',
      'errorOccurred': 'Ocurrió un error:',
      'queryHistory': 'Historial de consultas',
      'noSearches': 'No hay búsquedas anteriores',
      'results': 'resultados',
      'darkTheme': 'Modo oscuro',
      'language': 'Idioma',
      'about': 'Acerca de',
      'selectLanguage': 'Seleccionar idioma',
      'spanish': 'Español',
      'english': 'English',
      'version': 'Versión 1.0.0',
      'description': 'Asistente de IA especializado en documentos legales y normativas. Desarrollado con Flutter y tecnologías de procesamiento de lenguaje natural.',
      'close': 'Cerrar',
    },
    'en': {
      'appTitle': 'Villaneta AI',
      'hello': 'Hello! How can I help you?',
      'subtitle': 'Ask about regulations, norms, or legal documents',
      'publicContracts': 'Public contracts',
      'dataProtection': 'Data protection',
      'environmentalNorms': 'Environmental norms',
      'humanResources': 'Human resources',
      'typeQuery': 'Type your query here...',
      'thinking': 'Thinking...',
      'you': 'You',
      'relevance': 'Relevance',
      'newConversation': 'New conversation',
      'history': 'History',
      'settings': 'Settings',
      'logout': 'Logout',
      'foundResults': 'Found',
      'relevantDocuments': 'relevant documents',
      'errorOccurred': 'An error occurred:',
      'queryHistory': 'Query history',
      'noSearches': 'No previous searches',
      'results': 'results',
      'darkTheme': 'Dark mode',
      'language': 'Language',
      'about': 'About',
      'selectLanguage': 'Select language',
      'spanish': 'Español',
      'english': 'English',
      'version': 'Version 1.0.0',
      'description': 'AI assistant specialized in legal documents and regulations. Developed with Flutter and natural language processing technologies.',
      'close': 'Close',
    },
  };

  String getText(String key) {
    return _texts[_languageCode]?[key] ?? key;
  }

  // ✅ OPTIMIZADO: Init rápido + carga en background
  Future<void> init() async {
    // Marcar como inicializado inmediatamente con valores por defecto
    _isInitialized = true;
    notifyListeners();
    
    // Cargar configuraciones guardadas en background
    _loadSettingsInBackground();
  }

  // ✅ OPTIMIZADO: Carga asíncrona sin bloquear UI
  void _loadSettingsInBackground() async {
    try {
      final isDark = await _settingsService.isDarkMode();
      final language = await _settingsService.getLanguage();
      
      // Solo actualizar si los valores cambiaron
      if (_isDarkMode != isDark || _languageCode != language) {
        _isDarkMode = isDark;
        _languageCode = language;
        
        print('🚀 Configuración cargada: Modo=${_isDarkMode ? "Oscuro" : "Claro"}, Idioma=$_languageCode');
        notifyListeners();
      }
    } catch (e) {
      print('⚠️ Error cargando configuración (usando valores por defecto): $e');
    }
  }

  // ✅ OPTIMIZADO: Toggle más rápido
  Future<void> toggleTheme() async {
    // Cambiar inmediatamente en UI
    _isDarkMode = !_isDarkMode;
    notifyListeners();
    
    // Guardar en background
    _settingsService.setDarkMode(_isDarkMode).catchError((e) {
      print('❌ Error guardando tema: $e');
    });
    
    print('🎨 Tema cambiado a: ${_isDarkMode ? "Oscuro" : "Claro"}');
  }

  // ✅ OPTIMIZADO: Cambio de idioma más rápido
  Future<void> setLanguage(String languageCode) async {
    if (_languageCode == languageCode) return;
    
    // Cambiar inmediatamente en UI
    _languageCode = languageCode;
    notifyListeners();
    
    // Guardar en background
    _settingsService.setLanguage(languageCode).catchError((e) {
      print('❌ Error guardando idioma: $e');
    });
    
    print('🌍 Idioma cambiado a: $languageCode');
  }
}