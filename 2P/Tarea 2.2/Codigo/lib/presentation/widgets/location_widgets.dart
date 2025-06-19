import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InfoPanel extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final String address;
  final String compassDirection;
  final String accelerometerData;
  final bool isDarkMode;

  const InfoPanel({
    Key? key,
    this.latitude,
    this.longitude,
    required this.address,
    required this.compassDirection,
    required this.accelerometerData,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isDarkMode 
            ? Colors.grey[800]!.withOpacity(0.9) 
            : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Datos de ubicación
          _buildLocationInfo(),
          
          Divider(color: isDarkMode ? Colors.grey[600] : Colors.grey[300]),
          
          // Datos de sensores
          _buildSensorInfo(),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 6),
        ...items.map((item) => Padding(
          padding: EdgeInsets.only(left: 8, bottom: 4),
          child: Text(
            item,
            style: TextStyle(fontSize: 13),
            maxLines: item.startsWith('Dirección:') ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
        )),
      ],
    );
  }

  Widget _buildLocationInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on, size: 18, color: Colors.red),
            SizedBox(width: 4),
            Text('Ubicación', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            'Lat: ${latitude?.toStringAsFixed(5) ?? 'N/A'}, '
            'Lng: ${longitude?.toStringAsFixed(5) ?? 'N/A'}',
            style: TextStyle(fontSize: 13),
          ),
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            address,
            style: TextStyle(fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSensorInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.compass_calibration, size: 18, color: Colors.blue),
            SizedBox(width: 4),
            Text('Sensores', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            'Dirección: $compassDirection',
            style: TextStyle(fontSize: 13),
          ),
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.only(left: 8),
          child: Text(
            'Acelerómetro: $accelerometerData',
            style: TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}

// Mantén las otras clases sin cambios...
class MapButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isDarkMode;

  const MapButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.isDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      margin: EdgeInsets.only(bottom: 8),
      child: FloatingActionButton(
        heroTag: icon.codePoint.toString(),
        mini: true,
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black87,
        elevation: 4,
        onPressed: onPressed,
        child: Icon(icon, size: 20),
      ),
    );
  }
}

class MapTypeSelector extends StatelessWidget {
  final Function(MapType) onMapTypeSelected;

  const MapTypeSelector({Key? key, required this.onMapTypeSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Tipo de mapa', 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 15),
          _buildMapTypeOption(context, 'Normal', Icons.map, MapType.normal),
          _buildMapTypeOption(context, 'Satélite', Icons.satellite, MapType.satellite),
          _buildMapTypeOption(context, 'Terreno', Icons.terrain, MapType.terrain),
        ],
      ),
    );
  }

  Widget _buildMapTypeOption(BuildContext context, String title, IconData icon, MapType mapType) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        onMapTypeSelected(mapType);
        Navigator.pop(context);
      },
    );
  }
}

class SearchPlaceDialog extends StatefulWidget {
  final Function(String) onSearch;
  final bool isSearching;

  const SearchPlaceDialog({
    Key? key,
    required this.onSearch,
    this.isSearching = false,
  }) : super(key: key);

  @override
  _SearchPlaceDialogState createState() => _SearchPlaceDialogState();
}

class _SearchPlaceDialogState extends State<SearchPlaceDialog> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Buscar lugar'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Ej: Cancún, México',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            autofocus: true,
            onSubmitted: (_) {
              if (_searchController.text.isNotEmpty) {
                widget.onSearch(_searchController.text);
                Navigator.pop(context);
              }
            },
          ),
          if (widget.isSearching)
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: widget.isSearching 
              ? null 
              : () {
                  if (_searchController.text.isNotEmpty) {
                    widget.onSearch(_searchController.text);
                    Navigator.pop(context);
                  }
                },
          child: Text('Buscar'),
        ),
      ],
    );
  }
}