import '../models/post_model.dart';
import '../services/api_service.dart';

class PostRepository {
  final ApiService _apiService = ApiService();

  Future<List<Post>> getPosts() async {
    return await _apiService.fetchPosts();
  }
}