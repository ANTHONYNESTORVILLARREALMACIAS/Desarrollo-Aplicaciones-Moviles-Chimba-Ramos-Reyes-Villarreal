class SearchHistory {
  final String id;
  final String query;
  final String userId;
  final DateTime timestamp;
  final int resultsCount;

  SearchHistory({
    required this.id,
    required this.query,
    required this.userId,
    required this.timestamp,
    required this.resultsCount,
  });

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      id: json['id'],
      query: json['query'],
      userId: json['user_id'],
      timestamp: DateTime.parse(json['timestamp']),
      resultsCount: json['results_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'query': query,
      'user_id': userId,
      'timestamp': timestamp.toIso8601String(),
      'results_count': resultsCount,
    };
  }

  
}