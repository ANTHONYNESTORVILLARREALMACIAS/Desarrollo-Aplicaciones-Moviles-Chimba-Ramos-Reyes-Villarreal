import 'package:pry_caso4_villarreal_ramos_prueba/domain/entities/user.dart';
import 'package:pry_caso4_villarreal_ramos_prueba/data/databases/api_service.dart';
import 'package:pry_caso4_villarreal_ramos_prueba/domain/entities/post.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository(this.apiService);

  Future<List<User>> getUsers() async {
    return await apiService.getUsers();
  }

  Future<List<Post>> getPostsByUser(int userId) async {
    return await apiService.getPostsByUser(userId);
  }
}