import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'formulariomaps.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(20.484166666667, -99.218888888889);
  final Set<Marker> _markers = {};
  Marker? _selectedMarker;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _handleMapLongPress(LatLng position) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MarkerFormScreen(position: position, isEditing: false),
      ),
    );

    if (result != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId(
              '${position.latitude}-${position.longitude}-${DateTime.now().millisecondsSinceEpoch}',
            ),
            position: position,
            infoWindow: InfoWindow(
              title: result['title'],
              snippet: result['description'],
            ),
            onTap:
                () => _onMarkerTapped(
                  Marker(
                    markerId: MarkerId(
                      '${position.latitude}-${position.longitude}-${DateTime.now().millisecondsSinceEpoch}',
                    ),
                    position: position,
                    infoWindow: InfoWindow(
                      title: result['title'],
                      snippet: result['description'],
                    ),
                  ),
                ),
          ),
        );
      });
    }
  }

  void _onMarkerTapped(Marker marker) {
    setState(() {
      _selectedMarker = marker;
    });

    // Mostrar opciones para editar/eliminar
    _showMarkerOptions(marker);
  }

  void _showMarkerOptions(Marker marker) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Editar marcador'),
                onTap: () {
                  Navigator.pop(context);
                  _editMarker(marker);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text(
                  'Eliminar marcador',
                  style: TextStyle(color: Colors.red, fontFamily: 'McLaren',),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _deleteMarker(marker);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editMarker(Marker marker) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => MarkerFormScreen(
              position: marker.position,
              isEditing: true,
              initialTitle: marker.infoWindow.title,
              initialDescription: marker.infoWindow.snippet,
            ),
      ),
    );

    if (result != null) {
      setState(() {
        _markers.remove(marker);
        _markers.add(
          Marker(
            markerId: marker.markerId,
            position: marker.position,
            infoWindow: InfoWindow(
              title: result['title'],
              snippet: result['description'],
            ),
            onTap:
                () => _onMarkerTapped(
                  Marker(
                    markerId: marker.markerId,
                    position: marker.position,
                    infoWindow: InfoWindow(
                      title: result['title'],
                      snippet: result['description'],
                    ),
                  ),
                ),
          ),
        );
      });
    }
  }

  void _deleteMarker(Marker marker) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar marcador'),
          content: const Text(
            '¿Estás seguro de que quieres eliminar este marcador?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _markers.remove(marker);
                });
                Navigator.pop(context);
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.red, fontFamily: 'McLaren',),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mapa',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontFamily: 'McLaren',),
        ),
        backgroundColor: const Color.fromARGB(255, 116, 76, 137),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
        markers:
            _markers
                .map(
                  (marker) => marker.copyWith(
                    onTapParam: () => _onMarkerTapped(marker),
                  ),
                )
                .toSet(),
        onLongPress: _handleMapLongPress,
      ),
    );
  }
}
