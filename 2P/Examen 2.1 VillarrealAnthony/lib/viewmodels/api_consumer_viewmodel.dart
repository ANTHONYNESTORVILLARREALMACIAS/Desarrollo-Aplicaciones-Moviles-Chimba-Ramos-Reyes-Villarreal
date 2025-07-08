import 'package:flutter/material.dart';
import '../models/pokemon_model.dart';
import '../repositories/pokemon_repository.dart';

class ApiConsumerViewModel with ChangeNotifier {
  final PokemonRepository _repository = PokemonRepository();
  List<PokemonListItem> _pokemonList = [];
  Pokemon? _selectedPokemon;
  bool _isLoading = false;
  String? _errorMessage;

  List<PokemonListItem> get pokemonList => _pokemonList;
  Pokemon? get selectedPokemon => _selectedPokemon;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadPokemonList() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _pokemonList = await _repository.getPokemonList(limit: 20);
    } catch (e) {
      _errorMessage = 'Error al cargar Pokémon: ${e.toString()}';
      debugPrint('Error loading Pokémon: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPokemonDetails(String url) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _selectedPokemon = await _repository.getPokemonDetails(url);
    } catch (e) {
      _errorMessage = 'Error al cargar detalles: ${e.toString()}';
      debugPrint('Error loading details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}