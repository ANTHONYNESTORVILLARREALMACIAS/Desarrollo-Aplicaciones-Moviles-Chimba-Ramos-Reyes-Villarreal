class SearchResult {
  final String documentId;
  final String text;
  final String summary;
  final double distance;

  SearchResult({
    required this.documentId,
    required this.text,
    required this.summary,
    required this.distance,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    try {
      return SearchResult(
        documentId: json['document_id']?.toString() ?? 'unknown',
        text: json['text']?.toString() ?? '',
        summary: json['summary']?.toString() ?? 'Sin resumen disponible',
        distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      );
    } catch (e) {
      print('❌ Error parsing SearchResult: $e');
      print('❌ JSON problemático: $json');
      // Devolver un resultado por defecto en lugar de fallar
      return SearchResult(
        documentId: 'error',
        text: 'Error al parsear resultado',
        summary: 'Error en el formato de datos',
        distance: 999.0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'document_id': documentId,
      'text': text,
      'summary': summary,
      'distance': distance,
    };
  }
}