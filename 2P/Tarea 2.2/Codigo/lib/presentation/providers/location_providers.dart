import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geocoding/geocoding.dart' as geo;
import '../../application/usecases/location_usecase.dart';
import '../../data/datasource/location_datasource.dart';
import '../../data/repositories/location_repository_imp.dart';

class LocationProvider with ChangeNotifier {
  LatLng? _currentPosition;
  Set<Marker> _markers = {};
  String _currentAddress = "Obteniendo dirección...";
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;

  LatLng? get currentPosition => _currentPosition;
  Set<Marker> get markers => _markers;
  String get currentAddress => _currentAddress;
  List<Map<String, dynamic>> get searchResults => _searchResults;
  bool get isSearching => _isSearching;

  // API Key para Places API
  final String apiKey = "AIzaSyAl06T1WD9a9krt_REgW8MTUXsgG21VsVk";

  final GetCurrentLocation _getCurrentLocation = GetCurrentLocation(
    LocationRepositoryImpl(LocationDataSource()),
  );

  // Inicializa ubicación actual
  Future<void> initLocation() async {
    try {
      final location = await _getCurrentLocation();
      _currentPosition = LatLng(location.latitude, location.longitude);
      _updateMarker();
      await _getAddressFromLatLng();
      notifyListeners();
    } catch (e) {
      print('Error obteniendo ubicación: $e');
    }
  }

  // Actualiza la ubicación con una nueva posición
  void updateLocation(double latitude, double longitude) {
    _currentPosition = LatLng(latitude, longitude);
    _updateMarker();
    _getAddressFromLatLng();
    notifyListeners();
  }

  // Añade un marcador para la ubicación actual
  void _updateMarker() {
    if (_currentPosition == null) return;

    // Remover marcador anterior de ubicación actual si existe
    _markers.removeWhere(
      (marker) => marker.markerId.value == 'current_location',
    );

    // Añadir nuevo marcador para ubicación actual
    _markers.add(
      Marker(
        markerId: MarkerId('current_location'),
        position: _currentPosition!,
        infoWindow: InfoWindow(title: 'Ubicación actual'),
      ),
    );
  }

  // Obtiene la dirección a partir de coordenadas usando Google Places API
  Future<void> _getAddressFromLatLng() async {
    if (_currentPosition == null) return;

    try {
      _currentAddress = "Obteniendo dirección...";
      notifyListeners();

      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?'
        'latlng=${_currentPosition!.latitude},${_currentPosition!.longitude}'
        '&key=$apiKey&language=es'
      );

      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['results'].isNotEmpty) {
          _currentAddress = data['results'][0]['formatted_address'];
        } else {
          // Si falla la API, intentar con el paquete geocoding local
          _getAddressFromLocalGeocoding();
        }
      } else {
        // Si falla la conexión, intentar con el paquete geocoding local
        _getAddressFromLocalGeocoding();
      }
    } catch (e) {
      // Si hay cualquier error, intentar con el paquete geocoding local
      _getAddressFromLocalGeocoding();
    }
    
    notifyListeners();
  }

  // Método alternativo que usa el paquete geocoding local
  Future<void> _getAddressFromLocalGeocoding() async {
    try {
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        localeIdentifier: 'es',
      );

      if (placemarks.isNotEmpty) {
        geo.Placemark place = placemarks[0];
        _currentAddress = _formatAddress(place);
      } else {
        _currentAddress = "No se pudo obtener la dirección";
      }
    } catch (e) {
      _currentAddress = "Error al obtener dirección";
      print('Error obteniendo dirección local: $e');
    }
  }

  String _formatAddress(geo.Placemark place) {
    List<String> addressParts = [
      place.street ?? '',
      place.subLocality ?? '',
      place.locality ?? '',
      place.administrativeArea ?? '',
      place.postalCode ?? '',
      place.country ?? '',
    ];

    // Filtrar partes vacías y unir con comas
    return addressParts.where((part) => part.isNotEmpty).join(', ');
  }

  // Añade un marcador para búsqueda
  void addSearchMarker(LatLng position, String title) {
    // Remover marcador anterior de búsqueda si existe
    _markers.removeWhere((marker) => marker.markerId.value == 'search_result');

    _markers.add(
      Marker(
        markerId: MarkerId('search_result'),
        position: position,
        infoWindow: InfoWindow(title: title),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
      ),
    );
    notifyListeners();
  }

  // Buscar lugares con la API de Places
  Future<void> searchPlacesSuggestions(String query) async {
    if (query.length < 2) {
      _searchResults = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      // Consulta de autocompletado a la API de Places
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?'
        'input=${Uri.encodeComponent(query)}'
        '&key=$apiKey'
        '&language=es'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          _searchResults = List<Map<String, dynamic>>.from(
            data['predictions'].map((prediction) => {
              'description': prediction['description'],
              'place_id': prediction['place_id'],
              'structured_formatting': {
                'main_text': prediction['structured_formatting']['main_text'],
                'secondary_text': prediction['structured_formatting']['secondary_text'],
              }
            }),
          );
        } else {
          print('Error en API Places: ${data['status']}');
          _searchResults = [];
        }
      } else {
        print('Error en HTTP: ${response.statusCode}');
        _searchResults = [];
      }
    } catch (e) {
      print('Error buscando lugares: $e');
      _searchResults = [];
    }

    _isSearching = false;
    notifyListeners();
  }

  // Obtener detalles de un lugar por su ID
  Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    _isSearching = true;
    notifyListeners();

    try {
      final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?'
        'place_id=$placeId'
        '&fields=geometry,formatted_address,name'
        '&key=$apiKey'
        '&language=es'
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        _isSearching = false;
        notifyListeners();

        if (data['status'] == 'OK') {
          return data['result'];
        } else {
          print('Error obteniendo detalles: ${data['status']}');
          return null;
        }
      } else {
        print('Error HTTP: ${response.statusCode}');
        _isSearching = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      print('Error: $e');
      _isSearching = false;
      notifyListeners();
      return null;
    }
  }

  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  void setSearchingStatus(bool status) {
    _isSearching = status;
    notifyListeners();
  }
}

// SensorProvider y ThemeProvider sin cambios
class SensorProvider with ChangeNotifier {
  String _compassDirection = 'N/A';
  List<double> _accelerometerValues = [0.0, 0.0, 0.0];

  String get compassDirection => _compassDirection;
  List<double> get accelerometerValues => _accelerometerValues;
  String get accelerometerData =>
      'X: ${_accelerometerValues[0].toStringAsFixed(2)}, '
      'Y: ${_accelerometerValues[1].toStringAsFixed(2)}, '
      'Z: ${_accelerometerValues[2].toStringAsFixed(2)}';

  // Actualiza dirección de la brújula
  void updateCompassDirection(String direction) {
    _compassDirection = direction;
    notifyListeners();
  }

  // Actualiza valores del acelerómetro
  void updateAccelerometerValues(List<double> values) {
    _accelerometerValues = values;
    notifyListeners();
  }
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}