import '../models/pokemon_model.dart';
import '../services/api_service.dart';

class PokemonRepository {
  final ApiService _apiService = ApiService();

  Future<List<PokemonListItem>> getPokemonList({int limit = 20}) async {
    return await _apiService.fetchPokemonList(limit: limit);
  }

  Future<Pokemon> getPokemonDetails(String url) async {
    return await _apiService.fetchPokemonDetails(url);
  }
}