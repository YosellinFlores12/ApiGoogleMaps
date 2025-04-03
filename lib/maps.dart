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

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _handleMapLongPress(LatLng position) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarkerFormScreen(position: position),
      ),
    );

    if (result != null) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('${position.latitude}-${position.longitude}'),
            position: position,
            infoWindow: InfoWindow(
              title: result['title'],
              snippet: result['description'],
            ),
          ),
        );
      });
    }
  }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicacion', style: TextStyle(fontFamily: 'McLaren', color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 116, 68, 148),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
        markers: _markers,
        onLongPress: _handleMapLongPress,
      ),
    );
  }
}
