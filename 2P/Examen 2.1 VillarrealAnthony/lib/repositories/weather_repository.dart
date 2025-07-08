import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherRepository {
  final WeatherService _weatherService = WeatherService();

  Future<WeatherData> getWeather(String city) async {
    return await _weatherService.fetchWeather(city);
  }
}