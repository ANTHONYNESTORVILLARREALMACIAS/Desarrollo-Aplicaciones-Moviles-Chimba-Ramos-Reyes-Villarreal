import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../repositories/weather_repository.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _repository = WeatherRepository();
  final TextEditingController cityController = TextEditingController();
  WeatherData? _weather;
  bool _isLoading = false;
  String _errorMessage = '';

  WeatherData? get weather => _weather;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchWeather() async {
    if (cityController.text.isEmpty) return;

    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _weather = await _repository.getWeather(cityController.text);
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }
}