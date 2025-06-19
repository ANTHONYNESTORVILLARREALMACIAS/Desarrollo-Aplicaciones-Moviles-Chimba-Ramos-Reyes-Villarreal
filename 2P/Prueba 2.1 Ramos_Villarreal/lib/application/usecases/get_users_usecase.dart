import 'package:pry_caso4_villarreal_ramos_prueba/data/repositories/user_repository.dart';
import 'package:pry_caso4_villarreal_ramos_prueba/domain/entities/user.dart';

class GetUsersUseCase {
  final UserRepository repository;

  GetUsersUseCase(this.repository);

  Future<List<User>> execute() async {
    return await repository.getUsers();
  }
}