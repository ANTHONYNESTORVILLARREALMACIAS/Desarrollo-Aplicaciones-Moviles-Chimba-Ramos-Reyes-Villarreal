import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/location_providers.dart';

class SearchBarWidget extends StatefulWidget {
  final Function(double latitude, double longitude, String title) onPlaceSelected;

  const SearchBarWidget({
    Key? key,
    required this.onPlaceSelected,
  }) : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  FocusNode _focusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        Provider.of<LocationProvider>(context, listen: false).clearSearchResults();
      }
    });
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final locationProvider = Provider.of<LocationProvider>(context);

    return SafeArea(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: 'Buscar lugares...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: _isSearching
                            ? Container(
                                width: 20,
                                height: 20,
                                padding: EdgeInsets.all(0),
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(Icons.clear),
                        onPressed: () {
                          if (!_isSearching) {
                            _searchController.clear();
                            locationProvider.clearSearchResults();
                          }
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 15),
              ),
              onChanged: (value) async {
                setState(() {
                  _isSearching = true;
                });
                await locationProvider.searchPlacesSuggestions(value);
                setState(() {
                  _isSearching = false;
                });
              },
            ),
          ),
          
          // Lista de resultados de búsqueda
          if (locationProvider.searchResults.isNotEmpty && _focusNode.hasFocus)
            Container(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              margin: EdgeInsets.symmetric(horizontal: 16),
              constraints: BoxConstraints(
                maxHeight: 300,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: locationProvider.searchResults.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  final result = locationProvider.searchResults[index];
                  return ListTile(
                    title: Text(
                      result['description'],
                      style: TextStyle(fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () async {
                      setState(() {
                        _isSearching = true;
                        _searchController.text = result['description'];
                      });
                      
                      // Ocultar teclado y perder foco
                      FocusScope.of(context).unfocus();
                      
                      // Obtener detalles del lugar
                      final placeDetails = await locationProvider.getPlaceDetails(result['place_id']);
                      
                      setState(() {
                        _isSearching = false;
                      });
                      
                      if (placeDetails != null) {
                        final location = placeDetails['geometry']['location'];
                        widget.onPlaceSelected(
                          location['lat'], 
                          location['lng'], 
                          result['description']
                        );
                      }
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}