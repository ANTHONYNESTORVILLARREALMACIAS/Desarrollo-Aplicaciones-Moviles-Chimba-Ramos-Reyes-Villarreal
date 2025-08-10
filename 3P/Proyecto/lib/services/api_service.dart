import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/search_result.dart';
import '../config/app_config.dart';

class ApiService {
  static Future<List<SearchResult>> searchDocuments(String query, String userId) async {
    try {
      print('🚀 Enviando request a: ${AppConfig.serverUrl}/search');
      print('📝 Query: $query');
      print('👤 User ID: $userId');

      final response = await http.post(
        Uri.parse('${AppConfig.serverUrl}/search'),
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': 'true',
        },
        body: jsonEncode({
          'query': query,
          'user_id': userId,
        }),
      ).timeout(Duration(seconds: AppConfig.timeoutSeconds));

      print('📡 Status Code: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Decodificar la respuesta JSON
        final dynamic decodedResponse = jsonDecode(response.body);
        print('🔍 Decoded Response Type: ${decodedResponse.runtimeType}');

        // Verificar si es una lista
        if (decodedResponse is List) {
          print('✅ Resultados encontrados: ${decodedResponse.length}');
          
          List<SearchResult> results = decodedResponse.map<SearchResult>((json) {
            return SearchResult.fromJson(json as Map<String, dynamic>);
          }).toList();
          
          print('🎉 Resultados convertidos exitosamente: ${results.length}');
          for (var result in results) {
            print('  📄 ${result.documentId}: ${result.summary.substring(0, 50)}...');
          }
          
          return results;
        } else {
          print('❌ Error: La respuesta no es una lista');
          print('❌ Tipo recibido: ${decodedResponse.runtimeType}');
          return [];
        }
      } else {
        print('❌ Error HTTP: ${response.statusCode}');
        print('❌ Error Body: ${response.body}');
        throw Exception('Error en la búsqueda: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Exception en searchDocuments: $e');
      rethrow;
    }
  }
}
