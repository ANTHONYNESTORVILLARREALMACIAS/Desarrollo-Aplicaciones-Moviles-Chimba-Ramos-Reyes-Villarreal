class WeatherData {
  final String city;
  final String description;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String iconCode;

  WeatherData({
    required this.city,
    required this.description,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.iconCode,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      city: json['name'],
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      iconCode: json['weather'][0]['icon'],
    );
  }
}