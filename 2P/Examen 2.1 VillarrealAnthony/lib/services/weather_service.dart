import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  final String apiKey = 'tu_api_key_de_openweathermap'; // Reemplaza con tu API key
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<WeatherData> fetchWeather(String city) async {
    final response = await http.get(
      Uri.parse('$baseUrl?q=$city&appid=$apiKey&units=metric&lang=es'),
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar los datos del clima');
    }
  }
}