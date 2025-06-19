import 'package:flutter/material.dart';
import 'package:pry_caso4_villarreal_ramos_prueba/application/usecases/get_users_usecase.dart';
import 'package:pry_caso4_villarreal_ramos_prueba/data/databases/api_service.dart';
import 'package:pry_caso4_villarreal_ramos_prueba/data/repositories/user_repository.dart';
import 'package:pry_caso4_villarreal_ramos_prueba/domain/entities/user.dart';
import 'package:pry_caso4_villarreal_ramos_prueba/domain/entities/post.dart';

class UserProvider with ChangeNotifier {
  final GetUsersUseCase getUsersUseCase;
  List<User> users = [];
  List<User> filteredUsers = [];
  List<Post> userPosts = [];
  bool isLoading = false;
  String? error;

  UserProvider()
      : getUsersUseCase = GetUsersUseCase(
    UserRepository(ApiService()),
  );

  Future<void> fetchUsers() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      users = await getUsersUseCase.execute();
      filteredUsers = users;
      print('Fetched ${users.length} users'); // Debug
    } catch (e) {
      error = e.toString();
      print('Fetch Users Error: $e'); // Debug
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPostsByUser(int userId) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      userPosts = await UserRepository(ApiService()).getPostsByUser(userId);
      print('Fetched ${userPosts.length} posts for user $userId'); // Debug
    } catch (e) {
      error = e.toString();
      print('Fetch Posts Error: $e'); // Debug
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void filterUsers(String query) {
    if (query.isEmpty) {
      filteredUsers = users;
    } else {
      filteredUsers = users
          .where((user) =>
          user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    print('Filtered ${filteredUsers.length} users for query: $query'); // Debug
    notifyListeners();
  }
}