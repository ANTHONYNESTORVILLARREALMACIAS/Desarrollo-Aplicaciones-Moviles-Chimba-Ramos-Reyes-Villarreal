import '../models/post_model.dart';
import '../repositories/post_repository.dart';

class ApiConsumerViewModel {
  final PostRepository _repository = PostRepository();

  Future<List<Post>> getPosts() async {
    return await _repository.getPosts();
  }
}