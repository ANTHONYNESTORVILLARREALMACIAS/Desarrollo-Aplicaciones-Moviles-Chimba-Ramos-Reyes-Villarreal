class SearchRequest {
  final String query;
  final String userId;

  SearchRequest({required this.query, this.userId = 'usuario_demo'});

  Map<String, dynamic> toJson() => {
    'query': query,
    'user_id': userId,
  };
}