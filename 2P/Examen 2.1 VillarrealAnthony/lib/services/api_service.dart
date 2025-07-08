import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class ApiService {
  final String baseUrl = 'https://pokeapi.co/api/v2';
  final Duration timeout = const Duration(seconds: 15);

  Future<List<PokemonListItem>> fetchPokemonList({int limit = 20}) async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/pokemon?limit=$limit'))
          .timeout(timeout, onTimeout: () => throw TimeoutException('La conexión tardó demasiado'));

      if (response.statusCode == 200) {
        final data = PokemonListResponse.fromJson(json.decode(response.body));
        return data.results;
      } else {
        throw HttpException('Error al cargar Pokémon: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      throw TimeoutException('Tiempo de espera agotado: $e');
    } catch (e) {
      throw Exception('Error desconocido: $e');
    }
  }

  Future<Pokemon> fetchPokemonDetails(String url) async {
    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(timeout, onTimeout: () => throw TimeoutException('La conexión tardó demasiado'));

      if (response.statusCode == 200) {
        return Pokemon.fromJson(json.decode(response.body));
      } else {
        throw HttpException('Error al cargar detalles: ${response.statusCode}');
      }
    } on TimeoutException catch (e) {
      throw TimeoutException('Tiempo de espera agotado: $e');
    } catch (e) {
      throw Exception('Error desconocido: $e');
    }
  }
}

class HttpException implements Exception {
  final String message;
  HttpException(this.message);

  @override
  String toString() => message;
}