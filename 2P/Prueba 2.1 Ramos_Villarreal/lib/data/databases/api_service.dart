import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pry_caso4_villarreal_ramos_prueba/domain/entities/user.dart';
import 'package:pry_caso4_villarreal_ramos_prueba/domain/entities/post.dart';

class ApiService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<User>> getUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));
      print('Get Users Response Status: ${response.statusCode}'); // Debug
      print('Get Users Response Body: ${response.body}'); // Debug
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('Get Users Error: $e'); // Debug
      rethrow;
    }
  }

  Future<List<Post>> getPostsByUser(int userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users/$userId/posts'));
      print('Get Posts Response Status: ${response.statusCode}'); // Debug
      print('Get Posts Response Body: ${response.body}'); // Debug
      if (response.statusCode == 200) {
        List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Get Posts Error: $e'); // Debug
      rethrow;
    }
  }
}