import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/weather_model.dart';
import '../../viewmodels/weather_viewmodel.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<WeatherViewModel>(context, listen: false);
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Clima Actual',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCityInput(viewModel, theme),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: viewModel.fetchWeather,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'BUSCAR CLIMA',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Consumer<WeatherViewModel>(
            builder: (context, vm, child) {
              if (vm.isLoading) {
                return const CircularProgressIndicator();
              }

              if (vm.errorMessage.isNotEmpty) {
                return Card(
                  elevation: 4,
                  color: Colors.red[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      vm.errorMessage,
                      style: TextStyle(
                        color: Colors.red[800],
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              }

              if (vm.weather != null) {
                return _buildWeatherCard(vm.weather!, theme, vm);
              }

              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCityInput(WeatherViewModel viewModel, ThemeData theme) {
    return TextField(
      controller: viewModel.cityController,
      decoration: InputDecoration(
        labelText: 'Ciudad',
        labelStyle: TextStyle(color: theme.colorScheme.primary),
        hintText: 'Ej: Madrid, Bogotá, Tokio',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2),
        ),
        suffixIcon: Icon(
          Icons.search,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildWeatherCard(WeatherData weather, ThemeData theme, WeatherViewModel vm) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: theme.colorScheme.secondary.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              weather.city,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  vm.getWeatherIconUrl(weather.iconCode),
                  width: 80,
                  height: 80,
                ),
                const SizedBox(width: 10),
                Text(
                  '${weather.temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              weather.description,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            _buildWeatherDetail('Sensación', '${weather.feelsLike.toStringAsFixed(1)}°C', theme),
            _buildWeatherDetail('Humedad', '${weather.humidity}%', theme),
            _buildWeatherDetail('Viento', '${weather.windSpeed.toStringAsFixed(1)} km/h', theme),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}