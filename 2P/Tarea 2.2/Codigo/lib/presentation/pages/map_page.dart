import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter_compass/flutter_compass.dart';

import '../providers/location_providers.dart';
import '../widgets/location_widgets.dart';
import '../widgets/location_search_widget.dart'; // Importa el widget SearchBarWidget

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  MapType _currentMapType = MapType.normal;
  final _smoothingFactor = 0.1;
  
  @override
  void initState() {
    super.initState();
    _initLocation();
    _initSensors();
  }
  
  void _initLocation() async {
    // Inicializar ubicación usando el provider
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    await locationProvider.initLocation();
    
    // Configurar stream de ubicación
    Geolocator.getPositionStream().listen((Position position) {
      locationProvider.updateLocation(position.latitude, position.longitude);
    });
  }
  
  void _initSensors() {
    final sensorProvider = Provider.of<SensorProvider>(context, listen: false);
    
    // Brújula
    FlutterCompass.events?.listen((CompassEvent event) {
      sensorProvider.updateCompassDirection(_getDirection(event.heading ?? 0));
    });

    // Acelerómetro con filtro de suavizado
    List<double> smoothValues = [0.0, 0.0, 0.0];
    accelerometerEvents.listen((AccelerometerEvent event) {
      // Aplicar filtro de paso bajo para suavizar valores
      smoothValues[0] = smoothValues[0] * (1 - _smoothingFactor) + 
                        event.x * _smoothingFactor;
      smoothValues[1] = smoothValues[1] * (1 - _smoothingFactor) + 
                        event.y * _smoothingFactor;
      smoothValues[2] = smoothValues[2] * (1 - _smoothingFactor) + 
                        event.z * _smoothingFactor;
                        
      sensorProvider.updateAccelerometerValues(smoothValues);
    });
  }

  String _getDirection(double heading) {
    if (heading >= 337.5 || heading < 22.5) return 'N';
    if (heading >= 22.5 && heading < 67.5) return 'NE';
    if (heading >= 67.5 && heading < 112.5) return 'E';
    if (heading >= 112.5 && heading < 157.5) return 'SE';
    if (heading >= 157.5 && heading < 202.5) return 'S';
    if (heading >= 202.5 && heading < 247.5) return 'SW';
    if (heading >= 247.5 && heading < 292.5) return 'W';
    if (heading >= 292.5 && heading < 337.5) return 'NW';
    return 'N/A';
  }
  
  Future<void> _showMapTypeSelector() {
    return showModalBottomSheet(
      context: context,
      builder: (context) => MapTypeSelector(
        onMapTypeSelected: (mapType) async {
          setState(() {
            _currentMapType = mapType;
          });
        },
      ),
    );
  }
  
  Future<void> _centerOnCurrentLocation() async {
    final locationProvider = Provider.of<LocationProvider>(context, listen: false);
    if (locationProvider.currentPosition == null) return;
    
    final controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(locationProvider.currentPosition!, 15),
    );
  }
  
  Future<void> _setMapDarkMode(GoogleMapController controller) async {
    String style = '''
    [
      {
        "elementType": "geometry",
        "stylers": [{"color": "#212121"}]
      },
      {
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#757575"}]
      },
      {
        "elementType": "labels.text.stroke",
        "stylers": [{"color": "#212121"}]
      },
      {
        "featureType": "administrative",
        "elementType": "geometry",
        "stylers": [{"color": "#757575"}]
      },
      {
        "featureType": "administrative.country",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#9e9e9e"}]
      },
      {
        "featureType": "administrative.locality",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#bdbdbd"}]
      },
      {
        "featureType": "poi",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#757575"}]
      },
      {
        "featureType": "poi.park",
        "elementType": "geometry",
        "stylers": [{"color": "#181818"}]
      },
      {
        "featureType": "poi.park",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#616161"}]
      },
      {
        "featureType": "road",
        "elementType": "geometry.fill",
        "stylers": [{"color": "#2c2c2c"}]
      },
      {
        "featureType": "road",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#8a8a8a"}]
      },
      {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [{"color": "#373737"}]
      },
      {
        "featureType": "road.highway",
        "elementType": "geometry",
        "stylers": [{"color": "#3c3c3c"}]
      },
      {
        "featureType": "road.highway.controlled_access",
        "elementType": "geometry",
        "stylers": [{"color": "#4e4e4e"}]
      },
      {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#616161"}]
      },
      {
        "featureType": "transit",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#757575"}]
      },
      {
        "featureType": "water",
        "elementType": "geometry",
        "stylers": [{"color": "#000000"}]
      },
      {
        "featureType": "water",
        "elementType": "labels.text.fill",
        "stylers": [{"color": "#3d3d3d"}]
      }
    ]
    ''';
    
    await controller.setMapStyle(style);
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProvider>(context);
    final sensorProvider = Provider.of<SensorProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa con Geolocalización'),
        elevation: isDarkMode ? 0 : 4,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
            onPressed: () {
              themeProvider.toggleTheme();
              _controller.future.then((controller) {
                if (isDarkMode) {
                  controller.setMapStyle(null); // Estilo de mapa predeterminado
                } else {
                  _setMapDarkMode(controller); // Estilo de mapa oscuro
                }
              });
            },
            tooltip: 'Cambiar tema',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Mapa de Google
          locationProvider.currentPosition == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Obteniendo ubicación...'),
                    ],
                  ),
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: locationProvider.currentPosition!,
                    zoom: 15,
                  ),
                  markers: locationProvider.markers,
                  mapType: _currentMapType,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  compassEnabled: true,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    if (isDarkMode) {
                      _setMapDarkMode(controller);
                    }
                  },
                ),
          
          // Widget de búsqueda
          SearchBarWidget(
            onPlaceSelected: (latitude, longitude, title) async {
              final newLatLng = LatLng(latitude, longitude);
              final controller = await _controller.future;
              controller.animateCamera(CameraUpdate.newLatLngZoom(newLatLng, 15));
              locationProvider.addSearchMarker(newLatLng, title);
            },
          ),  
                    
          // Panel de información
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: InfoPanel(
              latitude: locationProvider.currentPosition?.latitude,
              longitude: locationProvider.currentPosition?.longitude,
              address: locationProvider.currentAddress,
              compassDirection: sensorProvider.compassDirection,
              accelerometerData: sensorProvider.accelerometerData,
              isDarkMode: isDarkMode,
            ),
          ),
          
          // Botones de control
          Positioned(
            top: 100,
            right: 15,
            child: Column(
              children: [
                MapButton(
                  icon: Icons.layers,
                  onPressed: _showMapTypeSelector,
                  isDarkMode: isDarkMode,
                ),
                MapButton(
                  icon: Icons.my_location,
                  onPressed: _centerOnCurrentLocation,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}